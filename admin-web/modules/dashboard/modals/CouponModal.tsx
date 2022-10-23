import { useState } from 'react';

import { useMutation, useQueryClient } from '@tanstack/react-query';
import axios from 'axios';
import { Field, Form, Formik } from 'formik';
import Image from 'next/image';
import * as Yup from 'yup';

import { useModal } from '@/modules/modal';

import { CouponValues, PostCoupon } from '../types/coupon.type';
import { Write } from '../types/write.type';

const CouponSchema = Yup.object().shape({
  name: Yup.string().required('Wymagane'),
  points: Yup.number().required('Wymagane'),
});

const CouponModal = ({
  coupon,
  couponId,
  type = Write.EDIT,
}: {
  coupon?: CouponValues;
  couponId?: string;
  type?: Write;
}) => {
  const { closeModal } = useModal();

  const [imageUri, setImageUri] = useState('');

  const queryClient = useQueryClient();

  const createMutation = useMutation(
    (newCoupon: PostCoupon) => {
      return axios.post('coupons', newCoupon).then((res) => res.data);
    },
    {
      retry: 2,
      onSuccess: () => {
        queryClient.invalidateQueries(['coupons']);
        closeModal();
      },
    }
  );

  const editMutation = useMutation(
    (newCoupon: Partial<PostCoupon>) => {
      return axios.patch(`coupons/${couponId}`, newCoupon);
    },
    {
      retry: 2,
      onSuccess: () => {
        queryClient.invalidateQueries(['coupons']);
        closeModal();
      },
    }
  );

  const deleteMutation = useMutation(
    () => {
      return axios.delete(`coupons/${couponId!}`);
    },
    {
      retry: 2,
      onSuccess: () => {
        queryClient.invalidateQueries(['coupons']);
        closeModal();
      },
    }
  );

  const handleChangeImage = () => {
    const input = document.createElement('input');
    input.type = 'file';
    input.accept = 'image/*';
    input.onchange = (e) => {
      const target = e.target as HTMLInputElement;
      const file = target.files?.[0];

      if (file) {
        const reader = new FileReader();
        reader.readAsDataURL(file);
        reader.onload = () => {
          setImageUri(reader.result as string);
        };
      }
    };
    input.click();
  };

  return (
    <Formik
      initialValues={{
        name: coupon?.name || '',
        points: coupon?.points || 0,
      }}
      onSubmit={(values) => {
        const points = Math.max(0, values.points);

        if (type === Write.POST) {
          createMutation.mutate({
            name: values.name,
            points,
            imageBase64: imageUri,
          });
        } else {
          const editObject: Partial<PostCoupon> = {};

          if (values.name !== coupon?.name) {
            editObject.name = values.name;
          }

          if (values.points !== coupon?.points) {
            editObject.points = points;
          }

          if (imageUri) {
            editObject.imageBase64 = imageUri;
          }

          editMutation.mutate(editObject);
        }
      }}
      validationSchema={CouponSchema}
    >
      {({ errors, touched }) => (
        <Form>
          <div>
            <h1 className="mb-3 text-center text-lg font-semibold">
              {type === Write.EDIT ? 'Edytuj kupon' : 'Dodaj kupon'}
            </h1>
            <div className="flex gap-5">
              <div className="flex w-96 flex-col gap-5">
                <label className="relative">
                  <p className="font-semibold">Nazwa kuponu</p>
                  <Field name="name" as="textarea" className="h-16" />

                  {errors.name && touched.name && (
                    <div className="absolute text-xs text-red-500">
                      {errors.name}
                    </div>
                  )}
                </label>

                <label className="relative">
                  <p className="font-semibold">Liczba punktów</p>
                  <Field name="points" type="number" min={0} />

                  {errors.points && touched.points && (
                    <div className="absolute text-xs text-red-500">
                      {errors.points}
                    </div>
                  )}
                </label>
              </div>

              <div>
                <p className="font-semibold">Logo kuponu</p>
                <div className="relative h-16 w-48 overflow-hidden">
                  <Image
                    src={imageUri || coupon?.imageUri || '/images/logo.svg'}
                    alt="Zdjęcie miejsca"
                    className="cursor-pointer transition-transform hover:scale-105 active:scale-100"
                    layout="fill"
                    objectFit={imageUri ? 'scale-down' : 'contain'}
                    placeholder="blur"
                    blurDataURL="images/logo.svg"
                    onClick={handleChangeImage}
                  />
                </div>
                <button
                  className="btn btn-secondary mt-3 w-full py-1"
                  type="button"
                  onClick={handleChangeImage}
                >
                  Zmień zdjęcie
                </button>
              </div>
            </div>
            <div className="mt-5 flex justify-end gap-5">
              {type === Write.EDIT && (
                <button
                  className="btn btn-primary bg-red-500 hover:bg-red-600 active:bg-red-500"
                  onClick={() => deleteMutation.mutate()}
                >
                  {deleteMutation.isLoading ? 'Usuwanie...' : 'Usuń'}
                </button>
              )}
              <button
                className="btn btn-primary w-36"
                type="submit"
                disabled={createMutation.isLoading || editMutation.isLoading}
              >
                {createMutation.isLoading || editMutation.isLoading
                  ? 'Zapisywanie...'
                  : 'Zapisz'}
              </button>
            </div>
          </div>
        </Form>
      )}
    </Formik>
  );
};

export default CouponModal;
