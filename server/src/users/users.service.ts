import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';

import { Model } from 'mongoose';

import { CreateUserDto } from './dto/createUserDto';
import { UpdateUserDto } from './dto/updateUserDto';
import { User, UserDocument } from './schemas/user.schema';

@Injectable()
export class UsersService {
  constructor(@InjectModel(User.name) private userModel: Model<UserDocument>) {}

  // TODO: Remove
  async findAll(): Promise<UserDocument[]> {
    return this.userModel.find().exec();
  }

  async findByPhone(phone: string): Promise<UserDocument> {
    return await this.userModel.findOne({ phone }).select('+password').exec();
  }

  async findById(
    id: string,
    {
      refreshToken,
      passwordResetToken,
    }: { refreshToken?: boolean; passwordResetToken?: boolean } = {},
  ): Promise<UserDocument> {
    return this.userModel
      .findById(id)
      .select(refreshToken && '+refreshToken')
      .select(passwordResetToken && '+passwordResetToken')
      .exec();
  }

  async create(createUserDto: CreateUserDto): Promise<UserDocument> {
    return this.userModel.create({ ...createUserDto, createdAt: new Date() });
  }

  async update(
    id: string,
    updateUserDto: UpdateUserDto,
  ): Promise<UserDocument> {
    return this.userModel
      .findByIdAndUpdate(id, updateUserDto, { new: true })
      .exec();
  }

  async updateRefreshToken(id: string, refreshToken: string | null) {
    return this.userModel
      .findByIdAndUpdate(id, { refreshToken }, { new: true })
      .exec();
  }
}
