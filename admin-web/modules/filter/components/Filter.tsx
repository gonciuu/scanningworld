import { Dispatch, SetStateAction, useRef } from 'react';

import { useClickAway } from 'react-use';

import { Sort } from '../types.ts/filter.type';

interface Props {
  search: string;
  setSearch: Dispatch<SetStateAction<string>>;
  sort: Sort;
  setSort: Dispatch<SetStateAction<Sort>>;
  isOpened: boolean;
  setIsOpened: Dispatch<SetStateAction<boolean>>;
}

const Filter = ({
  search,
  setSearch,
  isOpened,
  setIsOpened,
  sort,
  setSort,
}: Props) => {
  const ref = useRef<HTMLDivElement>(null);

  useClickAway(ref, () => setIsOpened(false));

  if (!isOpened) return null;

  return (
    <div
      className="absolute top-full left-0 z-30 mt-2 flex h-max w-80 flex-col gap-3 bg-white p-5 shadow-xl"
      ref={ref}
    >
      <label>
        <p className="font-semibold">Szukaj</p>
        <input
          type="text"
          placeholder="Wpisz wyszukiwaną frazę..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
        />
      </label>

      <label>
        <p className="font-semibold">Sortuj</p>
        <select value={sort} onChange={(e) => setSort(e.target.value as Sort)}>
          {Object.values(Sort).map((sortArr) => (
            <option key={sortArr} value={sortArr}>
              {sortArr}
            </option>
          ))}
        </select>
      </label>

      <div className="flex w-full gap-5">
        <button
          className="btn btn-secondary w-full"
          onClick={() => {
            setSearch('');
            setSort(Sort.NAME_ASC);
          }}
        >
          Wyczyść
        </button>
        <button
          className="btn btn-primary w-full"
          onClick={() => setIsOpened(false)}
        >
          Zatwierdź
        </button>
      </div>
    </div>
  );
};

export default Filter;
