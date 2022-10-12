import { IsNotEmpty, IsEmail } from 'class-validator';

export class CreateUserDto {
  @IsNotEmpty()
  readonly name: string;

  @IsEmail()
  readonly email: string;

  @IsNotEmpty()
  readonly phone: string;

  @IsNotEmpty()
  readonly region: string;

  @IsNotEmpty()
  readonly password: string;

  readonly points: number;

  readonly refreshToken: string;
}
