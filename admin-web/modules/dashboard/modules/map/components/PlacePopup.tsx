import { AiOutlineClose } from 'react-icons/ai';
import { Popup } from 'react-leaflet';

import { usePlaces } from '../recoil';

const PlacePopup = () => {
  const { selectedPlace, setSelectedPlace } = usePlaces();

  if (!selectedPlace) return null;

  const { location, name, description, points } = selectedPlace;

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
            className="btn text-xl hover:bg-zinc-200"
            onClick={() => setSelectedPlace(null)}
          >
            <AiOutlineClose />
          </button>
        </div>

        <div className="flex gap-5">
          <img
            src="/images/popupImage.png"
            alt="olza"
            className="h-48 w-48 rounded-2xl"
          />

          <p className="h-48 flex-1 text-justify text-[.9rem] leading-6">
            {description}
          </p>
        </div>

        <div className="flex justify-between gap-5">
          <button className="btn mt-3 w-48 bg-black text-white hover:bg-black/80 active:bg-black">
            Pokaż kod QR
          </button>

          <div className="mt-4 flex flex-1 items-center justify-between">
            <p className="text-lg font-bold text-primary">
              {location.lat} / {location.lng}
            </p>
            <p className="text-lg font-bold">{points} punktów</p>
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
