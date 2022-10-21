import { useEffect } from 'react';

import type { NextPage } from 'next';
import { useRouter } from 'next/router';

import { getTokens } from '@/common/lib/tokens';
import Home from '@/modules/home';

const HomePage: NextPage = () => {
  const router = useRouter();

  useEffect(() => {
    const { accessToken } = getTokens();

    if (accessToken) router.push('/dashboard');
  }, [router]);

  return <Home />;
};

export default HomePage;
