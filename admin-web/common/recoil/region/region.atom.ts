import { atom } from 'recoil';

import { RegionType } from '@/common/types/region.type';

export const regionAtom = atom<RegionType>({
  key: 'regionAtom',
  default: {
    _id: '',
    name: '',
    placeCount: 0,
    email: '',
  },
});
