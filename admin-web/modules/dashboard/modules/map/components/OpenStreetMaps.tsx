import { MapContainer, TileLayer } from 'react-leaflet';

import 'leaflet/dist/leaflet.css';
import { useActivePlace } from '@/modules/dashboard/recoil/activePlace';

import Markers from './Markers';
import PlacePopup from './PlacePopup';

const OpenStreetMaps = () => {
  const { setActivePlace } = useActivePlace();

  return (
    <MapContainer
      center={{ lat: 49.96181, lng: 18.396556 }}
      zoom={13}
      minZoom={8}
      scrollWheelZoom={true}
      className="h-full flex-1 rounded-l-[2.5rem] focus:ring-0"
      // @ts-ignore
      whenReady={(map: any) => {
        map.target.on('click', () => {
          setActivePlace(null);
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
