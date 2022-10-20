import { atom } from 'recoil';

import { PlaceType } from '../../types/place.type';

export const activePlaceAtom = atom<PlaceType | null>({
  key: 'activePlaceAtom',
  default: null,
});
