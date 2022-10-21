import { useChangePlaceLocation } from '@/modules/dashboard/recoil/placeLocation';

const SaveLocationControls = () => {
  const { placeLocation, saveLocation, cancelLocation } =
    useChangePlaceLocation();

  if (!placeLocation.active) return null;

  return (
    <div className="absolute left-10 top-1/2 z-10 flex w-36 -translate-y-1/2 flex-col gap-2 bg-white p-2">
      <button
        className="btn w-full bg-green-500"
        onClick={() => saveLocation()}
      >
        Zapisz
      </button>
      <button
        className="btn w-full bg-red-500"
        onClick={() => cancelLocation()}
      >
        Anuluj
      </button>
    </div>
  );
};

export default SaveLocationControls;
