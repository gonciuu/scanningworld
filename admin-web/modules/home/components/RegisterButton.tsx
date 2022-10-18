import { useModal } from '@/modules/modal';

import RegisterModal from '../modals/RegisterModal';

const RegisterButton = () => {
  const { openModal } = useModal();

  const handleOpenRegisterModal = () => {
    openModal(<RegisterModal />);
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
