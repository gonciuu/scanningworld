import { IsNotEmpty } from 'class-validator';

export class CreateRegionDto {
  @IsNotEmpty()
  readonly name: string;
}
