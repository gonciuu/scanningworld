import { MapContainer, TileLayer } from 'react-leaflet';

import 'leaflet/dist/leaflet.css';

const Map = () => {
  return (
    <MapContainer
      center={{ lat: 49.96181, lng: 18.396556 }}
      zoom={13}
      scrollWheelZoom={true}
      className="h-full flex-1 rounded-l-[2.5rem] focus:ring-0"
    >
      <TileLayer
        attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
      />
    </MapContainer>
  );
};

export default Map;
