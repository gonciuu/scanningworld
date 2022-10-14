import { Body, Controller, Get, Param, Post } from '@nestjs/common';

import { PlacesService } from './places.service';
import { Place } from './schemas/place.schema';
import { CreatePlaceDto } from './dto/createPlace.dto';

@Controller('places')
export class PlacesController {
  constructor(private placesService: PlacesService) {}

  @Get()
  async findAll(): Promise<Place[]> {
    return this.placesService.findAll();
  }

  @Get(':regionId')
  async findByRegionId(@Param('regionId') regionId: string): Promise<Place[]> {
    return this.placesService.findByRegionId(regionId);
  }

  @Post()
  async create(@Body() createPlaceDto: CreatePlaceDto): Promise<Place> {
    return this.placesService.create(createPlaceDto);
  }
}
