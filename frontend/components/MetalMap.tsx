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

  const rawMapboxToken = process.env.NEXT_PUBLIC_MAPBOX_TOKEN;
  if (!rawMapboxToken) {
    // Warn when Mapbox access token is not configured; the map will fail to load without it.
    console.warn(
      'MetalMap: Environment variable NEXT_PUBLIC_MAPBOX_TOKEN is not set. The Mapbox map may fail to load.'
    );
  }
  const mapboxToken = rawMapboxToken || '';
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
      'fill-outline-color': 'rgba(255,255,255,0.15)'
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

      {/* Region info panel */}
      {selectedRegion && (
        <div className="absolute top-16 right-4 glass-panel rounded-xl w-72 overflow-hidden z-10">
          {/* Header band */}
          <div className="bg-accent/20 border-b border-accent/30 px-5 py-3 flex items-start justify-between">
            <div>
              <h2 className="font-display text-lg font-bold text-white tracking-wide">
                {selectedRegion.name}
              </h2>
              <p className="text-xs text-neutral-400">
                {selectedRegion.admin} · {selectedRegion.iso_a2}
              </p>
            </div>
            <button
              onClick={() => setSelectedRegion(null)}
              className="text-neutral-500 hover:text-white transition-colors mt-0.5 cursor-pointer"
              aria-label="Close"
            >
              <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
                <path strokeLinecap="round" strokeLinejoin="round" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
          {/* Stats grid */}
          <div className="grid grid-cols-2 gap-px bg-white/5">
            <div className="px-4 py-3 bg-neutral-950">
              <p className="text-[10px] uppercase tracking-wider text-neutral-500">Bands</p>
              <p className="text-lg font-semibold text-white">{selectedRegion.bands_count.toLocaleString()}</p>
            </div>
            <div className="px-4 py-3 bg-neutral-950">
              <p className="text-[10px] uppercase tracking-wider text-neutral-500">Per 100k</p>
              <p className="text-lg font-semibold text-accent">{selectedRegion.bands_p100.toFixed(2)}</p>
            </div>
            <div className="px-4 py-3 bg-neutral-950">
              <p className="text-[10px] uppercase tracking-wider text-neutral-500">Population</p>
              <p className="text-sm font-medium text-neutral-200">{selectedRegion.population.toLocaleString()}</p>
            </div>
            <div className="px-4 py-3 bg-neutral-950">
              <p className="text-[10px] uppercase tracking-wider text-neutral-500">Area</p>
              <p className="text-sm font-medium text-neutral-200">{selectedRegion.area_km.toLocaleString()} km²</p>
            </div>
          </div>
        </div>
      )}

      {/* Legend */}
      <div className="absolute bottom-6 left-4 glass-panel rounded-xl px-4 py-3 z-10">
        <p className="text-[10px] uppercase tracking-widest text-neutral-500 mb-2">Bands / 100k people</p>
        <div className="flex items-center gap-1">
          <div className="h-2.5 w-10 rounded-sm" style={{ backgroundColor: '#440154' }} />
          <div className="h-2.5 w-10 rounded-sm" style={{ backgroundColor: '#31688e' }} />
          <div className="h-2.5 w-10 rounded-sm" style={{ backgroundColor: '#35b779' }} />
          <div className="h-2.5 w-10 rounded-sm" style={{ backgroundColor: '#fde724' }} />
        </div>
        <div className="flex justify-between mt-1">
          <span className="text-[10px] text-neutral-500">0</span>
          <span className="text-[10px] text-neutral-500">10</span>
          <span className="text-[10px] text-neutral-500">20</span>
          <span className="text-[10px] text-neutral-500">50+</span>
        </div>
      </div>
    </div>
  );
};

export default MetalMap;
