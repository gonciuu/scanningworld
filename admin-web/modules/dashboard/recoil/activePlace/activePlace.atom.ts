import { atom } from 'recoil';

import { Place } from '../types/place.type';

export const activePlaceAtom = atom<Place | null>({
  key: 'activePlaceAtom',
  default: null,
});
