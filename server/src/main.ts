import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';

import { v2 } from 'cloudinary';
import { urlencoded, json } from 'express';

import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.useGlobalPipes(new ValidationPipe());

  app.enableCors();

  app.use(json({ limit: '50mb' }));
  app.use(urlencoded({ limit: '50mb' }));

  v2.config({
    cloud_name: process.env.CLOUDINARY_CLOUD_NAME,

    api_key: process.env.CLOUDINARY_API_KEY,

    api_secret: process.env.CLOUDINARY_API_SECRET,
  });

  await app.listen(process.env.PORT || 8080);
}
bootstrap();
