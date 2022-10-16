import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { RegionsModule } from 'src/regions/regions.module';

import { CouponsController } from './coupons.controller';
import { CouponsService } from './coupons.service';
import { CouponSchema } from './schemas/coupon.schema';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: 'Coupon', schema: CouponSchema }]),
    RegionsModule,
  ],
  controllers: [CouponsController],
  providers: [CouponsService],
})
export class CouponsModule {}
