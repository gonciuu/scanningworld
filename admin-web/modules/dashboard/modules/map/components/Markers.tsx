import { useRef } from 'react';

import { useQuery } from '@tanstack/react-query';
import axios from 'axios';
import L from 'leaflet';
import { Marker } from 'react-leaflet';

import { useActivePlace } from '@/modules/dashboard/recoil/activePlace';

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
  const { data, error, isLoading } = useQuery(['places'], () =>
    axios
      .get<Place[]>('places/63485005b9a6f084791d694a')
      .then((res) => res.data)
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
