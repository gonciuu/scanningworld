import { useState } from 'react';

import CouponList from './components/CouponList';
import Header from './components/Header';
import Menu from './components/Menu';
import PlaceList from './components/PlaceList';
import { MenuType } from './types/menu.type';

const Sidebar = () => {
  const [menuType, setMenuType] = useState<MenuType>(MenuType.PLACES);

  return (
    <div className="flex h-full w-full flex-col items-center gap-5 py-8">
      <Header />

      <div className="w-full px-12">
        <Menu
          menuType={menuType}
          setMenuType={(newMenuType: MenuType) => setMenuType(newMenuType)}
        />

        {menuType === MenuType.PLACES && <PlaceList />}
        {menuType === MenuType.COUPONS && <CouponList />}
      </div>
    </div>
  );
};

export default Sidebar;
