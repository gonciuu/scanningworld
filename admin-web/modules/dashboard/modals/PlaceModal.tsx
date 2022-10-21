import { useState } from 'react';

import { useMutation } from '@tanstack/react-query';
import axios from 'axios';
import { Field, Form, Formik } from 'formik';
import * as Yup from 'yup';

import FormObserver from '@/common/components/FormObserver';
import { useModal } from '@/modules/modal';

import { useActivePlace } from '../recoil/activePlace';
import { useChangePlaceLocation } from '../recoil/placeLocation';
import { Write } from '../types/write.type';

const PlaceSchema = Yup.object().shape({
  name: Yup.string().required('Wymagane'),
  description: Yup.string().required('Wymagane'),
  points: Yup.number().required('Wymagane'),
});

type PlaceValues = {
  name: string;
  description: string;
  points: number;
  location: { lat: number; lng: number };
  imageUri: string;
};

interface PostPlace extends Omit<PlaceValues, 'imageUri' | 'location'> {
  imageBase64: string;
  lat: number;
  lng: number;
}

const PlaceModal = ({
  place,
  type = Write.EDIT,
}: {
  place?: PlaceValues;
  type?: Write;
}) => {
  const { activePlace } = useActivePlace();
  const { setPlaceToActiveLocation } = useChangePlaceLocation();
  const { closeModal, openModal } = useModal();

  const [imageUri, setImageUri] = useState(place?.imageUri || '');

  const [tempPlace, setTempPlace] = useState<{
    name: string;
    description: string;
    points: number;
  }>(
    place || {
      name: '',
      description: '',
      points: 0,
    }
  );

  const createMutation = useMutation(
    (newPlace: PostPlace) => {
      return axios.post('places', newPlace);
    },
    { retry: 2 }
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

  const handlePlaceLocationChange = () => {
    closeModal();
    setPlaceToActiveLocation((newLocation) => {
      openModal(
        <PlaceModal
          place={{ ...tempPlace, location: newLocation, imageUri }}
          type={type}
        />
      );
    }, activePlace?._id);
  };

  const location = place?.location || activePlace?.location;

  return (
    <Formik
      initialValues={{
        name: place?.name || activePlace?.name || '',
        description: place?.description || activePlace?.description || '',
        points: place?.points || activePlace?.points || 0,
      }}
      onSubmit={(values) => {
        if (location && type === Write.POST) {
          const points = Math.max(0, values.points);

          createMutation.mutate({
            ...values,
            ...location,
            points,
            imageBase64: imageUri,
          });
        }
      }}
      validationSchema={PlaceSchema}
    >
      {({ errors, touched }) => (
        <Form>
          <FormObserver onChange={setTempPlace} />
          <div>
            <h1 className="mb-3 text-center text-lg font-semibold">
              {type === Write.EDIT ? 'Edytuj miejsce' : 'Dodaj miejsce'}
            </h1>
            <div className="flex gap-5">
              <div className="flex w-96 flex-col gap-5">
                <label className="relative">
                  <p className="font-semibold">Nazwa lokalizacji</p>
                  <Field name="name" />

                  {errors.name && touched.name && (
                    <div className="absolute text-xs text-red-500">
                      {errors.name}
                    </div>
                  )}
                </label>

                <label className="relative">
                  <p className="font-semibold">Opis</p>
                  <Field as="textarea" name="description" className="h-24" />

                  {errors.description && touched.description && (
                    <div className="absolute text-xs text-red-500">
                      {errors.description}
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

                <p className="font-semibold">
                  Lokalizacja:{' '}
                  <span
                    className={
                      !location
                        ? 'font-semibold text-red-500'
                        : 'font-semibold text-primary'
                    }
                  >
                    {location
                      ? `${location.lat} / ${location.lng}`
                      : 'nieustawione'}
                  </span>
                </p>
              </div>

              <div>
                <p className="font-semibold">Zdjęcie lokalizacji</p>
                <img
                  src={imageUri || 'images/placeholder.jpg'}
                  alt="Zdjęcie miejsca"
                  className="h-48 w-48 cursor-pointer object-cover transition-transform hover:scale-105 active:scale-100"
                  onClick={handleChangeImage}
                />
                <button
                  className="btn btn-primary mt-3 w-full py-1"
                  onClick={handleChangeImage}
                >
                  Zmień zdjęcie
                </button>
              </div>
            </div>
            <div className="mt-5 flex justify-end gap-5">
              <button
                className="btn btn-secondary"
                onClick={handlePlaceLocationChange}
                type="button"
              >
                Zaznacz na mapie
              </button>
              <button
                className="btn btn-primary w-36"
                type="submit"
                disabled={!location}
              >
                Zapisz
              </button>
            </div>
            <p className="mt-2 text-right text-xs">
              *Kod QR zostanie automatycznie wygenerowany.
            </p>
          </div>
        </Form>
      )}
    </Formik>
  );
};

export default PlaceModal;
