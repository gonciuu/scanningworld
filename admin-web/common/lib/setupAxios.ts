import axios from 'axios';
import Router from 'next/router';

import { getTokens, setTokens } from './tokens';

export const setupAxios = () => {
  axios.defaults.baseURL = 'http://localhost:8080'; // 'https://scanningworld-server.herokuapp.com';

  axios.interceptors.request.use((config) => {
    const { accessToken } = getTokens();

    if (accessToken && config.headers && !config.headers.Authorization) {
      // eslint-disable-next-line no-param-reassign
      config.headers.Authorization = `Bearer ${accessToken}`;
    }

    return config;
  });

  const resetApp = () => {
    setTokens({ accessToken: '', refreshToken: '' });
    Router.push('/');
  };

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

        resetApp();
      }

      if (status === 403) resetApp();

      return Promise.reject(error);
    }
  );
};
