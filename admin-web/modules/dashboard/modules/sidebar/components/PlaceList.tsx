import { useQuery } from '@tanstack/react-query';
import axios from 'axios';

import Spinner from '@/common/components/Spinner';
import { PlaceType } from '@/modules/dashboard/types/place.type';

import Place from './Place';

const PlaceList = () => {
  const { data, error, isLoading } = useQuery(['places'], () =>
    axios
      .get<PlaceType[]>('places/63485005b9a6f084791d694a')
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
    <div className="flex flex-1 flex-col overflow-hidden">
      <div className="mt-4 mb-8 flex gap-4">
        <button className="btn btn-secondary w-full">Filtruj</button>
        <button className="btn btn-primary w-full">Dodaj miejsce</button>
      </div>
      <div className="flex flex-1 flex-col gap-2 overflow-x-hidden overflow-y-scroll">
        {data.map((place) => (
          <Place {...place} key={place._id} />
        ))}
      </div>
    </div>
  );
};

export default PlaceList;
