// import { useEffect } from 'react';

// import axios from 'axios';
import { NextPage } from 'next';

// import Spinner from '@/common/components/Spinner';
// import { useRegion } from '@/common/recoil/region';
import Dashboard from '@/modules/dashboard';

const DashboardPage: NextPage = () => {
  // const {
  //   region: { _id },
  //   setRegion,
  // } = useRegion();

  // useEffect(() => {
  //   if (!_id) {
  //     axios.get('regions/by-token').then((res) => {
  //       setRegion(res.data);
  //     });
  //   }
  // }, [_id, setRegion]);

  // if (!_id)
  //   return (
  //     <div className="flex h-full w-full items-center justify-center">
  //       <Spinner />
  //     </div>
  //   );

  return <Dashboard />;
};

export default DashboardPage;
