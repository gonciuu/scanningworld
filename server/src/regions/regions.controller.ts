import { Body, Controller, Get, Param, Post } from '@nestjs/common';
import { RegionsService } from './regions.service';
import { CreateRegionDto } from './dto/createRegion.dto';

@Controller('regions')
export class RegionsController {
  constructor(private readonly regionsService: RegionsService) {}

  @Post()
  async create(@Body() createRegionDto: CreateRegionDto) {
    return await this.regionsService.create(createRegionDto);
  }

  @Get()
  async findAll() {
    return await this.regionsService.findAll();
  }

  @Get(':id')
  async findById(@Param('id') id: string) {
    return await this.regionsService.findById(id);
  }
}
