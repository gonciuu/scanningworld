import { IsEmail, IsNotEmpty } from 'class-validator';

export class AuthDto {
  @IsNotEmpty()
  readonly phone: string;

  @IsNotEmpty()
  readonly password: string;
}

export class AuthRegionDto {
  @IsEmail()
  readonly email: string;

  @IsNotEmpty()
  readonly password: string;
}
