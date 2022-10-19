import { useActivePlace } from '@/modules/dashboard/recoil/activePlace';

import { Place } from '../../map/types/place.type';

const PlaceComponent = (place: Place) => {
  const { setActivePlace } = useActivePlace();

  return (
    <div
      className="flex items-center gap-2"
      onClick={() => setActivePlace(place)}
    >
      <div className="h-10 w-10 rounded-full bg-gray-200" />
      <div className="flex-1">
        <div className="text-sm font-semibold">{place.name}</div>
        <div className="text-xs text-gray-500">
          {place.location.lat} \ {place.location.lng}
        </div>
      </div>
    </div>
  );
};

export default PlaceComponent;
