import { IsNotEmpty } from 'class-validator';

export class PasswordResetDto {
  @IsNotEmpty()
  readonly passwordResetToken: string;

  @IsNotEmpty()
  readonly newPassword: string;
}
