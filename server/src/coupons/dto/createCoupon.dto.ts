import { IsNotEmpty, IsNumber } from 'class-validator';

export class CreateCouponDto {
  @IsNotEmpty()
  readonly name: string;

  readonly imageBase64: string;

  @IsNumber()
  readonly points: number;
}
