import { useActivePlace } from '@/modules/dashboard/recoil/activePlace';

import { Place } from '../../map/types/place.type';

const PlaceComponent = (place: Place) => {
  const { setActivePlace } = useActivePlace();

  const { name, location, points } = place;

  return (
    <div className="flex gap-2">
      <img
        src="images/popupImage.png"
        alt={`Zdjęcie ${name}`}
        className="h-24 w-24 rounded-2xl"
      />

      <div className="flex flex-1 flex-col justify-between">
        <p className="w-72 overflow-hidden truncate font-semibold">
          {place.name}
        </p>

        <p className="text-xs text-gray-500">
          {location.lat} \ {location.lng}
        </p>
        <p className="text-xs">{points} punktów</p>

        <button
          className="btn btn-primary w-min py-1 px-3 text-sm"
          onClick={() => setActivePlace(place)}
        >
          Szczegóły
        </button>
      </div>
    </div>
  );
};

export default PlaceComponent;
