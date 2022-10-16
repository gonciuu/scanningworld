import { IsNotEmpty, IsNumber } from 'class-validator';

export class CreateCouponDto {
  @IsNotEmpty()
  readonly name: string;

  @IsNotEmpty()
  readonly imageUri: string;

  @IsNotEmpty()
  readonly regionId: string;

  @IsNumber()
  readonly points: number;
}
