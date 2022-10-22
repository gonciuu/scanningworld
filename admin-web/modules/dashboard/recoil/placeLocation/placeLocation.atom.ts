import { atom } from 'recoil';

export const placeLocationAtom = atom({
  key: 'placeLocation',
  default: {
    id: '',
    active: false,
    onSave: (_location: { lat: number; lng: number }) => {},
    lat: 0,
    lng: 0,
  },
});
