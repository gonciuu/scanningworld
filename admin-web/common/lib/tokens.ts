export const setTokens = (tokens: {
  refreshToken: string;
  accessToken: string;
}) => {
  localStorage.setItem('refreshToken', tokens.refreshToken);
  localStorage.setItem('accessToken', tokens.accessToken);
};

export const getTokens = () => {
  return {
    refreshToken: localStorage.getItem('refreshToken') || '',
    accessToken: localStorage.getItem('accessToken') || '',
  };
};
