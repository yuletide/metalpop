'use client';

import { useState } from 'react';

interface GenreFilterProps {
  selectedGenre: string;
  onGenreChange: (genre: string) => void;
}

const genres = [
  { id: 'all', name: 'All Genres' },
  { id: 'death', name: 'Death' },
  { id: 'black', name: 'Black' },
  { id: 'heavy', name: 'Heavy' },
  { id: 'thrash', name: 'Thrash' },
  { id: 'power', name: 'Power' },
  { id: 'doom', name: 'Doom' },
  { id: 'progressive', name: 'Progressive' },
];

const GenreFilter: React.FC<GenreFilterProps> = ({ selectedGenre, onGenreChange }) => {
  const [open, setOpen] = useState(false);
  const currentLabel = genres.find(g => g.id === selectedGenre)?.name ?? 'All Genres';

  return (
    <div className="absolute top-4 right-4 z-20">
      {/* Toggle button */}
      <button
        onClick={() => setOpen(!open)}
        className="glass-panel rounded-xl px-4 py-2.5 flex items-center gap-2 hover:bg-white/10 transition-colors cursor-pointer"
      >
        <span className="text-xs font-medium uppercase tracking-wider text-neutral-300">Genre</span>
        <span className="text-xs font-semibold text-accent">{currentLabel}</span>
        <svg
          className={`w-3 h-3 text-neutral-400 transition-transform ${open ? 'rotate-180' : ''}`}
          fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}
        >
          <path strokeLinecap="round" strokeLinejoin="round" d="M19 9l-7 7-7-7" />
        </svg>
      </button>

      {/* Dropdown */}
      {open && (
        <div className="glass-panel rounded-lg mt-1.5 p-1 w-32">
          {genres.map((genre) => (
            <button
              key={genre.id}
              onClick={() => { onGenreChange(genre.id); setOpen(false); }}
              className={`w-full text-left px-2.5 py-1.5 rounded text-sm transition-colors cursor-pointer ${
                selectedGenre === genre.id
                  ? 'bg-accent/20 text-accent font-medium'
                  : 'text-neutral-300 hover:bg-white/5 hover:text-white'
              }`}
            >
              {genre.name}
            </button>
          ))}
        </div>
      )}
    </div>
  );
};

export default GenreFilter;
