import Link from 'next/link';
import { FaGooglePlay, FaApple } from 'react-icons/fa';

const GetApp = () => {
  return (
    <>
      <div className="flex items-center justify-center gap-10">
        <a
          className="flex h-16 w-52 items-center justify-between rounded-lg bg-black p-4 text-left text-white hover:bg-black/90 active:bg-black"
          href="https://github.com/gonciuu/scanningworld"
          target="_blank"
          rel="noreferrer"
        >
          <FaGooglePlay className="h-10 w-10" />
          <div>
            <p className="text-xs">GET IT ON</p>
            <p className="text-xl font-semibold leading-none">Google Play</p>
          </div>
        </a>

        <a
          className="flex h-16 w-52 items-center justify-between rounded-lg bg-black p-6 text-left text-white hover:bg-black/90 active:bg-black"
          href="https://github.com/gonciuu/scanningworld"
          target="_blank"
          rel="noreferrer"
        >
          <FaApple className="h-10 w-10" />
          <div>
            <p className="text-xs">Download on the</p>
            <p className="text-xl font-semibold leading-none">App Store</p>
          </div>
        </a>
      </div>
      <p className="mt-2 text-xs">
        *Google Play and the Google Play logo are trademarks of Google LLC.
      </p>
      <Link href="/privacy">
        <a className="mt-2 text-xs font-bold underline">Polityka prywatności</a>
      </Link>
    </>
  );
};

export default GetApp;
