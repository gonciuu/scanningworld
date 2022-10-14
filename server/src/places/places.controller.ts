import {
  Body,
  Controller,
  Get,
  Param,
  Post,
  Req,
  UseGuards,
} from '@nestjs/common';

import { Request } from 'express';

import { AccessTokenGuard } from 'src/auth/guards/accessToken.guard';
import { User } from 'src/users/schemas/user.schema';

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

  @UseGuards(AccessTokenGuard)
  @Post(':code')
  async scanCode(
    @Param('code') code: string,
    @Req() req: Request,
  ): Promise<User> {
    const userId = req.user['sub'] as string;

    return this.placesService.scanCode(code, userId);
  }
}
