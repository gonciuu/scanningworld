import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';

import { isValidObjectId, Model } from 'mongoose';
import { RegionsService } from 'src/regions/regions.service';

import { CreateUserDto } from './dto/createUserDto';
import { UpdateUserDto } from './dto/updateUserDto';
import { User, UserDocument } from './schemas/user.schema';

@Injectable()
export class UsersService {
  constructor(
    @InjectModel(User.name) private userModel: Model<UserDocument>,
    private regionsService: RegionsService,
  ) {}

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
      password,
    }: {
      refreshToken?: boolean;
      passwordResetToken?: boolean;
      password?: boolean;
    } = {},
  ): Promise<UserDocument> {
    return this.userModel
      .findById(id)
      .select(refreshToken && '+refreshToken')
      .select(passwordResetToken && '+passwordResetToken')
      .select(password && '+password')
      .exec();
  }

  async create(createUserDto: CreateUserDto): Promise<UserDocument> {
    const { regionId, ...user } = createUserDto;

    if (!isValidObjectId(regionId)) {
      throw new BadRequestException('Invalid region id');
    }

    const region = await this.regionsService.findById(regionId);

    if (!region) {
      throw new NotFoundException('Region not found');
    }

    return this.userModel.create({
      ...user,
      region: regionId,
    });
  }

  async update(
    id: string,
    updateUserDto: UpdateUserDto,
  ): Promise<UserDocument> {
    const { regionId } = updateUserDto;

    if (regionId && !isValidObjectId(regionId)) {
      throw new BadRequestException('Invalid region id');
    }

    const region = regionId && (await this.regionsService.findById(regionId));

    if (regionId && !region) {
      throw new NotFoundException('Region not found');
    }

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
