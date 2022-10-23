import { useQuery } from '@tanstack/react-query';
import axios from 'axios';
import { NextPage } from 'next';

import Spinner from '@/common/components/Spinner';
import { useRegion } from '@/common/recoil/region';
import { RegionType } from '@/common/types/region.type';
import Dashboard from '@/modules/dashboard';

const DashboardPage: NextPage = () => {
  const {
    region: { _id },
    setRegion,
  } = useRegion();

  const regionQuery = useQuery(
    ['region'],
    () => {
      return axios.get<RegionType>('/regions/by-token').then((res) => res.data);
    },
    {
      onSuccess: (data) => setRegion(data),
      refetchInterval: 0,
      refetchOnWindowFocus: false,
    }
  );

  return (
    <>
      <div
        className="absolute top-0 left-0 flex h-full w-full items-center justify-center rounded-none bg-black lg:hidden"
        style={{ zIndex: 9999 }}
      >
        <h1 className="p-5 text-center text-white">
          Zaloguj się na komputerze, aby móc zarządzać rejonem
        </h1>
      </div>
      {(!_id || regionQuery.isLoading) && (
        <div className="flex h-full w-full items-center justify-center">
          <Spinner />
        </div>
      )}

      {_id && <Dashboard />}
    </>
  );
};

export default DashboardPage;
