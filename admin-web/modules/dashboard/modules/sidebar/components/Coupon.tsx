import Image from 'next/image';

import CouponModal from '@/modules/dashboard/modals/CouponModal';
import { CouponType } from '@/modules/dashboard/types/coupon.type';
import { useModal } from '@/modules/modal';

const Coupon = (coupon: CouponType) => {
  const { name, imageUri, points } = coupon;

  const { openModal } = useModal();

  return (
    <div className="h-max w-full border p-2 pt-4">
      <div className="relative h-12">
        <Image
          src={imageUri}
          alt="Logo"
          layout="fill"
          objectFit="cover"
          placeholder="blur"
          blurDataURL="images/logo.svg"
        />
      </div>

      <p className="text-center font-bold text-primary">{points} punktów</p>
      <p className="mb-2 h-[4.5rem] overflow-hidden text-ellipsis text-center">
        {name}
      </p>
      <button
        className="btn btn-primary w-full py-1 text-sm"
        onClick={() =>
          openModal(<CouponModal coupon={coupon} couponId={coupon._id} />)
        }
      >
        Edytuj
      </button>
    </div>
  );
};

export default Coupon;
