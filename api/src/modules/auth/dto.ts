import { Transform } from 'class-transformer';
import {
  IsEmail,
  IsOptional,
  IsString,
  Length,
  MaxLength,
} from 'class-validator';

const normalizeEmail = ({ value }: { value: unknown }) =>
  typeof value === 'string' ? value.trim().toLowerCase() : value;
const trim = ({ value }: { value: unknown }) =>
  typeof value === 'string' ? value.trim() : value;

export class RegisterDto {
  @Transform(normalizeEmail)
  @IsEmail()
  @MaxLength(254)
  email!: string;

  /** NIST 800-63B: length, no composition rules. */
  @IsString()
  @Length(10, 128)
  password!: string;

  @Transform(trim)
  @IsString()
  @Length(1, 80)
  name!: string;
}

export class LoginDto {
  @Transform(normalizeEmail)
  @IsEmail()
  @MaxLength(254)
  email!: string;

  @IsString()
  @Length(1, 128)
  password!: string;
}

/** Mobile sends the token in the body; web sends nothing here and relies on the httpOnly cookie. */
export class RefreshTokenDto {
  @IsOptional()
  @IsString()
  @MaxLength(200)
  refreshToken?: string;
}
