import { useRecoilState } from 'recoil';

import { regionAtom } from './region.atom';

export const useRegion = () => {
  const [region, setRegion] = useRecoilState(regionAtom);

  return {
    region,
    setRegion,
  };
};
