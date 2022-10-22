import dynamic from 'next/dynamic';

import LogoutButton from './components/LogoutButton';
import Sidebar from './modules/sidebar';

const Dashboard = () => {
  const Map = dynamic(() => import('./modules/map'), { ssr: false });

  return (
    <div className="flex h-full w-full">
      <LogoutButton />

      <div className="w-[30rem] bg-white">
        <Sidebar />
      </div>

      <div className="relative flex-1">
        <Map />
      </div>
    </div>
  );
};

export default Dashboard;
