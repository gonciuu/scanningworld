import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';

import { Model } from 'mongoose';

import { CreateRegionDto } from './dto/createRegion.dto';
import { Region, RegionDocument } from './schemas/region.schema';

@Injectable()
export class RegionsService {
  constructor(
    @InjectModel(Region.name) private regionModel: Model<RegionDocument>,
  ) {}

  async create(createRegionDto: CreateRegionDto): Promise<RegionDocument> {
    return this.regionModel.create(createRegionDto);
  }

  async findAll(): Promise<RegionDocument[]> {
    return this.regionModel.find().exec();
  }

  async findById(id: string): Promise<RegionDocument> {
    return this.regionModel.findById(id).exec();
  }

  async updateRegionPlacesCount(
    regionId: string,
    modifier: number,
  ): Promise<RegionDocument> {
    return this.regionModel
      .findByIdAndUpdate(
        regionId,
        { $inc: { placeCount: modifier } },
        { new: true },
      )
      .exec();
  }
}
