import { Module } from '@nestjs/common';
import { PassportModule } from '@nestjs/passport';
import { JwtModule } from '@nestjs/jwt';

import { UsersModule } from 'src/users/users.module';
import { RegionsModule } from 'src/regions/regions.module';

import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { AccessTokenStrategy } from './strategies/accessToken.strategy';
import { RefreshTokenStrategy } from './strategies/refreshToken.strategy';
import { AuthRegionService } from './authRegion.service';
import { AuthRegionController } from './authRegion.controller';
import { AccessTokenRegionStrategy } from './strategies/accessTokenRegion.strategy';

@Module({
  imports: [UsersModule, PassportModule, JwtModule.register({}), RegionsModule],
  controllers: [AuthController, AuthRegionController],
  providers: [
    AuthService,
    AuthRegionService,
    AccessTokenStrategy,
    AccessTokenRegionStrategy,
    RefreshTokenStrategy,
  ],
})
export class AuthModule {}
