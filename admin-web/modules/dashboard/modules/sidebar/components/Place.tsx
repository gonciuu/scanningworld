import { useActivePlace } from '@/modules/dashboard/recoil/activePlace';
import { PlaceType } from '@/modules/dashboard/types/place.type';

const Place = (place: PlaceType) => {
  const { setActivePlace, activePlace } = useActivePlace();

  const { name, location, points, imageUri } = place;

  return (
    <div
      className={`flex gap-2 p-2 ${
        activePlace?._id === place._id && 'bg-primary/20'
      }`}
    >
      <img
        src={imageUri || 'images/placeholder.jpg'}
        alt={`Zdjęcie ${name}`}
        className="h-24 w-24 rounded-2xl object-cover"
      />

      <div className="flex flex-1 flex-col justify-between">
        <p className="w-60 overflow-hidden truncate font-semibold">
          {place.name}
        </p>

        <p className="text-xs font-semibold text-gray-500">
          {location.lat} \ {location.lng}
        </p>
        <p className="text-xs font-semibold">{points} punktów</p>

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

export default Place;
