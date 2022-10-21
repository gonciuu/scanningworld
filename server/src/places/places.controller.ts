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

import { AccessTokenRegionGuard } from 'src/auth/guards/accessTokenRegion.guard';
import { User } from 'src/users/schemas/user.schema';

import { CreatePlaceDto } from './dto/createPlace.dto';
import { ScanPlaceDto } from './dto/scanPlace.dto';
import { PlacesService } from './places.service';
import { Place } from './schemas/place.schema';

@Controller('places')
export class PlacesController {
  constructor(private placesService: PlacesService) {}

  @Get(':regionId')
  async findByRegionId(@Param('regionId') regionId: string): Promise<Place[]> {
    return this.placesService.findByRegionId(regionId);
  }

  @UseGuards(AccessTokenRegionGuard)
  @Post()
  async create(
    @Body() createPlaceDto: CreatePlaceDto,
    @Req() req: Request,
  ): Promise<Place> {
    const regionId = req.user['sub'];

    return this.placesService.create(regionId, createPlaceDto);
  }

  @UseGuards(AccessTokenGuard)
  @Post(':code')
  async scanCode(
    @Param('code') code: string,
    @Req() req: Request,
    @Body() body: ScanPlaceDto,
  ): Promise<User> {
    const userId = req.user['sub'] as string;

    return this.placesService.scanCode(code, userId, {
      lat: body.lat,
      lng: body.lng,
    });
  }
}
