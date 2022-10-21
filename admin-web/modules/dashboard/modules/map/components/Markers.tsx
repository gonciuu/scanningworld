import { useEffect, useRef, useState } from 'react';

import { useQuery } from '@tanstack/react-query';
import axios from 'axios';
import L from 'leaflet';
import { Marker } from 'react-leaflet';

import { useRegion } from '@/common/recoil/region';
import { useActivePlace } from '@/modules/dashboard/recoil/activePlace';
import { useChangePlaceLocation } from '@/modules/dashboard/recoil/placeLocation';
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

const changeLocationIcon = new L.Icon({
  iconUrl: '/images/marker-icon.svg',
  iconRetinaUrl: '/images/marker-icon.svg',
  popupAnchor: [0, -10],
  iconAnchor: [20, 40],
  iconSize: [40, 40],
  className: 'bg-black/50 border-2 border-primary',
});

const ChangeLocationMarker = ({
  startLocation,
}: {
  startLocation: { lat: number; lng: number };
}) => {
  const { setLocation } = useChangePlaceLocation();

  const markerRef = useRef<L.Marker<any>>(null);

  useEffect(() => {
    if (markerRef.current) {
      setLocation(markerRef.current.getLatLng());
    }

    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [markerRef.current]);

  return (
    <Marker
      position={startLocation}
      icon={changeLocationIcon}
      ref={markerRef}
      draggable
      eventHandlers={{
        dragend: () => {
          const location = markerRef.current?.getLatLng();

          if (location) setLocation(location);
        },
      }}
    />
  );
};

const PlaceMarker = (place: PlaceType) => {
  const { setActivePlace } = useActivePlace();

  return (
    <Marker
      position={place.location}
      icon={pointIcon}
      eventHandlers={{
        click: () => {
          setActivePlace(place);
        },
      }}
    />
  );
};

const Markers = () => {
  const {
    region: { _id },
  } = useRegion();

  const { placeLocation } = useChangePlaceLocation();

  const [userLocation, setUserLocation] = useState<{
    lat: number;
    lng: number;
  }>({ lat: 52.24126, lng: 21.01135 });

  const { data, error, isLoading } = useQuery(
    ['places', _id],
    () => axios.get<PlaceType[]>(`places/${_id}`).then((res) => res.data),
    { enabled: !!_id }
  );

  useEffect(() => {
    navigator.geolocation.getCurrentPosition((position) => {
      setUserLocation({
        lat: position.coords.latitude,
        lng: position.coords.longitude,
      });
    });
  }, []);

  if (isLoading || error || !data) return null;

  const placeEditing = data.find((place) => place._id === placeLocation.id);

  return (
    <>
      {data.map((place) => {
        if (place._id === placeLocation.id) return null;

        return <PlaceMarker key={place._id} {...place} />;
      })}

      {placeLocation.active && (
        <ChangeLocationMarker
          startLocation={placeEditing?.location || userLocation}
        />
      )}
    </>
  );
};

export default Markers;
