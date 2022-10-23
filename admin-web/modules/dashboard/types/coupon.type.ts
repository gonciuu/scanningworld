import { RegionType } from '@/common/types/region.type';

export type CouponType = {
  _id: string;
  name: string;
  imageUri: string;
  points: number;
  region: RegionType;
};

export type CouponValues = {
  name: string;
  points: number;
  imageUri: string;
};

export interface PostCoupon extends Omit<CouponValues, 'imageUri'> {
  imageBase64: string;
}
