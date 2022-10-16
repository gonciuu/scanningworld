import { IsNotEmpty, IsEmail } from 'class-validator';

export class UpdateUserDetailsDto {
  @IsNotEmpty()
  readonly name: string;

  @IsEmail()
  readonly email: string;

  @IsNotEmpty()
  readonly regionId: string;
}
