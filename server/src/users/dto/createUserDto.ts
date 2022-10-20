import { IsNotEmpty, IsEmail } from 'class-validator';

import { CouponDocument } from 'src/coupons/schemas/coupon.schema';

import { Avatar } from '../types/avatar.type';

export class CreateUserDto {
  @IsNotEmpty()
  readonly name: string;

  @IsEmail()
  readonly email: string;

  @IsNotEmpty()
  readonly phone: string;

  @IsNotEmpty()
  readonly regionId: string;

  @IsNotEmpty()
  readonly password: string;

  readonly avatar: Avatar;

  readonly activeCoupons: {
    coupon: string | CouponDocument;
    validUntil: Date;
  }[];

  readonly scannedPlaces: string[];

  readonly points: Record<string, number>;

  readonly refreshToken: string;

  readonly passwordResetToken: string;
}
