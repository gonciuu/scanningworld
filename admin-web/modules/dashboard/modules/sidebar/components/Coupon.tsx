import { Coupon } from '@/modules/dashboard/types/coupon.type';

const CouponComponent = (coupon: Coupon) => {
  const { name, imageUri, points } = coupon;

  return (
    <div className="h-full w-full border p-2 pt-4">
      <div className="h-12">
        <img src={imageUri} alt="Logo" />
      </div>

      <p className="text-center font-bold text-primary">{points} punktów</p>
      <p className="h-24 overflow-hidden text-ellipsis text-center">{name}</p>
      <button className="btn btn-primary w-full py-1 text-sm">Szczegóły</button>
    </div>
  );
};

export default CouponComponent;
