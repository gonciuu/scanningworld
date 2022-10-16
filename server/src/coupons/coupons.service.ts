import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';

import { isValidObjectId, Model } from 'mongoose';

import { RegionsService } from 'src/regions/regions.service';
import { CreateCouponDto } from './dto/createCoupon.dto';

import { Coupon, CouponDocument } from './schemas/coupon.schema';

@Injectable()
export class CouponsService {
  constructor(
    @InjectModel(Coupon.name) private couponModel: Model<CouponDocument>,
    private regionsService: RegionsService,
  ) {}

  async getCouponsByRegionId(regionId: string): Promise<CouponDocument[]> {
    if (!isValidObjectId(regionId)) {
      throw new BadRequestException('Invalid region id');
    }

    const region = await this.regionsService.findById(regionId);

    if (!region) {
      throw new NotFoundException('Region not found');
    }

    return this.couponModel.find({ region: regionId }).exec();
  }

  async createCoupon(
    createCouponDto: CreateCouponDto,
  ): Promise<CouponDocument> {
    const { regionId, ...coupon } = createCouponDto;

    if (!isValidObjectId(regionId)) {
      throw new BadRequestException('Invalid region id');
    }

    const region = await this.regionsService.findById(regionId);

    if (!region) {
      throw new NotFoundException('Region not found');
    }

    const newCoupon = new this.couponModel({ ...coupon, region: regionId });

    return await newCoupon.save();
  }
}
