import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type RegionDocument = Region & Document;

@Schema()
export class Region {
  @Prop()
  name: string;
}

export const RegionSchema = SchemaFactory.createForClass(Region);
