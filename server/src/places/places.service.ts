import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';

import { isValidObjectId, Model } from 'mongoose';

import { RegionsService } from 'src/regions/regions.service';
import { UsersService } from 'src/users/users.service';
import { UserDocument } from 'src/users/schemas/user.schema';

import { Place, PlaceDocument } from './schemas/place.schema';
import { CreatePlaceDto } from './dto/createPlace.dto';

@Injectable()
export class PlacesService {
  constructor(
    @InjectModel(Place.name) private placeModel: Model<PlaceDocument>,
    private regionsService: RegionsService,
    private usersService: UsersService,
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

    const code =
      Math.random().toString(36).substring(2, 15) +
      Math.random().toString(36).substring(2, 15);

    return this.placeModel.create({
      ...place,
      region: regionId,
      location: { lat, lng },
      code,
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

  async scanCode(code: string, userId: string): Promise<UserDocument> {
    const place = await this.placeModel.findOne({ code }).exec();

    if (!place) {
      throw new NotFoundException('Place not found');
    }

    const user = await this.usersService.findById(userId);

    if (!user) {
      throw new NotFoundException('User not found');
    }

    if (user.region._id.toString() !== place.region._id.toString()) {
      throw new BadRequestException(
        'User is not in the same region as the place',
      );
    }

    if (
      user.scannedPlaces.find(
        (userPlace) => userPlace._id.toString() === place._id.toString(),
      )
    ) {
      throw new BadRequestException('User has already visited this place');
    }

    const regionId = user.region._id.toString();

    return await this.usersService.update(userId, {
      scannedPlaces: [...user.scannedPlaces, place._id],
      points: {
        ...user.points,
        [regionId]: (user.points[regionId] || 0) + place.points,
      },
    });
  }
}
