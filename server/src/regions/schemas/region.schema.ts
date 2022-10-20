import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

import { Document } from 'mongoose';

export type RegionDocument = Region & Document;

@Schema()
export class Region {
  @Prop()
  name: string;

  @Prop({ default: 0 })
  placeCount: number;

  @Prop()
  email: string;

  @Prop({ select: false })
  password: string;

  @Prop({ select: false })
  refreshToken: string;
}

export const RegionSchema = SchemaFactory.createForClass(Region);
