// node --test scripts/
import assert from 'node:assert/strict';
import { cpSync, mkdtempSync, readFileSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { test } from 'node:test';

import { semanticErrors, validateDir } from './validate-templates.mjs';

const templatesDir = fileURLToPath(new URL('../../templates/', import.meta.url));
const example = () =>
  JSON.parse(readFileSync(new URL('../../templates/birthday-balloons/template.json', import.meta.url), 'utf8'));

test('repository templates are valid', () => {
  for (const [key, errors] of Object.entries(validateDir(templatesDir))) {
    assert.deepEqual(errors, [], key);
  }
});

test('semantic rules catch common authoring mistakes', () => {
  const tpl = example();
  const title = tpl.spec.layers.find((l) => l.id === 'title');
  title.text = '{{event.brideName}} {{event.age|shout}}';
  title.style.fontFamily = 'Comic Sans';
  tpl.spec.layers.find((l) => l.id === 'card').frame.x = 900;
  tpl.spec.layers.push({ ...tpl.spec.layers[0] });

  const errors = semanticErrors(tpl).join('\n');
  assert.match(errors, /unknown binding "event.brideName" for event type "birthday"/);
  assert.match(errors, /unknown formatter "shout"/);
  assert.match(errors, /font "Comic Sans" not declared/);
  assert.match(errors, /layer "card": frame lies outside/);
  assert.match(errors, /layer "string-1": duplicate id/);
});

test('relative assets must exist under templates/ (audit M5)', () => {
  const tpl = example();
  tpl.spec.fonts[0].url = 'fonts/missing/Missing.ttf';
  tpl.spec.background.image = { src: 'birthday-balloons/assets/nope.webp' };
  const errors = semanticErrors(tpl, templatesDir).join('\n');
  assert.match(errors, /fonts\[0\]: asset "fonts\/missing\/Missing.ttf" not found/);
  assert.match(errors, /background.image.src: asset "birthday-balloons\/assets\/nope.webp" not found/);
  assert.equal(semanticErrors(example(), templatesDir).length, 0); // the real fonts exist
});

test('schema: bindings take the whole src; layer errors name the layer type (audit M5, L3)', () => {
  const report = (mutate) => {
    const dir = mkdtempSync(join(tmpdir(), 'tpl-'));
    cpSync(templatesDir, dir, { recursive: true });
    const file = join(dir, 'birthday-balloons', 'template.json');
    const tpl = JSON.parse(readFileSync(file, 'utf8'));
    mutate(tpl.spec.layers.find((l) => l.id === 'photo'));
    writeFileSync(file, JSON.stringify(tpl));
    return validateDir(dir)['birthday-balloons'].join('\n');
  };
  assert.match(report((p) => (p.src = '{{media.photoUrl}} junk')), /\/spec\/layers\/8\/src/);
  const fitErrors = report((p) => (p.fit = 'stretch'));
  assert.match(fitErrors, /\/spec\/layers\/8\/fit: must be equal to one of the allowed values/);
  assert.doesNotMatch(fitErrors, /must have required property 'text'/);
});
