import { useState } from 'react';

import { Field, Form, Formik } from 'formik';
import * as Yup from 'yup';

import FormObserver from '@/common/components/FormObserver';
import { useModal } from '@/modules/modal';

import { useActivePlace } from '../recoil/activePlace';
import { useChangePlaceLocation } from '../recoil/placeLocation';

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

const PlaceModal = ({ place }: { place?: PlaceValues }) => {
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
    console.log(tempPlace);
    closeModal();
    setPlaceToActiveLocation((newLocation) => {
      openModal(
        <PlaceModal place={{ ...tempPlace, location: newLocation, imageUri }} />
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
        console.log(values);
      }}
      validationSchema={PlaceSchema}
    >
      {({ errors, touched }) => (
        <Form>
          <FormObserver onChange={setTempPlace} />
          <div>
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
                  <Field name="points" type="number" />

                  {errors.points && touched.points && (
                    <div className="absolute text-xs text-red-500">
                      {errors.points}
                    </div>
                  )}
                </label>

                <p className="font-semibold">
                  Lokalizacja:{' '}
                  <span>
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
              <button className="btn btn-primary w-36" type="submit">
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