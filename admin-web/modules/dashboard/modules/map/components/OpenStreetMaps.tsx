import { useEffect } from 'react';

import axios from 'axios';
import { MapContainer, TileLayer } from 'react-leaflet';

import 'leaflet/dist/leaflet.css';
import { usePlaces } from '../recoil';
import Markers from './Markers';
import PlacePopup from './PlacePopup';

const OpenStreetMaps = () => {
  const { setPlaces, setSelectedPlace } = usePlaces();

  useEffect(() => {
    axios
      .get('http://localhost:8080/places/63485005b9a6f084791d694a')
      .then((res) => {
        setPlaces(res.data);
      });

    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  return (
    <MapContainer
      center={{ lat: 49.96181, lng: 18.396556 }}
      zoom={13}
      scrollWheelZoom={true}
      className="h-full flex-1 rounded-l-[2.5rem] focus:ring-0"
      // @ts-ignore
      whenReady={(map: any) => {
        map.target.on('click', () => {
          setSelectedPlace(null);
        });
      }}
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
