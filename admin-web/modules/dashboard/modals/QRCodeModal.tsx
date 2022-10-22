import { useEffect, useRef } from 'react';

import QRCodeStyling from 'qr-code-styling';

const qrCode = new QRCodeStyling({
  width: 300,
  height: 300,
  image: 'images/logo.svg',
  dotsOptions: {
    color: '#31B46D',
    type: 'rounded',
  },
  imageOptions: {
    crossOrigin: 'anonymous',
    margin: 0,
  },
});

const QRCodeModal = ({ code }: { code: string }) => {
  const qrRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (qrRef.current) {
      console.log(code);
      qrCode.update({
        data: code,
      });
      qrCode.append(qrRef.current);
    }
  }, [code]);

  return (
    <div>
      <div ref={qrRef}></div>
    </div>
  );
};

export default QRCodeModal;
