import { RegionType } from '@/common/types/region.type';

export type CouponType = {
  _id: string;
  name: string;
  imageUri: string;
  points: number;
  region: RegionType;
};
