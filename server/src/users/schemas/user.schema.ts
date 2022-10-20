import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

import mongoose, { Document } from 'mongoose';

import { RegionDocument } from 'src/regions/schemas/region.schema';
import { PlaceDocument } from 'src/places/schemas/place.schema';
import { CouponDocument } from 'src/coupons/schemas/coupon.schema';

import { Avatar } from '../types/avatar.type';

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
    default: 'male1',
    type: String,
    enum: ['male1', 'male2', 'male3', 'female1', 'female2', 'female3'],
  })
  avatar: Avatar;

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

  @Prop({
    type: [
      {
        type: {
          coupon: {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'Coupon',
            autopopulate: true,
          },
          validUntil: Date,
        },
      },
    ],
  })
  activeCoupons: [
    {
      coupon: CouponDocument;
      validUntil: Date;
    },
  ];

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
