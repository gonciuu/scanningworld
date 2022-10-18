import { useState } from 'react';

import Header from './components/Header';
import Menu from './components/Menu';
import { MenuType } from './types/menu.type';

const Sidebar = () => {
  const [menuType, setMenuType] = useState<MenuType>(MenuType.PLACES);

  return (
    <div className="flex h-full w-full flex-col gap-5 py-8">
      <Header />
      <Menu
        menuType={menuType}
        setMenuType={(newMenuType: MenuType) => setMenuType(newMenuType)}
      />
    </div>
  );
};

export default Sidebar;
