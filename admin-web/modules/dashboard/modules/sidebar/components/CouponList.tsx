import { useQuery } from '@tanstack/react-query';
import axios from 'axios';

import Spinner from '@/common/components/Spinner';

import CouponComponent from './Coupon';

const CouponList = () => {
  const { data, error, isLoading } = useQuery(['coupons'], () =>
    axios.get<any[]>('coupons/63485005b9a6f084791d694a').then((res) => res.data)
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
        <button className="btn btn-primary w-full">Dodaj kupon</button>
      </div>
      <div className="grid min-h-0 flex-1 grid-cols-2 gap-8 overflow-y-auto px-3">
        {data.map((place) => (
          <CouponComponent {...place} key={place._id} />
        ))}
      </div>
    </div>
  );
};

export default CouponList;
