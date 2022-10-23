import axios from 'axios';
import jwt_decode from 'jwt-decode';
import Router from 'next/router';

import { getTokens, setTokens } from './tokens';

let isRefreshing = false;

const resetApp = () => {
  setTokens({ accessToken: '', refreshToken: '' });
  Router.push('/');
};

const refreshAccessToken = async () => {
  const { refreshToken } = getTokens();

  if (!refreshToken) {
    resetApp();
    return '';
  }

  isRefreshing = true;

  const tokens = (
    await axios.get<{ accessToken: string; refreshToken: string }>(
      'auth/region/refresh',
      { headers: { Authorization: `Bearer ${refreshToken}` } }
    )
  ).data;

  setTokens(tokens);

  isRefreshing = false;

  return tokens.accessToken;
};

export const setupAxios = () => {
  axios.defaults.baseURL = 'https://scanningworld-server.herokuapp.com'; // 'http://localhost:8080';

  axios.interceptors.request.use(async (config) => {
    const { accessToken } = getTokens();
    let goodAccessToken = accessToken;

    if (accessToken && config.headers && !config.headers.Authorization) {
      const expiration = (jwt_decode(accessToken) as any).exp as number;

      if (expiration * 1000 < Date.now() && !isRefreshing) {
        goodAccessToken = await refreshAccessToken();
      }

      // eslint-disable-next-line no-param-reassign
      config.headers.Authorization = `Bearer ${goodAccessToken}`;
    }

    return config;
  });

  axios.interceptors.response.use(
    (response) => response,
    async (error) => {
      const status = error.response ? error.response.status : null;

      const tokens = getTokens();

      if (status === 401) {
        if (tokens.refreshToken) {
          refreshAccessToken();

          return axios.request(error.config);
        }

        resetApp();
      }

      if (status === 403) resetApp();

      return Promise.reject(error);
    }
  );
};
