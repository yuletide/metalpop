'use client';

import { useState } from 'react';
import MetalMap from '@/components/MetalMap';
import GenreFilter from '@/components/GenreFilter';

export default function Home() {
  const [selectedGenre, setSelectedGenre] = useState('all');

  return (
    <main className="relative w-full h-screen overflow-hidden bg-black">
      <MetalMap selectedGenre={selectedGenre} />

      {/* Header */}
      <div className="absolute top-4 left-4 z-20 flex items-center gap-4">
        <div className="glass-panel rounded-xl px-5 py-3">
          <h1 className="font-display text-2xl font-bold tracking-wider text-white uppercase">
            Metal<span className="text-accent">Pop</span>
          </h1>
          <p className="text-[11px] tracking-widest uppercase text-neutral-400">
            Global Band Density
          </p>
        </div>
      </div>

      {/* Genre filter - top right */}
      <GenreFilter selectedGenre={selectedGenre} onGenreChange={setSelectedGenre} />
    </main>
  );
}
