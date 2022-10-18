import { MotionConfig } from 'framer-motion';
import type { AppProps } from 'next/app';
import Head from 'next/head';
import { RecoilRoot } from 'recoil';

import { ModalManager } from '@/modules/modal';

import '../common/styles/global.css';

const App = ({ Component, pageProps }: AppProps) => {
  return (
    <>
      <Head>
        <title>Template</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <RecoilRoot>
        <MotionConfig transition={{ ease: [0.6, 0.01, -0.05, 0.9] }}>
          <ModalManager />
          <Component {...pageProps} />
        </MotionConfig>
      </RecoilRoot>
    </>
  );
};

export default App;
