import { Controller, Get, Post, Body, UseGuards, Req } from '@nestjs/common';

import { Request } from 'express';

import { CreateRegionDto } from 'src/regions/dto/createRegion.dto';

import { AuthRegionService } from './authRegion.service';
import { AuthRegionDto } from './dto/auth.dto';
import { AccessTokenRegionGuard } from './guards/accessTokenRegion.guard';
import { RefreshTokenGuard } from './guards/refreshToken.guard';

@Controller('auth/region')
export class AuthRegionController {
  constructor(private authRegionService: AuthRegionService) {}

  @Post('register')
  async register(@Body() createRegionDto: CreateRegionDto) {
    return await this.authRegionService.register(createRegionDto);
  }

  @Post('login')
  async login(@Body() data: AuthRegionDto) {
    return await this.authRegionService.login(data);
  }

  @UseGuards(AccessTokenRegionGuard)
  @Get('logout')
  async logout(@Req() req: Request) {
    await this.authRegionService.logout(req.user['sub']);

    return {
      msg: 'Region logged out',
    };
  }

  @UseGuards(RefreshTokenGuard)
  @Get('refresh')
  async refresh(@Req() req: Request) {
    const userId = req.user['sub'];
    const refreshToken = req.user['refreshToken'];

    return this.authRegionService.refreshTokens(userId, refreshToken);
  }
}
