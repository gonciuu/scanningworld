import { useMutation } from '@tanstack/react-query';
import axios from 'axios';
import { Field, Form, Formik } from 'formik';
import { NextPage } from 'next';
import { useRouter } from 'next/router';

const ResetPasswordPage: NextPage = () => {
  const router = useRouter();
  const { token } = router.query;

  const changePasswordMutation = useMutation((newPassword: string) => {
    return axios.post('auth/reset-password', {
      passwordResetToken: token,
      newPassword,
    });
  });

  return (
    <div className="flex h-full w-full items-center justify-center">
      <div className="h-full w-full sm:w-96">
        <h1 className="mt-10 text-center text-2xl font-bold">
          scanning<span className="font-bold text-primary">world</span>
        </h1>

        <h2 className="mt-10 mb-5 text-center text-lg font-semibold">
          Zresetuj hasło
        </h2>

        <Formik
          initialValues={{ password: '', confirmPassword: '' }}
          validate={(values) => {
            const errors: Record<string, string> = {};

            if (!values.password) {
              errors.password = 'Wpisz hasło';
            }

            if (!values.confirmPassword) {
              errors.confirmPassword = 'Potwierdź hasło';
            }

            if (values.password !== values.confirmPassword) {
              errors.confirmPassword = 'Hasła nie są takie same';
            }

            return errors;
          }}
          onSubmit={(values) => {
            changePasswordMutation.mutate(values.password);
            router.push('/success');
          }}
        >
          {({ errors, touched }) => (
            <Form className="px-6">
              <label className="relative">
                <p>Nowe hasło</p>
                <Field
                  name="password"
                  placeholder="Wpisz nowe hasło..."
                  type="password"
                />

                {errors.password && touched.password && (
                  <div className="absolute text-xs text-red-500">
                    {errors.password}
                  </div>
                )}
              </label>

              <label className="relative">
                <p className="mt-4">Powtórz nowe hasło</p>
                <Field
                  name="confirmPassword"
                  placeholder="Wpisz ponownie nowe hasło..."
                  type="password"
                />

                {errors.confirmPassword && touched.confirmPassword && (
                  <div className="absolute text-xs text-red-500">
                    {errors.confirmPassword}
                  </div>
                )}
              </label>

              <button type="submit" className="btn btn-primary mt-5 w-full">
                {changePasswordMutation.isLoading
                  ? 'Zmiana hasła...'
                  : 'Zmień hasło'}
              </button>
            </Form>
          )}
        </Formik>
      </div>
    </div>
  );
};

export default ResetPasswordPage;
