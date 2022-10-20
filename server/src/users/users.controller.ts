import { Body, Controller, Get, Patch, UseGuards, Req } from '@nestjs/common';

import { Request } from 'express';

import { AccessTokenGuard } from 'src/auth/guards/accessToken.guard';

import { UpdateUserAvatarDto } from './dto/updateUserAvatarDto';
import { UpdateUserDetailsDto } from './dto/updateUserDetailsDto';
import { User } from './schemas/user.schema';
import { UsersService } from './users.service';

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @UseGuards(AccessTokenGuard)
  @Get('me')
  async findOne(@Req() req: Request): Promise<User> {
    const userId = req.user['sub'];

    return this.usersService.findById(userId);
  }

  @UseGuards(AccessTokenGuard)
  @Patch('details')
  async update(
    @Body() updateUserDetailsDto: UpdateUserDetailsDto,
    @Req() req: Request,
  ): Promise<User> {
    const userId = req.user['sub'];

    return this.usersService.update(userId, updateUserDetailsDto);
  }

  @UseGuards(AccessTokenGuard)
  @Patch('avatar')
  async updateAvatar(
    @Body() updateUserAvatarDto: UpdateUserAvatarDto,
    @Req() req: Request,
  ): Promise<User> {
    const userId = req.user['sub'];

    return this.usersService.updateAvatar(userId, updateUserAvatarDto.avatar);
  }
}
