import { useRecoilState } from 'recoil';

import { Place } from '../types/place.type';
import { mapAtom } from './map.atom';

export const usePlaces = () => {
  const [{ places, selectedPlace }, setMap] = useRecoilState(mapAtom);

  const setPlaces = (newPlaces: Place[]) => {
    setMap((map) => ({
      ...map,
      newPlaces,
    }));
  };

  const setSelectedPlace = (newSelectedPlace: Place | null) => {
    setMap((map) => ({
      ...map,
      newSelectedPlace,
    }));
  };

  return {
    places,
    selectedPlace,
    setPlaces,
    setSelectedPlace,
  };
};
