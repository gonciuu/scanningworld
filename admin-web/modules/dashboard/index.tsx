import dynamic from 'next/dynamic';

import Sidebar from './modules/sidebar';

const Dashboard = () => {
  const Map = dynamic(() => import('./modules/map'), { ssr: false });

  return (
    <div className="flex h-full w-full">
      <div className="w-[30rem] bg-white">
        <Sidebar />
      </div>
      <Map />
    </div>
  );
};

export default Dashboard;
