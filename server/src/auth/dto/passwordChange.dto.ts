import { IsNotEmpty } from 'class-validator';

export class PasswordChangeDto {
  @IsNotEmpty()
  readonly oldPassword: string;

  @IsNotEmpty()
  readonly newPassword: string;
}
