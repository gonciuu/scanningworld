import {
  Injectable,
  BadRequestException,
  ForbiddenException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';

import * as argon2 from 'argon2';

import { RegionsService } from 'src/regions/regions.service';
import { CreateRegionDto } from 'src/regions/dto/createRegion.dto';

import { AuthRegionDto } from './dto/auth.dto';

@Injectable()
export class AuthRegionService {
  constructor(
    private regionsService: RegionsService,
    private jwtService: JwtService,
    private configService: ConfigService,
  ) {}

  async register(createRegionDto: CreateRegionDto) {
    const regionExists = await this.regionsService.findByEmail(
      createRegionDto.email,
    );
    if (regionExists)
      throw new BadRequestException('Region with that email already exists');

    const hashedPassword = await this.hashData(createRegionDto.password);
    const newRegion = await this.regionsService.create({
      ...createRegionDto,
      password: hashedPassword,
    });

    const tokens = await this.getTokens(newRegion._id, newRegion.email);

    await this.updateRefreshToken(newRegion._id, tokens.refreshToken);

    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    const { password, refreshToken, passwordResetToken, ...region } =
      newRegion.toObject();

    return { tokens, region };
  }

  async login(data: AuthRegionDto) {
    const region = await this.regionsService.findByEmail(data.email);

    if (!region) throw new BadRequestException('Invalid email');

    const isPasswordValid = await argon2.verify(region.password, data.password);

    if (!isPasswordValid) throw new BadRequestException('Invalid password');

    const tokens = await this.getTokens(region._id, region.email);

    await this.updateRefreshToken(region._id, tokens.refreshToken);

    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    const { password, ...regionWithoutPassword } = region.toObject();

    return {
      tokens,
      region: regionWithoutPassword,
    };
  }

  async refreshTokens(regionId: string, refreshToken: string) {
    const region = await this.regionsService.findById(regionId, {
      refreshToken: true,
    });

    if (!region || !region.refreshToken)
      throw new ForbiddenException('Access Denied');

    const isRefreshTokenValid = await argon2.verify(
      region.refreshToken,
      refreshToken,
    );

    if (!isRefreshTokenValid) {
      await this.logout(regionId);
      throw new ForbiddenException('Access Denied');
    }

    const tokens = await this.getTokens(regionId, region.email);

    await this.updateRefreshToken(regionId, tokens.refreshToken);

    return tokens;
  }

  async logout(regionId: string) {
    return this.regionsService.updateRefreshToken(regionId, null);
  }

  hashData(data: string) {
    return argon2.hash(data);
  }

  async updateRefreshToken(regionId: string, refreshToken: string) {
    const hashedRefreshToken = await this.hashData(refreshToken);
    await this.regionsService.updateRefreshToken(regionId, hashedRefreshToken);
  }

  async getTokens(regionId: string, username: string) {
    const [accessToken, refreshToken] = await Promise.all([
      this.jwtService.signAsync(
        {
          sub: regionId,
          username,
        },
        {
          secret: this.configService.get<string>(
            'JWT_ACCESS_TOKEN_REGION_SECRET',
          ),
          expiresIn: '2min',
        },
      ),
      this.jwtService.signAsync(
        {
          sub: regionId,
          username,
        },
        {
          secret: this.configService.get<string>('JWT_REFRESH_TOKEN_SECRET'),
          expiresIn: '7d',
        },
      ),
    ]);

    return {
      accessToken,
      refreshToken,
    };
  }
}
