import CouponIcon from '../icons/CouponIcon';
import PlaceIcon from '../icons/PlaceIcon';
import { MenuType } from '../types/menu.type';

const activeMenuStyle = 'stroke-primary text-black';
const inactiveMenuStyle = 'stroke-gray-500 text-gray-500';

const Menu = ({
  menuType,
  setMenuType,
}: {
  menuType: MenuType;
  setMenuType: (newMenuType: MenuType) => void;
}) => {
  return (
    <div className="flex w-full items-center justify-center gap-16 font-semibold">
      <button
        className={`flex items-center gap-2 p-2 text-lg hover:bg-gray-200 ${
          menuType === MenuType.PLACES ? activeMenuStyle : inactiveMenuStyle
        }`}
        onClick={() => setMenuType(MenuType.PLACES)}
      >
        <PlaceIcon />
        Lokalizacje
      </button>
      <button
        className={`flex items-center gap-2 p-2 text-lg hover:bg-gray-200 ${
          menuType === MenuType.COUPONS ? activeMenuStyle : inactiveMenuStyle
        }`}
        onClick={() => setMenuType(MenuType.COUPONS)}
      >
        <CouponIcon /> Kupony
      </button>
    </div>
  );
};

export default Menu;
