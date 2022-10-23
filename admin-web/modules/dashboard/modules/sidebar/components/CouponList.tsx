import { useQuery } from '@tanstack/react-query';
import axios from 'axios';

import Spinner from '@/common/components/Spinner';
import { useRegion } from '@/common/recoil/region';
import CouponModal from '@/modules/dashboard/modals/CouponModal';
import { Write } from '@/modules/dashboard/types/write.type';
import { useFilter } from '@/modules/filter';
import { Sort } from '@/modules/filter/types.ts/filter.type';
import { useModal } from '@/modules/modal';

import Coupon from './Coupon';

const CouponList = () => {
  const {
    region: { _id },
  } = useRegion();
  const { openModal } = useModal();

  const { data, error, isLoading } = useQuery(
    ['coupons', _id],
    () => axios.get<any[]>(`coupons/${_id}`).then((res) => res.data),
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
          onClick={() => openModal(<CouponModal type={Write.POST} />)}
        >
          Dodaj kupon
        </button>
      </div>

      {data.length === 0 && (
        <div className="flex flex-1 items-center justify-center">
          <button
            className="p-4 transition-transform hover:scale-105 active:scale-100"
            onClick={() => openModal(<CouponModal type={Write.POST} />)}
          >
            <img
              src="images/empty.svg"
              alt="Dodaj kupon"
              className="-mt-12 w-48"
            />
          </button>
        </div>
      )}

      {filteredData.length !== 0 && (
        <div className="overflow-y-auto">
          <div className="grid min-h-0 grid-cols-2 gap-8 px-3">
            {filteredData.map((place) => (
              <Coupon {...place} key={place._id} />
            ))}
          </div>
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

export default CouponList;
