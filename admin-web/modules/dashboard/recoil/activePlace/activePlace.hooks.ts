import { useRecoilState } from 'recoil';

import { activePlaceAtom } from './activePlace.atom';

export const useActivePlace = () => {
  const [activePlace, setActivePlace] = useRecoilState(activePlaceAtom);

  return {
    activePlace,
    setActivePlace,
  };
};
