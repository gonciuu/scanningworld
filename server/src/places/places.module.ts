import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';

import { RegionsModule } from 'src/regions/regions.module';
import { UsersModule } from 'src/users/users.module';

import { PlacesService } from './places.service';
import { PlacesController } from './places.controller';
import { PlaceSchema } from './schemas/place.schema';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: 'Place', schema: PlaceSchema }]),
    RegionsModule,
    UsersModule,
  ],
  providers: [PlacesService],
  controllers: [PlacesController],
})
export class PlacesModule {}
