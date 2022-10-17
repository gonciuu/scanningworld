import { FaGooglePlay, FaApple } from 'react-icons/fa';

const GetApp = () => {
  return (
    <div className="flex items-center justify-center gap-10">
      <div className="flex h-16 w-52 items-center justify-between rounded-lg bg-black p-4 text-white">
        <FaGooglePlay className="h-10 w-10" />
        <div>
          <p className="text-xs">GET IT ON</p>
          <p className="text-xl font-semibold leading-none">Google Play</p>
        </div>
      </div>
      <div className="flex h-16 w-52 items-center justify-between rounded-lg bg-black p-6 text-white">
        <FaApple className="h-10 w-10" />
        <div>
          <p className="text-xs">Download on the</p>
          <p className="text-xl font-semibold leading-none">App Store</p>
        </div>
      </div>
    </div>
  );
};

export default GetApp;
