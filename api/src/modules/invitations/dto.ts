import { Type } from 'class-transformer';
import {
  IsBoolean,
  IsIn,
  IsInt,
  IsMongoId,
  IsObject,
  IsOptional,
  IsString,
  IsTimeZone,
  IsUrl,
  Length,
  Matches,
  Max,
  MaxLength,
  Min,
  ValidateNested,
} from 'class-validator';

import {
  INVITATION_STATUSES,
  type InvitationStatus,
} from './invitation.schema';

const DATE = /^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])$/;
const TIME = /^([01]\d|2[0-3]):[0-5]\d$/;
const E164 = /^\+[1-9]\d{6,14}$/;

// --- event data: one class per event type, picked by `type` (D11) ---

export class BirthdayDataDto {
  @IsIn(['birthday'])
  type!: 'birthday';

  @IsString()
  @Length(1, 60)
  personName!: string;

  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(150)
  age?: number;
}

export type EventDataDto = BirthdayDataDto;
export const EVENT_DATA_TYPES = { birthday: BirthdayDataDto };

// --- details (docs/02 §1.3; date/time are venue wall-clock, D12) ---

class VenueDto {
  @IsString()
  @Length(1, 120)
  name!: string;

  @IsOptional()
  @IsString()
  @MaxLength(300)
  address?: string;

  @IsOptional()
  @IsUrl({ protocols: ['https'], require_protocol: true })
  @MaxLength(500)
  mapUrl?: string;
}

class RsvpDto {
  @IsBoolean()
  enabled!: boolean;

  @IsOptional()
  @Matches(DATE, { message: 'deadline must be YYYY-MM-DD' })
  deadline?: string;

  @IsOptional()
  @Matches(E164, {
    message: 'phone must be in international format, e.g. +919800000000',
  })
  phone?: string;

  @IsOptional()
  @IsString()
  @MaxLength(300)
  note?: string;
}

export class DetailsDto {
  @IsString()
  @Length(1, 100)
  eventName!: string;

  @IsString()
  @Length(1, 80)
  hostName!: string;

  @ValidateNested()
  @Type(() => VenueDto)
  venue!: VenueDto;

  @Matches(DATE, { message: 'date must be YYYY-MM-DD' })
  date!: string;

  @Matches(TIME, { message: 'time must match HH:mm' })
  time!: string;

  @IsTimeZone()
  timezone!: string;

  @IsOptional()
  @IsString()
  @MaxLength(1000)
  description?: string;

  @IsOptional()
  @Matches(E164, {
    message: 'contactPhone must be in international format, e.g. +919800000000',
  })
  contactPhone?: string;

  @ValidateNested()
  @Type(() => RsvpDto)
  rsvp!: RsvpDto;
}

const eventDataType = () =>
  Type(() => Object, {
    discriminator: {
      property: 'type',
      subTypes: Object.entries(EVENT_DATA_TYPES).map(([name, value]) => ({
        name,
        value,
      })),
    },
    keepDiscriminatorProperty: true,
  });

export class CreateInvitationDto {
  @IsObject()
  @ValidateNested()
  @eventDataType()
  eventData!: EventDataDto;

  @ValidateNested()
  @Type(() => DetailsDto)
  details!: DetailsDto;

  @IsOptional()
  @IsMongoId()
  templateId?: string | null;
}

class MediaDto {
  @IsOptional()
  @IsUrl({ require_tld: false, require_protocol: true })
  photoUrl?: string | null;
}

/** PUT replaces every editable field (docs/02 §2.6). */
export class UpdateInvitationDto extends CreateInvitationDto {
  @IsInt()
  @Min(1)
  version!: number;

  @IsOptional()
  @ValidateNested()
  @Type(() => MediaDto)
  media?: MediaDto;
}

export class ListInvitationsQuery {
  @IsOptional()
  @IsIn(INVITATION_STATUSES)
  status?: InvitationStatus;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(50)
  limit = 20;

  @IsOptional()
  @IsString()
  @MaxLength(200)
  cursor?: string;
}
