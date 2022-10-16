import { Body, Controller, Get, Param, Post } from '@nestjs/common';
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
}
