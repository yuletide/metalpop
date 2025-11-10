'use client';

interface GenreFilterProps {
  selectedGenre: string;
  onGenreChange: (genre: string) => void;
}

const genres = [
  { id: 'all', name: 'All Metal' },
  { id: 'death', name: 'Death Metal' },
  { id: 'black', name: 'Black Metal' },
  { id: 'heavy', name: 'Heavy Metal' },
  { id: 'thrash', name: 'Thrash Metal' },
  { id: 'power', name: 'Power Metal' },
  { id: 'doom', name: 'Doom Metal' },
  { id: 'progressive', name: 'Progressive Metal' },
];

const GenreFilter: React.FC<GenreFilterProps> = ({ selectedGenre, onGenreChange }) => {
  return (
    <div className="absolute top-4 left-4 z-10">
      <div className="bg-white dark:bg-gray-800 rounded-lg shadow-lg p-4">
        <h3 className="text-lg font-bold mb-3 text-gray-900 dark:text-white">
          Filter by Genre
        </h3>
        <div className="space-y-2">
          {genres.map((genre) => (
            <label
              key={genre.id}
              className="flex items-center gap-2 cursor-pointer hover:bg-gray-100 dark:hover:bg-gray-700 p-2 rounded transition-colors"
            >
              <input
                type="radio"
                name="genre"
                value={genre.id}
                checked={selectedGenre === genre.id}
                onChange={(e) => onGenreChange(e.target.value)}
                className="w-4 h-4 text-blue-600 focus:ring-blue-500 dark:focus:ring-blue-600"
              />
              <span className="text-sm text-gray-900 dark:text-white">
                {genre.name}
              </span>
            </label>
          ))}
        </div>
        <div className="mt-4 pt-4 border-t border-gray-200 dark:border-gray-700">
          <p className="text-xs text-gray-500 dark:text-gray-400">
            Note: Genre-specific data layers require additional data processing.
            Currently showing all metal bands.
          </p>
        </div>
      </div>
    </div>
  );
};

export default GenreFilter;
