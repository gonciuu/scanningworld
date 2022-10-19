export type Place = {
  _id: string;
  name: string;
  location: {
    lat: number;
    lng: number;
  };
  description: string;
  imageUri: string;
  points: number;
  code: string;
};
