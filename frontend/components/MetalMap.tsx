'use client';

import { useState, useCallback } from 'react';
import Map, { Source, Layer, MapLayerMouseEvent } from 'react-map-gl';
import type { LayerProps } from 'react-map-gl';
import 'mapbox-gl/dist/mapbox-gl.css';

interface RegionData {
  name: string;
  admin: string;
  iso_a2: string;
  iso_3166_2: string;
  bands_count: number;
  bands_p100: number;
  population: number;
  area_km: number;
}

interface MetalMapProps {
  selectedGenre: string;
}

// eslint-disable-next-line @typescript-eslint/no-unused-vars
const MetalMap: React.FC<MetalMapProps> = ({ selectedGenre }) => {
  // Note: selectedGenre will be used for genre-specific data layers once available
  const [viewState, setViewState] = useState({
    longitude: 0,
    latitude: 30,
    zoom: 2
  });
  const [selectedRegion, setSelectedRegion] = useState<RegionData | null>(null);

  const mapboxToken = process.env.NEXT_PUBLIC_MAPBOX_TOKEN || '';
  const mapboxStyle = process.env.NEXT_PUBLIC_MAPBOX_STYLE || 'mapbox://styles/mapbox/dark-v11';
  const mapboxUser = process.env.NEXT_PUBLIC_MAPBOX_USER || 'yuletide';

  // Layer styling for the choropleth map
  const dataLayer: LayerProps = {
    id: 'bands-data',
    type: 'fill',
    paint: {
      'fill-color': [
        'interpolate',
        ['linear'],
        ['get', 'bands_p100'],
        0, '#440154',
        10, '#31688e',
        20, '#35b779',
        50, '#fde724'
      ],
      'fill-opacity': 0.7,
      'fill-outline-color': '#ffffff'
    }
  };

  const handleClick = useCallback((event: MapLayerMouseEvent) => {
    const feature = event.features?.[0];
    if (feature && feature.properties) {
      const props = feature.properties;
      setSelectedRegion({
        name: props.name || 'Unknown',
        admin: props.admin || 'Unknown',
        iso_a2: props.iso_a2 || '',
        iso_3166_2: props.iso_3166_2 || '',
        bands_count: props.bands_coun || 0,
        bands_p100: props.bands_p100 || 0,
        population: props.UN_2020_E || 0,
        area_km: props.TOTAL_A_KM || 0
      });
    }
  }, []);

  return (
    <div className="relative w-full h-screen">
      <Map
        {...viewState}
        onMove={evt => setViewState(evt.viewState)}
        mapboxAccessToken={mapboxToken}
        mapStyle={mapboxStyle}
        interactiveLayerIds={['bands-data']}
        onClick={handleClick}
      >
        {/* Add tileset source - this will use the pre-processed Mapbox tileset */}
        <Source
          id="bands-source"
          type="vector"
          url={`mapbox://${mapboxUser}.ne_bands_percapita`}
        >
          <Layer {...dataLayer} source-layer="bands_per_capita" />
        </Source>
      </Map>

      {/* Sidebar for region info */}
      {selectedRegion && (
        <div className="absolute top-4 right-4 bg-white dark:bg-gray-800 p-6 rounded-lg shadow-lg w-80 max-h-[80vh] overflow-y-auto">
          <button
            onClick={() => setSelectedRegion(null)}
            className="absolute top-2 right-2 text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200"
            aria-label="Close"
          >
            ✕
          </button>
          <h2 className="text-2xl font-bold mb-4 text-gray-900 dark:text-white">
            {selectedRegion.name}
          </h2>
          <div className="space-y-3 text-sm">
            <div>
              <p className="text-gray-500 dark:text-gray-400">Country</p>
              <p className="font-semibold text-gray-900 dark:text-white">
                {selectedRegion.admin} ({selectedRegion.iso_a2})
              </p>
            </div>
            <div>
              <p className="text-gray-500 dark:text-gray-400">ISO Code</p>
              <p className="font-semibold text-gray-900 dark:text-white">
                {selectedRegion.iso_3166_2 || 'N/A'}
              </p>
            </div>
            <div>
              <p className="text-gray-500 dark:text-gray-400">Metal Bands</p>
              <p className="font-semibold text-gray-900 dark:text-white">
                {selectedRegion.bands_count.toLocaleString()}
              </p>
            </div>
            <div>
              <p className="text-gray-500 dark:text-gray-400">Bands per 100k people</p>
              <p className="font-semibold text-gray-900 dark:text-white">
                {selectedRegion.bands_p100.toFixed(2)}
              </p>
            </div>
            <div>
              <p className="text-gray-500 dark:text-gray-400">Population (2020)</p>
              <p className="font-semibold text-gray-900 dark:text-white">
                {selectedRegion.population.toLocaleString()}
              </p>
            </div>
            <div>
              <p className="text-gray-500 dark:text-gray-400">Area</p>
              <p className="font-semibold text-gray-900 dark:text-white">
                {selectedRegion.area_km.toLocaleString()} km²
              </p>
            </div>
          </div>
        </div>
      )}

      {/* Legend */}
      <div className="absolute bottom-8 left-4 bg-white dark:bg-gray-800 p-4 rounded-lg shadow-lg">
        <h3 className="text-sm font-bold mb-2 text-gray-900 dark:text-white">
          Metal Bands per 100k people
        </h3>
        <div className="space-y-1">
          <div className="flex items-center gap-2">
            <div className="w-8 h-4" style={{ backgroundColor: '#fde724' }}></div>
            <span className="text-xs text-gray-700 dark:text-gray-300">50+</span>
          </div>
          <div className="flex items-center gap-2">
            <div className="w-8 h-4" style={{ backgroundColor: '#35b779' }}></div>
            <span className="text-xs text-gray-700 dark:text-gray-300">20-50</span>
          </div>
          <div className="flex items-center gap-2">
            <div className="w-8 h-4" style={{ backgroundColor: '#31688e' }}></div>
            <span className="text-xs text-gray-700 dark:text-gray-300">10-20</span>
          </div>
          <div className="flex items-center gap-2">
            <div className="w-8 h-4" style={{ backgroundColor: '#440154' }}></div>
            <span className="text-xs text-gray-700 dark:text-gray-300">0-10</span>
          </div>
        </div>
      </div>
    </div>
  );
};

export default MetalMap;
