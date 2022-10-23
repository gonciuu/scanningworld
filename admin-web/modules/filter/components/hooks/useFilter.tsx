import { useState } from 'react';

import { Sort } from '../../types.ts/filter.type';
import Filter from '../Filter';

export const useFilter = () => {
  const [search, setSearch] = useState('');
  const [sort, setSort] = useState<Sort>(Sort.NAME_ASC);

  const [isFilterOpen, setIsFilterOpen] = useState(false);

  return {
    Filter: (
      <Filter
        search={search}
        setSearch={setSearch}
        sort={sort}
        setSort={setSort}
        isOpened={isFilterOpen}
        setIsOpened={setIsFilterOpen}
      />
    ),
    search,
    sort,
    openFilter: () => setIsFilterOpen(true),
  };
};
