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

const QRCodeModal = ({ code, name }: { code: string; name: string }) => {
  const qrRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (qrRef.current) {
      qrCode.update({
        data: code,
      });
      qrCode.append(qrRef.current);
    }
  }, [code]);

  return (
    <div>
      <h1 className="text-center text-lg font-semibold">Kod QR</h1>
      <div ref={qrRef} />
      <button
        className="btn btn-primary mt-3 w-full bg-black hover:bg-black/80"
        onClick={() =>
          qrCode.download({
            extension: 'png',
            name: `${name}-qrCode`,
          })
        }
      >
        Pobierz kod
      </button>
    </div>
  );
};

export default QRCodeModal;
