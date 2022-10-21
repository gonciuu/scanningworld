import { useEffect, useRef, useState } from 'react';

import { MapContainer, TileLayer } from 'react-leaflet';

import 'leaflet/dist/leaflet.css';
import { useActivePlace } from '@/modules/dashboard/recoil/activePlace';
import { useChangePlaceLocation } from '@/modules/dashboard/recoil/placeLocation';

import Markers from './Markers';
import PlacePopup from './PlacePopup';

const OpenStreetMaps = () => {
  const { setActivePlace } = useActivePlace();
  const { placeLocation } = useChangePlaceLocation();

  const [userLocation, setUserLocation] = useState<{
    lat: number;
    lng: number;
  }>({ lat: 52.24126, lng: 21.01135 });

  const mapRef = useRef<L.Map>(null);

  useEffect(() => {
    if (mapRef.current && placeLocation.active) {
      mapRef.current.setView(placeLocation);
    }
  }, [placeLocation.active, placeLocation]);

  useEffect(() => {
    navigator.geolocation.getCurrentPosition((position) => {
      setUserLocation({
        lat: position.coords.latitude,
        lng: position.coords.longitude,
      });
    });
  }, []);

  useEffect(() => {
    if (mapRef.current) {
      mapRef.current.setView(userLocation);
    }
  }, [userLocation]);

  return (
    <MapContainer
      center={userLocation}
      zoom={13}
      minZoom={6}
      scrollWheelZoom={true}
      className="z-0 h-full flex-1 rounded-l-[2.5rem] focus:ring-0"
      // @ts-ignore
      whenReady={(map: any) => {
        map.target.on('click', () => {
          setActivePlace(null);
        });
      }}
      ref={mapRef}
    >
      <TileLayer
        attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
      />

      <Markers />
      <PlacePopup />
    </MapContainer>
  );
};

export default OpenStreetMaps;
