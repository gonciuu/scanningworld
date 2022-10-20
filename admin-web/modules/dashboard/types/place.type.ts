import { RegionType } from '@/common/types/region.type';

export type PlaceType = {
  _id: string;
  name: string;
  location: {
    lat: number;
    lng: number;
  };
  description: string;
  imageUri: string;
  points: number;
  code: string;
  region: RegionType;
};
