import { IsNotEmpty } from 'class-validator';

export class AuthDto {
  @IsNotEmpty()
  readonly phone: string;

  @IsNotEmpty()
  readonly password: string;
}
