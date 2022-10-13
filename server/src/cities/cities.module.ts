import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';

import { CitiesService } from './cities.service';
import { CitiesController } from './cities.controller';
import { CitySchema } from './schemas/city.schema';

@Module({
  imports: [MongooseModule.forFeature([{ name: 'City', schema: CitySchema }])],
  providers: [CitiesService],
  controllers: [CitiesController],
})
export class CitiesModule {}
