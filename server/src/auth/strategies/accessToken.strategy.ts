import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PassportStrategy } from '@nestjs/passport';

import { ExtractJwt, Strategy } from 'passport-jwt';

import { UsersService } from 'src/users/users.service';

type JwtPayload = {
  sub: string;
  username: string;
};

@Injectable()
export class AccessTokenStrategy extends PassportStrategy(
  Strategy,
  'jwt-access',
) {
  constructor(
    private configService: ConfigService,
    private usersService: UsersService,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      secretOrKey: configService.get<string>('JWT_ACCESS_TOKEN_SECRET'),
    });
  }

  async validate(payload: JwtPayload) {
    const me = await this.usersService.findById(payload.sub);

    const now = new Date();

    const newActiveCoupons = me.activeCoupons.filter(
      (activeCoupon) => activeCoupon.validUntil > now,
    );

    if (newActiveCoupons.length !== me.activeCoupons.length)
      await this.usersService.update(me._id, {
        activeCoupons: newActiveCoupons,
      });

    return payload;
  }
}
