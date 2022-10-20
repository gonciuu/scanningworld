import { Controller, Get, Param, Req, UseGuards } from '@nestjs/common';
import { Request } from 'express';
import { AccessTokenRegionGuard } from 'src/auth/guards/accessTokenRegion.guard';

import { RegionsService } from './regions.service';

@Controller('regions')
export class RegionsController {
  constructor(private readonly regionsService: RegionsService) {}

  @Get()
  async findAll() {
    return await this.regionsService.findAll();
  }

  @UseGuards(AccessTokenRegionGuard)
  @Get('by-token')
  async findByToken(@Req() req: Request) {
    const regionId = req.user['sub'];

    return await this.regionsService.findById(regionId);
  }

  @Get(':id')
  async findById(@Param('id') id: string) {
    return await this.regionsService.findById(id);
  }
}
