import { Coupon } from '@/modules/dashboard/types/coupon.type';

const CouponComponent = (coupon: Coupon) => {
  const { name, imageUri, points } = coupon;

  return (
    <div className="h-full w-full">
      <img src={imageUri} alt={`Zdjęcie ${name}`} />
      <p className="text-center font-bold text-primary">{points} punktów</p>
      <p className="text-center">{name}</p>
      <button className="btn btn-primary w-full py-1 text-sm">Szczegóły</button>
    </div>
  );
};

export default CouponComponent;
