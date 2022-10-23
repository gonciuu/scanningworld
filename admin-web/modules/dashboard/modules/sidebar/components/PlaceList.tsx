import { useQuery } from '@tanstack/react-query';
import axios from 'axios';

import Spinner from '@/common/components/Spinner';
import { useRegion } from '@/common/recoil/region';
import PlaceModal from '@/modules/dashboard/modals/PlaceModal';
import { useActivePlace } from '@/modules/dashboard/recoil/activePlace';
import { PlaceType } from '@/modules/dashboard/types/place.type';
import { Write } from '@/modules/dashboard/types/write.type';
import { useFilter } from '@/modules/filter';
import { Sort } from '@/modules/filter/types.ts/filter.type';
import { useModal } from '@/modules/modal';

import Place from './Place';

const PlaceList = () => {
  const { openModal } = useModal();
  const {
    region: { _id },
  } = useRegion();
  const { setActivePlace } = useActivePlace();

  const { data, error, isLoading } = useQuery(
    ['places'],
    () => axios.get<PlaceType[]>(`places/as-region`).then((res) => res.data),
    { enabled: !!_id }
  );

  const { Filter, search, openFilter, sort } = useFilter();

  if (isLoading)
    return (
      <div className="mt-16 flex w-full justify-center">
        <Spinner />
      </div>
    );

  if (error || !data) return <div>Error</div>;

  const filteredData = data
    .filter((place) => {
      const name = place.name.toLowerCase();
      const searchLower = search.toLowerCase();

      return name.includes(searchLower);
    })
    .sort((a, b) => {
      if (sort === Sort.NAME_ASC) return a.name.localeCompare(b.name);
      if (sort === Sort.NAME_DESC) return b.name.localeCompare(a.name);

      if (sort === Sort.POINTS_ASC) return a.points - b.points;
      if (sort === Sort.POINTS_DESC) return b.points - a.points;

      return 0;
    });

  return (
    <div className="flex flex-1 flex-col overflow-hidden px-1">
      <div className="mt-4 mb-8 flex gap-4">
        <div className="relative w-full">
          <button className="btn btn-secondary w-full" onClick={openFilter}>
            Filtruj
          </button>
          {Filter}
        </div>
        <button
          className="btn btn-primary w-full"
          onClick={() => {
            setActivePlace(null);
            openModal(<PlaceModal type={Write.POST} />);
          }}
        >
          Dodaj miejsce
        </button>
      </div>

      {data.length === 0 && (
        <div className="flex flex-1 items-center justify-center">
          <button
            className="p-4 transition-transform hover:scale-105 active:scale-100"
            onClick={() => openModal(<PlaceModal />)}
          >
            <img
              src="images/empty.svg"
              alt="Dodaj miejsce"
              className="-mt-12 w-48"
            />
          </button>
        </div>
      )}

      {filteredData.length !== 0 && (
        <div className="flex flex-1 flex-col gap-2 overflow-x-hidden overflow-y-scroll">
          {filteredData.map((place) => (
            <Place {...place} key={place._id} />
          ))}
        </div>
      )}

      {filteredData.length === 0 && (
        <div className="flex flex-1 items-center justify-center">
          <p>Brak wyników</p>
        </div>
      )}
    </div>
  );
};

export default PlaceList;
