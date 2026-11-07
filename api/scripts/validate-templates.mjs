// Validates templates/*/template.json: JSON Schema (shape) + semantic rules the schema can't express.
// Usage: node scripts/validate-templates.mjs [templatesDir]   (exit 1 on any error)
import Ajv2020 from 'ajv/dist/2020.js';
import { readFileSync, readdirSync, existsSync } from 'node:fs';
import { join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

// Binding contract with designers — keep in sync with docs/03-template-engine.md §3.1.
const COMMON_PATHS = [
  'details.eventName', 'details.hostName', 'details.description', 'details.contactPhone',
  'details.venue.name', 'details.venue.address', 'details.date', 'details.time', 'details.timezone',
  'details.rsvp.enabled', 'details.rsvp.phone', 'details.rsvp.deadline', 'details.rsvp.note',
  'media.photoUrl',
];
const EVENT_PATHS = {
  birthday: ['event.personName', 'event.age'],
  wedding: ['event.brideName', 'event.groomName'],
  babyShower: ['event.motherName', 'event.fatherName'],
  engagement: [], housewarming: [], corporate: [],
};
const FORMATTERS = new Set(['date', 'time', 'upper', 'lower', 'ordinal', 'default']);
const BINDING = /\{\{\s*([A-Za-z0-9_.]+)\s*(?:\|\s*(\w+)(?::([^}]*))?)?\s*\}\}/g;

/** Relative asset paths resolve against the templates/ dir; https URLs and {{bindings}} are not checked here. */
const isRelativeAsset = (s) => !/^https:\/\//.test(s) && !s.startsWith('{{');

/** @param templatesDir when given, relative asset paths must exist under it (docs/03 §2.3). */
export function semanticErrors(tpl, templatesDir) {
  const errors = [];
  const { canvas, fonts, layers } = tpl.spec;
  const families = new Set(fonts.map((f) => f.family));
  const ids = new Set();

  const checkAsset = (where, path) => {
    if (templatesDir && isRelativeAsset(path) && !existsSync(join(templatesDir, path))) {
      errors.push(`${where}: asset "${path}" not found under templates/`);
    }
  };
  fonts.forEach((f, i) => checkAsset(`fonts[${i}]`, f.url));
  if (tpl.spec.background?.image) checkAsset('background.image.src', tpl.spec.background.image.src);

  const checkPath = (where, path) => {
    for (const type of tpl.eventTypes) {
      if (!COMMON_PATHS.includes(path) && !EVENT_PATHS[type].includes(path)) {
        errors.push(`${where}: unknown binding "${path}" for event type "${type}"`);
      }
    }
  };
  const checkBindings = (where, text) => {
    for (const [, path, formatter] of text.matchAll(BINDING)) {
      checkPath(where, path);
      if (formatter && !FORMATTERS.has(formatter)) errors.push(`${where}: unknown formatter "${formatter}"`);
    }
  };

  if (tpl.spec.background?.image) checkBindings('background.image.src', tpl.spec.background.image.src);
  for (const layer of layers) {
    const where = `layer "${layer.id}"`;
    if (ids.has(layer.id)) errors.push(`${where}: duplicate id`);
    ids.add(layer.id);
    const { x, y, w, h } = layer.frame;
    if (x < 0 || y < 0 || x + w > canvas.width || y + h > canvas.height) {
      errors.push(`${where}: frame lies outside the ${canvas.width}x${canvas.height} canvas`);
    }
    if (layer.visibleIf) checkPath(`${where} visibleIf`, layer.visibleIf.replace(/^!/, ''));
    if (layer.type === 'text') {
      checkBindings(where, layer.text);
      if (!families.has(layer.style.fontFamily)) errors.push(`${where}: font "${layer.style.fontFamily}" not declared in fonts`);
      if (layer.style.minFontSize > layer.style.fontSize) errors.push(`${where}: minFontSize > fontSize`);
    }
    if (layer.type === 'image') {
      checkBindings(where, layer.src);
      checkAsset(where, layer.src);
    }
  }
  return errors;
}

export function validateDir(dir) {
  // discriminator: a bad layer reports errors for its own `type`, not the first oneOf branch (audit L3).
  const ajv = new Ajv2020({ allErrors: true, discriminator: true });
  const validate = ajv.compile(JSON.parse(readFileSync(join(dir, 'schema.v1.json'), 'utf8')));
  const report = {};
  for (const key of readdirSync(dir, { withFileTypes: true }).filter((d) => d.isDirectory()).map((d) => d.name)) {
    const file = join(dir, key, 'template.json');
    if (!existsSync(file)) continue;
    const tpl = JSON.parse(readFileSync(file, 'utf8'));
    const errors = validate(tpl)
      ? semanticErrors(tpl, dir)
      : validate.errors.map((e) => `schema ${e.instancePath || '/'}: ${e.message}`);
    if (tpl.key !== key) errors.push(`key "${tpl.key}" must match folder name "${key}"`);
    report[key] = errors;
  }
  return report;
}

if (process.argv[1] === fileURLToPath(import.meta.url)) {
  const dir = resolve(process.argv[2] ?? join(fileURLToPath(new URL('.', import.meta.url)), '../../templates'));
  const report = validateDir(dir);
  let failed = 0;
  for (const [key, errors] of Object.entries(report)) {
    console.log(`${errors.length ? '✗' : '✓'} ${key}`);
    for (const e of errors) console.log(`    ${e}`);
    failed += errors.length ? 1 : 0;
  }
  if (!Object.keys(report).length) console.log(`No templates found in ${dir}`);
  process.exit(failed ? 1 : 0);
}
