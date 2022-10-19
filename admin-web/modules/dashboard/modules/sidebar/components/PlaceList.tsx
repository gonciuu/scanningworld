import { useQuery } from '@tanstack/react-query';
import axios from 'axios';

import Spinner from '@/common/components/Spinner';

import { Place } from '../../map/types/place.type';

const PlaceList = () => {
  const { data, error, isLoading } = useQuery(['places'], () =>
    axios
      .get<Place[]>('places/63485005b9a6f084791d694a')
      .then((res) => res.data)
  );

  if (isLoading)
    return (
      <div className="mt-16 flex w-full justify-center">
        <Spinner />
      </div>
    );

  if (error || !data) return <div>Error</div>;

  return (
    <div>
      <div className="mt-4 mb-8 flex gap-4">
        <button className="btn btn-secondary w-full">Filtruj</button>
        <button className="btn btn-primary w-full">Dodaj miejsce</button>
      </div>
      <div className="flex flex-col gap-2">
        {data.map((place) => (
          <div key={place._id} className="flex items-center gap-2">
            <div className="h-10 w-10 rounded-full bg-gray-200" />
            <div className="flex-1">
              <div className="text-sm font-semibold">{place.name}</div>
              <div className="text-xs text-gray-500">
                {place.location.lat} \ {place.location.lng}
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default PlaceList;
