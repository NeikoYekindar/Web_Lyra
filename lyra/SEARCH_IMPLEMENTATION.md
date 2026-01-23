# Search Implementation

## Files Modified/Created

### 1. Model Layer

- **`lib/models/search_response.dart`** (NEW)
  - `SearchTracksResponse`: Response wrapper cho track search
  - `SearchTrackHit`: Individual track result với fields: track_id, track_name, artist_name, streams, kind, lyrics

### 2. Service Layer

- **`lib/services/search_service_v2.dart`** (MODIFIED)
  - Added `searchTracksV2()`: Calls `/tracks/search/tracks?q={query}` endpoint
  - Added placeholder methods (not implemented yet):
    - `searchArtistsV2()`
    - `searchPlaylistsV2()`
    - `searchAlbumsV2()`

### 3. UI Layer

- **`lib/widgets/around widget/search_result_center.dart`** (MODIFIED)
  - Added state management for search results
  - Added `_performSearch()` method called on `initState`
  - Added loading, error, and success states
  - Displays API results in Songs section
  - Artists and Playlists sections still use mock data (endpoints not ready)

## API Endpoint

```
GET http://localhost:3000/tracks/search/tracks?q={query}
```

### Response Format

```json
{
  "query": "am tham ben em",
  "hits": [
    {
      "track_name": "...",
      "artist_name": "...",
      "lyrics": null,
      "track_id": "TRK...",
      "streams": 7892,
      "kind": "Indie / Rap"
    }
  ],
  "total": 4
}
```

## How It Works

1. User types search query in header and presses Enter or clicks search icon
2. `app_header.dart` calls `AppShellController.openSearch(query)`
3. Navigate to `/search` route → displays `SearchResultCenter`
4. `SearchResultCenter` calls API in `initState` via `searchTracksV2()`
5. Results displayed in Songs section with:
   - Track name
   - Artist name + Genre
   - Stream count

## Future Endpoints (Not Implemented)

These methods exist but throw `UnimplementedError`:

- `/artists/search/artists?q={query}` → `searchArtistsV2()`
- `/playlists/search/playlists?q={query}` → `searchPlaylistsV2()`
- `/albums/search/albums?q={query}` → `searchAlbumsV2()`

When ready, uncomment the sections in `search_result_center.dart` and implement the service methods.
