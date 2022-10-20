import { IsEnum } from 'class-validator';

import { Avatar } from '../types/avatar.type';

export class UpdateUserAvatarDto {
  @IsEnum(['male1', 'male2', 'male3', 'female1', 'female2', 'female3'])
  readonly avatar: Avatar;
}
