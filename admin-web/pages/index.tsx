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

  return (
    <>
      <div
        className="absolute top-0 left-0 flex h-full w-full items-center justify-center rounded-none bg-black lg:hidden"
        style={{ zIndex: 9999 }}
      >
        <h1 className="p-5 text-center text-white">
          Zaloguj się na komputerze, aby móc zarządzać rejonem
        </h1>
      </div>
      <Home />
    </>
  );
};

export default HomePage;
