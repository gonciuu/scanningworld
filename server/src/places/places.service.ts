import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';

import { isValidObjectId, Model } from 'mongoose';

import { Place, PlaceDocument } from './schemas/place.schema';
import { CreatePlaceDto } from './dto/createPlace.dto';
import { RegionsService } from '../regions/regions.service';

@Injectable()
export class PlacesService {
  constructor(
    @InjectModel(Place.name) private placeModel: Model<PlaceDocument>,
    private regionsService: RegionsService,
  ) {}

  async create(createPlaceDto: CreatePlaceDto): Promise<PlaceDocument> {
    const { regionId, lng, lat, ...place } = createPlaceDto;

    if (!isValidObjectId(regionId)) {
      throw new BadRequestException('Invalid region id');
    }

    const region = await this.regionsService.findById(regionId);

    if (!region) {
      throw new NotFoundException('Region not found');
    }

    return this.placeModel.create({
      ...place,
      region: regionId,
      location: { lat, lng },
    });
  }

  async findAll(): Promise<PlaceDocument[]> {
    return this.placeModel.find().exec();
  }

  async findByRegionId(regionId: string): Promise<PlaceDocument[]> {
    if (!isValidObjectId(regionId)) {
      throw new BadRequestException('Invalid region id');
    }

    const region = await this.regionsService.findById(regionId);

    if (!region) {
      throw new NotFoundException('Region not found');
    }

    return this.placeModel.find({ region: regionId }).exec();
  }
}
