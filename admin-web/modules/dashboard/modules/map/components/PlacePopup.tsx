import { AiOutlineClose } from 'react-icons/ai';
import { Popup } from 'react-leaflet';

import { useActivePlace } from '@/modules/dashboard/recoil/activePlace';

const PlacePopup = () => {
  const { activePlace, setActivePlace } = useActivePlace();

  if (!activePlace) return null;

  const { location, name, description, points } = activePlace;

  return (
    <Popup
      position={location}
      offset={[0, -25]}
      closeButton={false}
      closeOnClick={false}
    >
      <div className="relative h-full">
        <div className="mb-5 flex items-center justify-between">
          <h1 className="text-xl font-bold">{name}</h1>
          <button
            className="btn absolute -right-4 text-xl hover:bg-zinc-200"
            onClick={() => setActivePlace(null)}
          >
            <AiOutlineClose />
          </button>
        </div>

        <div className="flex gap-5">
          <div className="h-48 w-48">
            <img
              src="/images/popupImage.png"
              alt="olza"
              className="h-48 w-48 rounded-2xl"
            />

            <button className="btn mt-3 w-full bg-black text-white hover:bg-black/80 active:bg-black">
              Pokaż kod QR
            </button>
          </div>

          <div className="flex h-48 flex-1 flex-col justify-between">
            <p className="flex-1 text-justify text-[.9rem] leading-6">
              {description}
            </p>

            <div className="mt-4 flex items-center justify-between">
              <p className="text-lg font-bold text-primary">
                {location.lat} / {location.lng}
              </p>
              <p className="text-center text-lg font-bold">{points} punktów</p>
            </div>
          </div>
        </div>

        <div className="absolute bottom-0 flex w-full justify-end gap-5">
          <button className="btn btn-secondary">Edytuj informacje</button>
          <button className="btn btn-primary">Zmień położenie</button>
        </div>
      </div>
    </Popup>
  );
};

export default PlacePopup;
