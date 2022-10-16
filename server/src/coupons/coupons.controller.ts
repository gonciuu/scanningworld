import {
  Body,
  Controller,
  Get,
  Param,
  Post,
  Req,
  UseGuards,
} from '@nestjs/common';
import { Request } from 'express';

import { AccessTokenGuard } from 'src/auth/guards/accessToken.guard';

import { CouponsService } from './coupons.service';
import { CreateCouponDto } from './dto/createCoupon.dto';

@Controller('coupons')
export class CouponsController {
  constructor(private couponsService: CouponsService) {}

  @Get(':regionId')
  async getCouponsByRegionId(@Param('regionId') regionId: string) {
    return await this.couponsService.getCouponsByRegionId(regionId);
  }

  @Post()
  async createCoupon(@Body() createCouponDto: CreateCouponDto) {
    return await this.couponsService.createCoupon(createCouponDto);
  }

  @Post('activate/:couponId')
  @UseGuards(AccessTokenGuard)
  async activateCoupon(
    @Param('couponId') couponId: string,
    @Req() req: Request,
  ) {
    return await this.couponsService.activateCoupon(couponId, req.user['sub']);
  }
}
