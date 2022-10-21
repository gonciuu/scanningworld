import { IsEmail, IsNotEmpty } from 'class-validator';

export class CreateRegionDto {
  @IsNotEmpty()
  readonly name: string;

  @IsEmail()
  readonly email: string;

  @IsNotEmpty()
  readonly password: string;

  readonly refreshToken: string;

  readonly placeCount: number;
}
