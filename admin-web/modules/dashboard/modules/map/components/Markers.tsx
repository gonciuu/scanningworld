import L from 'leaflet';
import { Marker } from 'react-leaflet';

import { usePlaces } from '../recoil';
import { Place } from '../types/place.type';

const pointIcon = new L.Icon({
  iconUrl: '/images/marker-icon.svg',
  iconRetinaUrl: '/images/marker-icon.svg',
  popupAnchor: [0, -10],
  iconAnchor: [20, 40],
  iconSize: [40, 40],
  className:
    'focus:ring-0 focus:bg-black/50 hover:bg-black/50 active:bg-black/0',
});

const PlaceMarker = (place: Place) => {
  const { setSelectedPlace } = usePlaces();

  return (
    <Marker
      position={place.location}
      icon={pointIcon}
      eventHandlers={{
        click: () => setSelectedPlace(place),
      }}
    />
  );
};

const Markers = () => {
  const { places } = usePlaces();

  return (
    <>
      {places.map((place) => (
        <PlaceMarker key={place._id} {...place} />
      ))}
    </>
  );
};

export default Markers;
