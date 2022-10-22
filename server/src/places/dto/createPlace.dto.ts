import { IsNotEmpty, IsNumber } from 'class-validator';

export class CreatePlaceDto {
  @IsNotEmpty()
  readonly name: string;

  @IsNotEmpty()
  readonly description: string;

  readonly imageBase64: string;

  @IsNumber()
  readonly points: number;

  @IsNumber()
  readonly lat: number;

  @IsNumber()
  readonly lng: number;
}
