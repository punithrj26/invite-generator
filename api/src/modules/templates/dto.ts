import { Type } from 'class-transformer';
import {
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  Max,
  MaxLength,
  Min,
} from 'class-validator';

import { EVENT_TYPES, type EventType } from './template.schema';

export class ListTemplatesQuery {
  @IsOptional()
  @IsIn(EVENT_TYPES)
  eventType?: EventType;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(50)
  limit = 30;

  /** Opaque, from a previous page's `nextCursor`. */
  @IsOptional()
  @IsString()
  @MaxLength(200)
  cursor?: string;
}
