import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { v2 } from 'cloudinary';

import { isValidObjectId, Model } from 'mongoose';

import { RegionsService } from 'src/regions/regions.service';
import { UserDocument } from 'src/users/schemas/user.schema';
import { UsersService } from 'src/users/users.service';

import { CreateCouponDto } from './dto/createCoupon.dto';
import { UpdateCouponDto } from './dto/updateCoupon.dto';
import { Coupon, CouponDocument } from './schemas/coupon.schema';

@Injectable()
export class CouponsService {
  constructor(
    @InjectModel(Coupon.name) private couponModel: Model<CouponDocument>,
    private regionsService: RegionsService,
    private usersService: UsersService,
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
    regionId: string,
    createCouponDto: CreateCouponDto,
  ): Promise<CouponDocument> {
    if (!isValidObjectId(regionId)) {
      throw new BadRequestException('Invalid region id');
    }

    const region = await this.regionsService.findById(regionId);

    if (!region) {
      throw new NotFoundException('Region not found');
    }

    const imageUri = !createCouponDto.imageBase64
      ? ''
      : await v2.uploader
          .upload(createCouponDto.imageBase64, {
            folder: 'scanningworld',
          })
          .then((result) => {
            return result.url;
          });

    return this.couponModel.create({
      ...createCouponDto,
      region: regionId,
      imageUri,
    });
  }

  async updateCoupon(
    regionId,
    couponId: string,
    updateCouponDto: UpdateCouponDto,
  ): Promise<CouponDocument> {
    if (!isValidObjectId(regionId)) {
      throw new BadRequestException('Invalid region id');
    }

    if (!isValidObjectId(couponId)) {
      throw new BadRequestException('Invalid coupon id');
    }

    const region = await this.regionsService.findById(regionId);

    if (!region) {
      throw new NotFoundException('Region not found');
    }

    const coupon = await this.couponModel.findById(couponId).exec();

    if (!coupon) {
      throw new NotFoundException('Coupon not found');
    }

    if (coupon.region._id.toString() !== regionId) {
      throw new BadRequestException('Coupon does not belong to region');
    }

    const imageUri = !updateCouponDto.imageBase64
      ? coupon.imageUri
      : await v2.uploader
          .upload(updateCouponDto.imageBase64, {
            folder: 'scanningworld',
          })
          .then((result) => {
            return result.url;
          });

    return this.couponModel.findByIdAndUpdate(
      couponId,
      {
        ...updateCouponDto,
        imageUri,
      },
      { new: true },
    );
  }

  async deleteCoupon(regionId: string, id: string): Promise<CouponDocument> {
    if (!isValidObjectId(regionId)) {
      throw new BadRequestException('Invalid region id');
    }

    if (!isValidObjectId(id)) {
      throw new BadRequestException('Invalid coupon id');
    }

    const region = await this.regionsService.findById(regionId);

    if (!region) {
      throw new NotFoundException('Region not found');
    }

    const coupon = await this.couponModel.findById(id).exec();

    if (!coupon) {
      throw new NotFoundException('Coupon not found');
    }

    if (coupon.region._id.toString() !== regionId) {
      throw new BadRequestException('Coupon does not belong to region');
    }

    return this.couponModel.findByIdAndDelete(id);
  }

  async activateCoupon(
    couponId: string,
    userId: string,
  ): Promise<UserDocument> {
    if (!isValidObjectId(couponId)) {
      throw new BadRequestException('Invalid coupon id');
    }

    const coupon = await this.couponModel.findById(couponId).exec();

    if (!coupon) {
      throw new NotFoundException('Coupon not found');
    }

    const user = await this.usersService.findById(userId);

    if (!user) {
      throw new NotFoundException('User not found');
    }

    const { region } = coupon;

    if (user.region._id.toString() !== region._id.toString()) {
      throw new BadRequestException(
        'User is not in the same region as the coupon',
      );
    }

    if ((user.points[region._id.toString()] || 0) < coupon.points) {
      throw new BadRequestException('User does not have enough points');
    }

    return this.usersService.update(userId, {
      points: {
        ...user.points,
        [region._id.toString()]:
          user.points[region._id.toString()] - coupon.points,
      },
      activeCoupons: [
        ...user.activeCoupons,
        {
          coupon: coupon._id,
          validUntil: new Date(Date.now() + 1000 * 60 * 15),
        },
      ],
    });
  }
}
