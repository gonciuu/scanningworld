import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import mongoose, { Document } from 'mongoose';

import { RegionDocument } from 'src/regions/schemas/region.schema';

export type CouponDocument = Coupon & Document;

@Schema()
export class Coupon {
  @Prop()
  name: string;

  @Prop()
  imageUri: string;

  @Prop()
  points: number;

  @Prop({
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Region',
    autopopulate: true,
  })
  region: RegionDocument;
}

export const CouponSchema = SchemaFactory.createForClass(Coupon);
