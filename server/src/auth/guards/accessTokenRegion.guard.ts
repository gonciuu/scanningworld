import { Injectable } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

@Injectable()
export class AccessTokenRegionGuard extends AuthGuard('region-jwt-access') {}
