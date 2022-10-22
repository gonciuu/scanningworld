import { useEffect } from 'react';

import { useFormikContext } from 'formik';

const FormObserver = ({ onChange }: { onChange: (values: any) => void }) => {
  const { values } = useFormikContext();

  useEffect(() => {
    onChange(values);

    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [values]);

  return null;
};

export default FormObserver;
