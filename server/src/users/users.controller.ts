import { Body, Controller, Get, Patch, UseGuards, Req } from '@nestjs/common';
import { Request } from 'express';

import { AccessTokenGuard } from 'src/auth/guards/accessToken.guard';

import { UpdateUserDto } from './dto/updateUserDto';
import { User } from './schemas/user.schema';
import { UsersService } from './users.service';

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  // TODO: Remove
  @Get()
  async findAll(): Promise<User[]> {
    return this.usersService.findAll();
  }

  @UseGuards(AccessTokenGuard)
  @Get('me')
  async findOne(@Req() req: Request): Promise<User> {
    const userId = req.user['sub'];

    return this.usersService.findById(userId);
  }

  @UseGuards(AccessTokenGuard)
  @Patch()
  async update(
    @Body() updateUserDto: UpdateUserDto,
    @Req() req: Request,
  ): Promise<User> {
    const userId = req.user['sub'];

    return this.usersService.update(userId, updateUserDto);
  }
}
