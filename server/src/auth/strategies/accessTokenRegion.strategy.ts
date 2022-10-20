import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PassportStrategy } from '@nestjs/passport';

import { ExtractJwt, Strategy } from 'passport-jwt';

type JwtPayload = {
  sub: string;
  username: string;
};

@Injectable()
export class AccessTokenRegionStrategy extends PassportStrategy(
  Strategy,
  'region-jwt-access',
) {
  constructor(private configService: ConfigService) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      secretOrKey: configService.get<string>('JWT_ACCESS_TOKEN_REGION_SECRET'),
    });
  }

  async validate(payload: JwtPayload) {
    return payload;
  }
}
