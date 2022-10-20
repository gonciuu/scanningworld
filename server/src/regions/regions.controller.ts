import { Controller, Get, Param } from '@nestjs/common';

import { RegionsService } from './regions.service';

@Controller('regions')
export class RegionsController {
  constructor(private readonly regionsService: RegionsService) {}

  @Get()
  async findAll() {
    return await this.regionsService.findAll();
  }

  @Get(':id')
  async findById(@Param('id') id: string) {
    return await this.regionsService.findById(id);
  }
}
