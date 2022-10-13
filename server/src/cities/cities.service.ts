import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';

import { Model } from 'mongoose';
import { CreateCityDto } from './dto/createCity.dto';

import { City, CityDocument } from './schemas/city.schema';

@Injectable()
export class CitiesService {
  constructor(@InjectModel(City.name) private userModel: Model<CityDocument>) {}

  async create(createCityDto: CreateCityDto): Promise<CityDocument> {
    return this.userModel.create(createCityDto);
  }

  async findAll(): Promise<CityDocument[]> {
    return this.userModel.find().exec();
  }

  async findById(id: string): Promise<CityDocument> {
    return this.userModel.findById(id).exec();
  }
}
