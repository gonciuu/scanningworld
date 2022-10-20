import { useMutation } from '@tanstack/react-query';
import axios from 'axios';
import { Formik, Form, Field } from 'formik';
import { useRouter } from 'next/router';
import * as Yup from 'yup';

import { setTokens } from '@/common/lib/tokens';
import { useModal } from '@/modules/modal';

const LoginSchema = Yup.object().shape({
  email: Yup.string().email('Nieprawidłowy email').required('Wymagane'),
  password: Yup.string().required('Wymagane'),
});

const LoginModal = () => {
  const { closeModal } = useModal();

  const router = useRouter();

  const loginMutation = useMutation(
    (authRegionDto: { email: string; password: string }) => {
      return axios.post<{
        tokens: { accessToken: string; refreshToken: string };
      }>('auth/region/login', authRegionDto);
    },
    {
      onSuccess: (res) => {
        closeModal();
        setTokens(res.data.tokens);
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
        }}
        onSubmit={(values) => {
          loginMutation.mutate(values);
        }}
        validationSchema={LoginSchema}
      >
        {({ errors, touched }) => (
          <Form className="flex w-96 flex-col gap-5">
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

            {loginMutation.isError && (
              <div className="text-sm text-red-500">Niepoprawne dane!</div>
            )}

            <button
              type="submit"
              className="btn btn-primary"
              disabled={loginMutation.isLoading}
            >
              {loginMutation.isLoading ? 'Logowanie...' : 'Zaloguj'}
            </button>
          </Form>
        )}
      </Formik>
    </div>
  );
};

export default LoginModal;
