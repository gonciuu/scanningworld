import { Formik, Form, Field } from 'formik';
import { useRouter } from 'next/router';
import * as Yup from 'yup';

import { useModal } from '@/modules/modal';

const LoginSchema = Yup.object().shape({
  email: Yup.string().email('Nieprawidłowy email').required('Wymagane'),
  password: Yup.string().required('Wymagane'),
});

const LoginModal = () => {
  const { closeModal } = useModal();

  const router = useRouter();

  return (
    <div>
      <Formik
        initialValues={{
          email: '',
          password: '',
        }}
        onSubmit={(values) => {
          console.log(values);
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

            <button
              type="submit"
              className="btn btn-primary"
              onClick={() => {
                closeModal();
                router.push('/dashboard');
              }}
            >
              Zaloguj
            </button>
          </Form>
        )}
      </Formik>
    </div>
  );
};

export default LoginModal;
