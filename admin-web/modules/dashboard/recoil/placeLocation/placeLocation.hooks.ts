import { useRecoilState } from 'recoil';

import { useActivePlace } from '../activePlace';
import { placeLocationAtom } from './placeLocation.atom';

export const useChangePlaceLocation = () => {
  const [placeLocation, setPlaceLocation] = useRecoilState(placeLocationAtom);

  const { setActivePlace } = useActivePlace();

  const setPlaceToActiveLocation = (
    onSave: (location: { lat: number; lng: number }) => void,
    id: string = ''
  ) => {
    setPlaceLocation({
      ...placeLocation,
      onSave,
      active: true,
      id,
    });
  };

  const saveLocation = () => {
    setActivePlace(null);

    placeLocation.onSave({ lat: placeLocation.lat, lng: placeLocation.lng });
    setPlaceLocation({
      ...placeLocation,
      active: false,
      id: '',
    });
  };

  const setLocation = (location: { lat: number; lng: number }) => {
    setPlaceLocation({
      ...placeLocation,
      lat: +location.lat.toFixed(5),
      lng: +location.lng.toFixed(5),
    });
  };

  const cancelLocation = () => {
    setActivePlace(null);
    setPlaceLocation({
      ...placeLocation,
      active: false,
      onSave: (_location: { lat: number; lng: number }) => {},
      id: '',
    });
  };

  return {
    placeLocation,
    setPlaceToActiveLocation,
    saveLocation,
    setLocation,
    cancelLocation,
  };
};
