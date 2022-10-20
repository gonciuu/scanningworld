import { useMutation } from '@tanstack/react-query';
import axios from 'axios';
import { Formik, Form, Field } from 'formik';
import { useRouter } from 'next/router';
import * as Yup from 'yup';

import { setTokens } from '@/common/lib/tokens';
import { useRegion } from '@/common/recoil/region';
import { RegionType } from '@/common/types/region.type';
import { useModal } from '@/modules/modal';

const RegisterSchema = Yup.object().shape({
  name: Yup.string()
    .min(2, 'Nazwa jest za krótka!')
    .max(50, 'Nazwa jest za długa!')
    .required('Wymagane'),
  email: Yup.string().email('Nieprawidłowy email').required('Wymagane'),
  password: Yup.string().required('Wymagane'),
  passwordConfirmation: Yup.string().required('Wymagane'),
});

const RegisterModal = () => {
  const { closeModal } = useModal();
  const { setRegion } = useRegion();

  const router = useRouter();

  const registerMutation = useMutation(
    (registerRegionDto: { name: string; email: string; password: string }) => {
      return axios.post<{
        tokens: { accessToken: string; refreshToken: string };
        region: RegionType;
      }>('auth/region/register', registerRegionDto);
    },
    {
      onSuccess: ({ data }) => {
        closeModal();
        setTokens(data.tokens);
        setRegion(data.region);
        router.push('dashboard');
      },
    }
  );

  return (
    <div>
      <Formik
        initialValues={{
          email: '',
          password: '',
          passwordConfirmation: '',
          name: '',
        }}
        onSubmit={(values) => {
          registerMutation.mutate(values);
        }}
        validationSchema={RegisterSchema}
        validate={(values) => {
          const errors: any = {};

          if (values.password !== values.passwordConfirmation) {
            errors.passwordConfirmation = 'Hasła nie są takie same!';
          }

          return errors;
        }}
      >
        {({ errors, touched }) => (
          <Form className="flex w-96 flex-col gap-5">
            <label className="relative">
              <p>Nazwa rejonu</p>
              <Field name="name" placeholder="Podaj nazwę rejonu" />

              {errors.name && touched.name && (
                <div className="absolute text-xs text-red-500">
                  {errors.name}
                </div>
              )}
            </label>

            <label className="relative">
              <p>Email</p>
              <Field name="email" placeholder="Podaj email rejonu" />

              {errors.email && touched.email && (
                <div className="absolute text-xs text-red-500">
                  {errors.email}
                </div>
              )}
            </label>

            <label className="relative">
              <p>Hasło</p>
              <Field
                name="password"
                placeholder="Podaj hasło"
                type="password"
              />

              {errors.password && touched.password && (
                <div className="absolute text-xs text-red-500">
                  {errors.password}
                </div>
              )}
            </label>

            <label className="relative">
              <p>Potwierdź hasło</p>
              <Field
                name="passwordConfirmation"
                placeholder="Potwierdź hasło"
                type="password"
              />

              {errors.passwordConfirmation && touched.passwordConfirmation && (
                <div className="absolute text-xs text-red-500">
                  {errors.passwordConfirmation}
                </div>
              )}
            </label>

            {registerMutation.isError && (
              <div className="text-sm text-red-500">
                Region z takim emailem już istnieje!
              </div>
            )}

            <button type="submit" className="btn btn-primary">
              Zarejestruj
            </button>
          </Form>
        )}
      </Formik>
    </div>
  );
};

export default RegisterModal;
