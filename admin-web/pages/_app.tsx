import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { MotionConfig } from 'framer-motion';
import type { AppProps } from 'next/app';
import Head from 'next/head';
import { RecoilRoot } from 'recoil';

import { setupAxios } from '@/common/lib/setupAxios';
import { ModalManager } from '@/modules/modal';

import '../common/styles/global.css';

const queryClient = new QueryClient();

setupAxios();

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
