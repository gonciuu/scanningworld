import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import mongoose, { Document } from 'mongoose';

import { Region } from 'src/regions/schemas/region.schema';
import { Place } from 'src/places/schemas/place.schema';

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
  region: Region;

  @Prop({
    type: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Place' }],
    autopopulate: true,
    default: [],
  })
  scannedPlaces: Place[];

  @Prop({ default: 0 })
  points: number;

  @Prop({ select: false })
  password: string;

  @Prop({ select: false })
  refreshToken: string;

  @Prop({ select: false })
  passwordResetToken: string;
}

export const UserSchema = SchemaFactory.createForClass(User);
