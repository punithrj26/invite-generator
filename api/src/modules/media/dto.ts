import { IsIn } from 'class-validator';

export const PHOTO_TYPES = {
  'image/jpeg': 'jpg',
  'image/png': 'png',
  'image/webp': 'webp',
} as const;
export type PhotoType = keyof typeof PHOTO_TYPES;

export class UploadUrlDto {
  // shortcut: 'render' (publish images) joins in Sprint 4 with the publish flow.
  @IsIn(['photo'])
  purpose!: 'photo';

  @IsIn(Object.keys(PHOTO_TYPES))
  contentType!: PhotoType;
}
