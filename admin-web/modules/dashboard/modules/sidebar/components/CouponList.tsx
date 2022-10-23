import { useQuery } from '@tanstack/react-query';
import axios from 'axios';

import Spinner from '@/common/components/Spinner';
import { useRegion } from '@/common/recoil/region';
import CouponModal from '@/modules/dashboard/modals/CouponModal';
import { Write } from '@/modules/dashboard/types/write.type';
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

      {data.length !== 0 && (
        <div className="grid min-h-0 flex-1 grid-cols-2 gap-8 overflow-y-auto px-3">
          {data.map((place) => (
            <Coupon {...place} key={place._id} />
          ))}
        </div>
      )}
    </div>
  );
};

export default CouponList;
