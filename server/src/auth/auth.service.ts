import {
  Injectable,
  BadRequestException,
  ForbiddenException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';

import * as argon2 from 'argon2';

import { UsersService } from 'src/users/users.service';
import { CreateUserDto } from 'src/users/dto/createUserDto';
import { AuthDto } from './dto/auth.dto';

@Injectable()
export class AuthService {
  constructor(
    private usersService: UsersService,
    private jwtService: JwtService,
    private configService: ConfigService,
  ) {}

  async register(createUserDto: CreateUserDto) {
    const userExists = await this.usersService.findByPhone(createUserDto.phone);
    if (userExists) throw new BadRequestException('User already exists');

    const hashedPassword = await this.hashData(createUserDto.password);
    const newUser = await this.usersService.create({
      ...createUserDto,
      password: hashedPassword,
    });

    const tokens = await this.getTokens(newUser._id, newUser.email);

    await this.updateRefreshToken(newUser._id, tokens.refreshToken);

    return tokens;
  }

  async login(data: AuthDto) {
    const user = await this.usersService.findByPhone(data.phone);

    if (!user) throw new BadRequestException('Invalid phone');

    const isPasswordValid = await argon2.verify(user.password, data.password);

    if (!isPasswordValid) throw new BadRequestException('Invalid password');

    const tokens = await this.getTokens(user._id, user.email);

    await this.updateRefreshToken(user._id, tokens.refreshToken);

    return tokens;
  }

  async refreshTokens(userId: string, refreshToken: string) {
    const user = await this.usersService.findById(userId, {
      refreshToken: true,
    });

    if (!user || !user.refreshToken)
      throw new ForbiddenException('Access Denied');

    const isRefreshTokenValid = await argon2.verify(
      user.refreshToken,
      refreshToken,
    );

    if (!isRefreshTokenValid) {
      await this.logout(userId);
      throw new ForbiddenException('Access Denied');
    }

    const tokens = await this.getTokens(userId, user.email);

    await this.updateRefreshToken(userId, tokens.refreshToken);

    return tokens;
  }

  async logout(userId: string) {
    return this.usersService.updateRefreshToken(userId, null);
  }

  hashData(data: string) {
    return argon2.hash(data);
  }

  async updateRefreshToken(userId: string, refreshToken: string) {
    const hashedRefreshToken = await this.hashData(refreshToken);
    await this.usersService.updateRefreshToken(userId, hashedRefreshToken);
  }

  async getTokens(userId: string, username: string) {
    const [accessToken, refreshToken] = await Promise.all([
      this.jwtService.signAsync(
        {
          sub: userId,
          username,
        },
        {
          secret: this.configService.get<string>('JWT_ACCESS_TOKEN_SECRET'),
          expiresIn: '15min',
        },
      ),
      this.jwtService.signAsync(
        {
          sub: userId,
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
