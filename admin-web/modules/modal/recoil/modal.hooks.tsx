import { useRecoilState } from 'recoil';

import { modalAtom } from './modal.atom';

const useModal = () => {
  const [modalSettings, setModal] = useRecoilState(modalAtom);

  const openModal = (
    modal: JSX.Element | JSX.Element[],
    {
      clickToClose,
      closeCallback,
    }: { clickToClose?: boolean; closeCallback?: () => void } = {
      clickToClose: true,
    }
  ) => setModal({ modal, opened: true, closeCallback, clickToClose });

  const closeModal = () => {
    if (modalSettings.closeCallback) modalSettings.closeCallback();
    setModal({ modal: <></>, opened: false });
  };

  return { openModal, closeModal, modalSettings, setModal };
};

export { useModal };
