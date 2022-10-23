import { NextPage } from 'next';

const SuccessPage: NextPage = () => {
  return (
    <div className="-mt-12 flex h-full w-full flex-col items-center justify-center p-10">
      <h1 className="mt-10 mb-5 text-center text-2xl font-bold">
        scanning<span className="font-bold text-primary">world</span>
      </h1>

      <p className="text-center font-semibold">
        Sukces! Zaloguj się na swoje konto w aplikacji.
      </p>
    </div>
  );
};

export default SuccessPage;
