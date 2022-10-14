import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';

import { PlacesService } from './places.service';
import { PlacesController } from './places.controller';
import { PlaceSchema } from './schemas/place.schema';
import { RegionsModule } from '../regions/regions.module';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: 'Place', schema: PlaceSchema }]),
    RegionsModule,
  ],
  providers: [PlacesService],
  controllers: [PlacesController],
})
export class PlacesModule {}
