import { PartialType } from '@nestjs/mapped-types';

import { CreatePlaceDto } from './createPlace.dto';

export class UpdatePlaceDto extends PartialType(CreatePlaceDto) {}
