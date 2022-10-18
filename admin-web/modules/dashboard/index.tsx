import dynamic from 'next/dynamic';

const Dashboard = () => {
  const Map = dynamic(() => import('./modules/map'), { ssr: false });

  return (
    <div className="flex h-full w-full">
      <div className="w-1/3 bg-white"></div>
      <Map />
    </div>
  );
};

export default Dashboard;
