import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import mongoose, { Document } from 'mongoose';

import { RegionDocument } from 'src/regions/schemas/region.schema';
import { PlaceDocument } from 'src/places/schemas/place.schema';

export type UserDocument = User & Document;

@Schema()
export class User {
  @Prop()
  name: string;

  @Prop()
  email: string;

  @Prop({ unique: true })
  phone: string;

  @Prop({
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Region',
    autopopulate: true,
  })
  region: RegionDocument;

  @Prop({
    type: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Place' }],
    autopopulate: true,
    default: [],
  })
  scannedPlaces: PlaceDocument[];

  @Prop({ type: Object, default: {} })
  points: Record<string, number>;

  @Prop({ select: false })
  password: string;

  @Prop({ select: false })
  refreshToken: string;

  @Prop({ select: false })
  passwordResetToken: string;
}

export const UserSchema = SchemaFactory.createForClass(User);
