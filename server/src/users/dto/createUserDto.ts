import { IsNotEmpty, IsEmail } from 'class-validator';

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

  readonly scannedPlaces: string[];

  readonly points: Record<string, number>;

  readonly refreshToken: string;

  readonly passwordResetToken: string;
}
