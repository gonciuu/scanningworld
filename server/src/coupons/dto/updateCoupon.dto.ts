import { PartialType } from '@nestjs/mapped-types';

import { CreateCouponDto } from './createCoupon.dto';

export class UpdateCouponDto extends PartialType(CreateCouponDto) {}
