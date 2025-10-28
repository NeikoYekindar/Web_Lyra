# Favorite Items Grid - Documentation

## 🎯 **Tính năng đã implement**

### ✅ **2x4 Grid Layout**
- **GridView.builder** với `crossAxisCount: 4` (4 cột)
- **Fixed height: 180px** để hiển thị đúng 2 hàng
- **Max 8 items** được hiển thị
- **Responsive spacing** 12px giữa các items

### ✅ **Dynamic Data Loading**
```dart
// API Structure
{
  'id': '1',
  'title': 'Thiền Hạ Nghe Gì',
  'subtitle': 'Daily Mix', 
  'image': 'assets/images/HTH.png',
  'type': 'playlist' // playlist, artist, radio, album
}
```

### ✅ **Interactive UI Elements**
- **Tap handling** với `_onFavoriteItemTapped()`
- **Loading state** với CircularProgressIndicator
- **Error handling** với fallback icon
- **Smooth animations** với AnimatedContainer
- **Box shadows** cho depth effect

## 🎨 **UI Design Specs**

### **Grid Configuration**
```dart
SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 4,           // 4 columns
  childAspectRatio: 1.0,       // Square items
  crossAxisSpacing: 12,        // Horizontal spacing  
  mainAxisSpacing: 12,         // Vertical spacing
)
```

### **Item Layout (Vertical)**
```
┌─────────────────┐
│                 │
│     Image       │ ← 60% height (flex: 3)
│   (Rounded)     │
├─────────────────┤
│     Title       │ ← 40% height (flex: 2)
│   Subtitle      │
└─────────────────┘
```

### **Colors & Styling**
- **Container:** `AppTheme.darkSurfaceButton`
- **Title:** White, 10px, w600
- **Subtitle:** Grey[400], 8px
- **Border radius:** 8px
- **Box shadow:** Black 0.2 opacity, 4px blur

## 🔧 **Customization Guide**

### **Change Grid Layout**
```dart
// 3 columns instead of 4
crossAxisCount: 3,

// 3 rows instead of 2  
height: 270, // Increase height

// Different aspect ratio
childAspectRatio: 0.8, // Taller items
```

### **Add More Items**
```dart
// Show 12 items (3 rows x 4 cols)
itemCount: _favoriteItems.length > 12 ? 12 : _favoriteItems.length,
height: 270, // Adjust height accordingly
```

### **Custom Item Actions**
```dart
void _onFavoriteItemTapped(Map<String, dynamic> item) {
  switch (item['type']) {
    case 'playlist':
      Navigator.push(context, PlaylistDetailPage(item['id']));
      break;
    case 'artist':
      Navigator.push(context, ArtistProfilePage(item['id'])); 
      break;
    case 'radio':
      _playRadioStation(item['id']);
      break;
  }
}
```

## 🌐 **API Integration**

### **Expected API Response Format**
```json
{
  "favorites": [
    {
      "id": "1",
      "title": "Thiền Hạ Nghe Gì",
      "subtitle": "Daily Mix",
      "image": "https://api.com/images/1.jpg",
      "type": "playlist",
      "playCount": 1234,
      "isLiked": true
    }
  ],
  "totalCount": 25,
  "hasMore": true
}
```

### **API Service Implementation**
```dart
// In CategoryService
static Future<List<Map<String, dynamic>>> getFavoriteItems({
  int limit = 8
}) async {
  final response = await http.get(
    Uri.parse('$baseUrl/favorites?limit=$limit'),
  );
  
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data['favorites']);
  }
  
  throw Exception('Failed to load favorites');
}
```

## 📱 **Responsive Behavior**

### **Small Screens (<350px width)**
```dart
crossAxisCount: 3, // Reduce to 3 columns
childAspectRatio: 0.9,
```

### **Large Screens (>500px width)**
```dart
crossAxisCount: 5, // Increase to 5 columns
itemCount: 10, // Show 10 items (2 rows)
```

### **Tablet/Desktop**
```dart
crossAxisCount: 6,
height: 200,
itemCount: 12, // 2 rows x 6 cols
```

## 🔄 **State Management**

### **Loading States**
1. `_isLoadingFavorites = true` → Show CircularProgressIndicator
2. API call complete → `_isLoadingFavorites = false`
3. Show grid with items or empty state

### **Error Handling**
```dart
catch (e) {
  setState(() {
    _favoriteItems = []; // Empty list
    _isLoadingFavorites = false;
  });
  // Show error message to user
}
```

## 🎵 **Content Types Supported**

| Type | Icon | Action | Description |
|------|------|---------|------------|
| `playlist` | 🎵 | Open playlist | User curated playlists |
| `artist` | 👤 | Open profile | Artist pages |
| `radio` | 📻 | Start playing | Radio stations |
| `album` | 💿 | Open album | Music albums |
| `podcast` | 🎙️ | Play episode | Podcast shows |

## ⚡ **Performance Tips**

1. **Image Caching:** Use `CachedNetworkImage` for network images
2. **Lazy Loading:** Only load visible items
3. **Preloading:** Preload next batch when scrolling near end
4. **Memory:** Dispose unused image resources

## 🔮 **Future Enhancements**

- [ ] Pull-to-refresh functionality
- [ ] Add/remove from favorites
- [ ] Drag to reorder items
- [ ] View more button (show all favorites)
- [ ] Category filtering within favorites
- [ ] Search within favorites
- [ ] Recently played section
- [ ] Infinite scroll for more items