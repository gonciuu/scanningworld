import { useRef } from 'react';

import { useQuery } from '@tanstack/react-query';
import axios from 'axios';
import L from 'leaflet';
import { Marker } from 'react-leaflet';

import { useRegion } from '@/common/recoil/region';
import { useActivePlace } from '@/modules/dashboard/recoil/activePlace';
import { PlaceType } from '@/modules/dashboard/types/place.type';

const pointIcon = new L.Icon({
  iconUrl: '/images/marker-icon.svg',
  iconRetinaUrl: '/images/marker-icon.svg',
  popupAnchor: [0, -10],
  iconAnchor: [20, 40],
  iconSize: [40, 40],
  className:
    'focus:ring-0 focus:bg-black/50 hover:bg-black/50 active:bg-black/0',
});

const PlaceMarker = (place: PlaceType) => {
  const { setActivePlace } = useActivePlace();

  const markerRef = useRef<L.Marker<any>>(null);

  return (
    <Marker
      position={place.location}
      icon={pointIcon}
      ref={markerRef}
      // draggable
      eventHandlers={{
        click: () => {
          setActivePlace(place);
          // console.log(markerRef.current?.getLatLng());
        },
      }}
    />
  );
};

const Markers = () => {
  const {
    region: { _id },
  } = useRegion();

  const { data, error, isLoading } = useQuery(
    ['places', _id],
    () => axios.get<PlaceType[]>(`places/${_id}`).then((res) => res.data),
    { enabled: !!_id }
  );

  if (isLoading || error || !data) return null;

  return (
    <>
      {data.map((place) => (
        <PlaceMarker key={place._id} {...place} />
      ))}
    </>
  );
};

export default Markers;
