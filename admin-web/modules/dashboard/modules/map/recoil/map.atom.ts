import { atom } from 'recoil';

import { Place } from '../types/place.type';

export const mapAtom = atom<{
  places: Place[];
  selectedPlace: Place | null;
}>({
  key: 'mapAtom',
  default: {
    places: [],
    selectedPlace: null,
  },
});
