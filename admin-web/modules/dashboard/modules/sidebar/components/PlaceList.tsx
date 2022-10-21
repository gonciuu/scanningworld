import { useQuery } from '@tanstack/react-query';
import axios from 'axios';

import Spinner from '@/common/components/Spinner';
import { useRegion } from '@/common/recoil/region';
import PlaceModal from '@/modules/dashboard/modals/PlaceModal';
import { PlaceType } from '@/modules/dashboard/types/place.type';
import { useModal } from '@/modules/modal';

import Place from './Place';

const PlaceList = () => {
  const { openModal } = useModal();
  const {
    region: { _id },
  } = useRegion();

  const { data, error, isLoading } = useQuery(
    ['places', _id],
    () => axios.get<PlaceType[]>(`places/${_id}`).then((res) => res.data),
    { enabled: !!_id }
  );

  if (isLoading)
    return (
      <div className="mt-16 flex w-full justify-center">
        <Spinner />
      </div>
    );

  if (error || !data) return <div>Error</div>;

  return (
    <div className="flex flex-1 flex-col overflow-hidden px-1">
      <div className="mt-4 mb-8 flex gap-4">
        <button className="btn btn-secondary w-full">Filtruj</button>
        <button
          className="btn btn-primary w-full"
          onClick={() => openModal(<PlaceModal />)}
        >
          Dodaj miejsce
        </button>
      </div>

      {data.length === 0 && (
        <div className="flex flex-1 items-center justify-center">
          <button className="p-4 transition-transform hover:scale-105 active:scale-100">
            <img
              src="images/empty.svg"
              alt="Dodaj miejsce"
              className="-mt-12 w-48"
            />
          </button>
        </div>
      )}

      {data.length !== 0 && (
        <div className="flex flex-1 flex-col gap-2 overflow-x-hidden overflow-y-scroll">
          {data.map((place) => (
            <Place {...place} key={place._id} />
          ))}
        </div>
      )}
    </div>
  );
};

export default PlaceList;
