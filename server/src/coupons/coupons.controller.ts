import {
  Body,
  Controller,
  Get,
  Param,
  Post,
  Req,
  UseGuards,
  Patch,
  Delete,
} from '@nestjs/common';
import { Request } from 'express';

import { AccessTokenGuard } from 'src/auth/guards/accessToken.guard';
import { AccessTokenRegionGuard } from 'src/auth/guards/accessTokenRegion.guard';

import { CouponsService } from './coupons.service';
import { CreateCouponDto } from './dto/createCoupon.dto';
import { UpdateCouponDto } from './dto/updateCoupon.dto';

@Controller('coupons')
export class CouponsController {
  constructor(private couponsService: CouponsService) {}

  @Get(':regionId')
  async getCouponsByRegionId(@Param('regionId') regionId: string) {
    return await this.couponsService.getCouponsByRegionId(regionId);
  }

  @UseGuards(AccessTokenRegionGuard)
  @Post()
  async createCoupon(
    @Body() createCouponDto: CreateCouponDto,
    @Req() req: Request,
  ) {
    const regionId = req.user['sub'];

    return await this.couponsService.createCoupon(regionId, createCouponDto);
  }

  @UseGuards(AccessTokenRegionGuard)
  @Patch(':couponId')
  async updateCoupon(
    @Body() updateCouponDto: UpdateCouponDto,
    @Req() req: Request,
    @Param('couponId') couponId: string,
  ) {
    const regionId = req.user['sub'];

    return await this.couponsService.updateCoupon(
      regionId,
      couponId,
      updateCouponDto,
    );
  }

  @UseGuards(AccessTokenRegionGuard)
  @Delete(':id')
  async deleteCoupon(@Param('id') id: string, @Req() req: Request) {
    const regionId = req.user['sub'];

    return await this.couponsService.deleteCoupon(regionId, id);
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
