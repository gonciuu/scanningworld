import { IsNumber } from 'class-validator';

export class ScanPlaceDto {
  @IsNumber()
  readonly lat: number;

  @IsNumber()
  readonly lng: number;
}
