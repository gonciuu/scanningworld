import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

import mongoose, { Document } from 'mongoose';

import { RegionDocument } from 'src/regions/schemas/region.schema';

export type PlaceDocument = Place & Document;

@Schema()
export class Place {
  @Prop()
  name: string;

  @Prop()
  description: string;

  @Prop()
  imageUri: string;

  @Prop({
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Region',
    autopopulate: true,
  })
  region: RegionDocument;

  @Prop()
  points: number;

  @Prop({ type: { lat: Number, lng: Number } })
  location: {
    lat: number;
    lng: number;
  };

  @Prop({ select: false })
  code: string;
}

export const PlaceSchema = SchemaFactory.createForClass(Place);
