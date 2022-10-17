const Header = () => {
  return (
    <div className="flex flex-col items-center text-center font-bold">
      <h1 className="w-max text-[3.5vw] font-bold">
        scanning<span className="font-bold text-primary">world</span>
      </h1>
      <h2 className="-mt-2 w-[25vw] text-[1.2vw]">
        Dołącz do nas i zacznij budować{' '}
        <span className="font-bold text-primary">swoją społeczność</span>{' '}
        aktywnych podróżników!
      </h2>
    </div>
  );
};

export default Header;
