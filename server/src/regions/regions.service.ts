import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';

import { Model } from 'mongoose';
import { CreateRegionDto } from './dto/createRegion.dto';

import { Region, RegionDocument } from './schemas/region.schema';

@Injectable()
export class RegionsService {
  constructor(
    @InjectModel(Region.name) private userModel: Model<RegionDocument>,
  ) {}

  async create(createRegionDto: CreateRegionDto): Promise<RegionDocument> {
    return this.userModel.create(createRegionDto);
  }

  async findAll(): Promise<RegionDocument[]> {
    return this.userModel.find().exec();
  }

  async findById(id: string): Promise<RegionDocument> {
    return this.userModel.findById(id).exec();
  }
}
