import axios, { AxiosError } from 'axios';
import jwt_decode from 'jwt-decode';
import Router from 'next/router';

import { getTokens, setTokens } from './tokens';

const refreshAccessToken = async () => {
  const { refreshToken } = getTokens();

  const tokens = (
    await axios.get<{ accessToken: string; refreshToken: string }>(
      'auth/region/refresh',
      { headers: { Authorization: `Bearer ${refreshToken}` } }
    )
  ).data;

  setTokens(tokens);

  return tokens.accessToken;
};

export const setupAxios = () => {
  axios.defaults.baseURL = 'http://localhost:8080'; //  'https://scanningworld-server.herokuapp.com';

  axios.interceptors.request.use(async (config) => {
    const { accessToken } = getTokens();
    let goodAccessToken = accessToken;

    if (accessToken && config.headers && !config.headers.Authorization) {
      const expiration = (jwt_decode(accessToken) as any).exp as number;

      if (expiration * 1000 < Date.now()) {
        goodAccessToken = await refreshAccessToken();
      }

      // eslint-disable-next-line no-param-reassign
      config.headers.Authorization = `Bearer ${goodAccessToken}`;
    }

    return config;
  });

  const resetApp = () => {
    setTokens({ accessToken: '', refreshToken: '' });
    Router.push('/');
  };

  axios.interceptors.response.use(
    (response) => response,
    async (error: AxiosError) => {
      const status = error.response ? error.response.status : null;

      if (status === 403) resetApp();

      return Promise.reject(error);
    }
  );
};
