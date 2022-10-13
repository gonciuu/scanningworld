import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';

import { RegionsService } from './regions.service';
import { RegionsController } from './regions.controller';
import { RegionSchema } from './schemas/region.schema';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: 'Region', schema: RegionSchema }]),
  ],
  providers: [RegionsService],
  controllers: [RegionsController],
})
export class RegionsModule {}
