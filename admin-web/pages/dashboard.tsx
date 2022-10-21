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

  if (!_id || regionQuery.isLoading)
    return (
      <div className="flex h-full w-full items-center justify-center">
        <Spinner />
      </div>
    );

  return <Dashboard />;
};

export default DashboardPage;
