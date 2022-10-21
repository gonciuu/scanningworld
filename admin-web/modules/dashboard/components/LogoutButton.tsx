import { useMutation } from '@tanstack/react-query';
import axios from 'axios';
import { useRouter } from 'next/router';

import { setTokens } from '@/common/lib/tokens';

const LogoutButton = () => {
  const router = useRouter();

  const mutateLogout = useMutation(
    () => {
      return axios.get('auth/region/logout');
    },
    {
      onSuccess: () => {
        setTokens({ refreshToken: '', accessToken: '' });
        router.push('/');
      },
      retry: 1,
    }
  );

  return (
    <button
      className="btn btn-secondary absolute top-5 right-5 z-30 w-44"
      onClick={() => mutateLogout.mutate()}
    >
      {mutateLogout.isLoading ? 'Wylogowywanie...' : 'Wyloguj się'}
    </button>
  );
};

export default LogoutButton;
