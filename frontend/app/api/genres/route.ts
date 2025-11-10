import { NextResponse } from 'next/server';

export async function GET() {
  // Return available genres
  // In the future, this could be dynamically loaded from the database
  return NextResponse.json({
    genres: [
      { id: 'all', name: 'All Metal', available: true },
      { id: 'death', name: 'Death Metal', available: false },
      { id: 'black', name: 'Black Metal', available: false },
      { id: 'heavy', name: 'Heavy Metal', available: false },
      { id: 'thrash', name: 'Thrash Metal', available: false },
      { id: 'power', name: 'Power Metal', available: false },
      { id: 'doom', name: 'Doom Metal', available: false },
      { id: 'progressive', name: 'Progressive Metal', available: false },
    ],
    message: 'Genre-specific data layers need to be created in the data processing pipeline'
  });
}
