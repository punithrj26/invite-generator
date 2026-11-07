import { Transform } from 'class-transformer';
import {
  IsOptional,
  IsPhoneNumber,
  IsString,
  Length,
  MaxLength,
} from 'class-validator';

const trim = ({ value }: { value: unknown }) =>
  typeof value === 'string' ? value.trim() : value;

export class UpdateMeDto {
  @IsOptional()
  @Transform(trim)
  @IsString()
  @Length(1, 80)
  name?: string;

  /** E.164, e.g. +919800000000. */
  @IsOptional()
  @IsPhoneNumber(undefined, {
    message: 'phone must be in international format, e.g. +919800000000',
  })
  phone?: string;
}

export class ChangePasswordDto {
  @IsString()
  @MaxLength(128)
  currentPassword!: string;

  @IsString()
  @Length(10, 128)
  newPassword!: string;
}

export class DeleteMeDto {
  @IsString()
  @MaxLength(128)
  password!: string;
}
