import { useModal } from '@/modules/modal';

import LoginModal from '../modals/LoginModal';

const LoginButton = () => {
  const { openModal } = useModal();

  const handleOpenRegisterModal = () => {
    openModal(<LoginModal />);
  };

  return (
    <button
      onClick={handleOpenRegisterModal}
      className="btn btn-secondary absolute top-5 right-5"
    >
      Zaloguj się
    </button>
  );
};

export default LoginButton;
