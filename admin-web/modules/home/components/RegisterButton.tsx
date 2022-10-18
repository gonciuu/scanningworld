import { useModal } from '@/modules/modal';

const RegisterButton = () => {
  const { openModal } = useModal();

  const handleOpenRegisterModal = () => {
    openModal(<div></div>);
  };

  return (
    <div className="my-8 w-80">
      <button
        className="btn btn-primary w-full"
        onClick={handleOpenRegisterModal}
      >
        Zarejestruj rejon
      </button>
      <p className="text-[.6rem] font-semibold">
        * Powyższa rejestracja dotyczy jedynie administratorów swojego rejonu
        (samorządów).
      </p>
    </div>
  );
};

export default RegisterButton;
