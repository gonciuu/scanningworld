const Bottom = () => {
  return (
    <div className="my-8 w-80">
      <button className="w-full rounded-lg bg-primary py-2 font-semibold text-white transition-colors hover:bg-green-500 focus:outline-none focus:ring focus:ring-black active:bg-primary">
        Zarejestruj rejon
      </button>
      <p className="text-[.6rem] font-semibold">
        * Powyższa rejestracja dotyczy jedynie administratorów swojego rejonu
        (samorządów).
      </p>
    </div>
  );
};

export default Bottom;
