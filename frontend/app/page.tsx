'use client';

import { useState } from 'react';
import MetalMap from '@/components/MetalMap';
import GenreFilter from '@/components/GenreFilter';

export default function Home() {
  const [selectedGenre, setSelectedGenre] = useState('all');

  return (
    <main className="relative w-full h-screen overflow-hidden">
      <MetalMap selectedGenre={selectedGenre} />
      <GenreFilter selectedGenre={selectedGenre} onGenreChange={setSelectedGenre} />
      
      {/* Header */}
      <div className="absolute top-4 left-1/2 transform -translate-x-1/2 z-10">
        <div className="bg-white dark:bg-gray-800 rounded-lg shadow-lg px-6 py-3">
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white">
            MetalPop
          </h1>
          <p className="text-sm text-gray-600 dark:text-gray-300">
            Global Metal Band Distribution
          </p>
        </div>
      </div>
    </main>
  );
}
