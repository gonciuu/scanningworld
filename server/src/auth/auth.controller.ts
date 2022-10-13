import {
  Controller,
  Get,
  Post,
  Body,
  UseGuards,
  Req,
  Query,
} from '@nestjs/common';

import { Request } from 'express';

import { CreateUserDto } from 'src/users/dto/createUserDto';

import { AuthService } from './auth.service';
import { AuthDto } from './dto/auth.dto';
import { PasswordResetDto } from './dto/passwordReset.dto';
import { AccessTokenGuard } from './guards/accessToken.guard';
import { RefreshTokenGuard } from './guards/refreshToken.guard';

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('register')
  async register(@Body() createUserDto: CreateUserDto) {
    return await this.authService.register(createUserDto);
  }

  @Post('login')
  async login(@Body() data: AuthDto) {
    return await this.authService.login(data);
  }

  @UseGuards(AccessTokenGuard)
  @Get('logout')
  async logout(@Req() req: Request) {
    await this.authService.logout(req.user['sub']);

    return {
      msg: 'User logged out',
    };
  }

  @UseGuards(RefreshTokenGuard)
  @Get('refresh')
  async refresh(@Req() req: Request) {
    const userId = req.user['sub'];
    const refreshToken = req.user['refreshToken'];

    return this.authService.refreshTokens(userId, refreshToken);
  }

  @Get('forgot-password')
  async forgotPassword(@Query('phone') phone: string) {
    const passwordResetToken =
      await this.authService.generatePasswordResetToken(phone);

    return {
      msg: 'Forgot password',
      passwordResetToken,
    };
  }

  @Post('reset-password')
  async resetPassword(@Body() data: PasswordResetDto) {
    await this.authService.resetPassword(
      data.passwordResetToken,
      data.newPassword,
    );

    return {
      msg: 'Password reset',
    };
  }
}
