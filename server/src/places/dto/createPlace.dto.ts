import { IsNotEmpty, IsNumber } from 'class-validator';

export class CreatePlaceDto {
  @IsNotEmpty()
  readonly name: string;

  @IsNotEmpty()
  readonly description: string;

  @IsNotEmpty()
  readonly imageUri: string;

  @IsNotEmpty()
  readonly regionId: string;

  @IsNumber()
  points: number;

  @IsNumber()
  lat: number;

  @IsNumber()
  lng: number;
}
