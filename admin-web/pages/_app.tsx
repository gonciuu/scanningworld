import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import axios from 'axios';
import { MotionConfig } from 'framer-motion';
import type { AppProps } from 'next/app';
import Head from 'next/head';
import { RecoilRoot } from 'recoil';

import { getTokens, setTokens } from '@/common/lib/tokens';
import { ModalManager } from '@/modules/modal';

import '../common/styles/global.css';

const queryClient = new QueryClient();

axios.defaults.baseURL = 'http://localhost:8080'; // 'https://scanningworld-server.herokuapp.com';

axios.interceptors.request.use((config) => {
  const { accessToken } = getTokens();

  if (accessToken && config.headers && !config.headers.Authorization) {
    // eslint-disable-next-line no-param-reassign
    config.headers.Authorization = `Bearer ${accessToken}`;
  }

  return config;
});

axios.interceptors.response.use(
  (response) => response,
  async (error) => {
    const status = error.response ? error.response.status : null;

    if (status === 401) {
      const { refreshToken } = getTokens();

      if (refreshToken) {
        // eslint-disable-next-line no-console
        console.log('refreshing token...');
        const tokens = (
          await axios.get<{ accessToken: string; refreshToken: string }>(
            'auth/region/refresh',
            { headers: { Authorization: `Bearer ${refreshToken}` } }
          )
        ).data;

        setTokens(tokens);

        return axios.request(error.config);
      }
    }

    return Promise.reject(error);
  }
);

const App = ({ Component, pageProps }: AppProps) => {
  return (
    <>
      <Head>
        <title>Template</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <RecoilRoot>
        <QueryClientProvider client={queryClient}>
          <MotionConfig transition={{ ease: [0.6, 0.01, -0.05, 0.9] }}>
            <ModalManager />
            <Component {...pageProps} />
          </MotionConfig>
        </QueryClientProvider>
      </RecoilRoot>
    </>
  );
};

export default App;
