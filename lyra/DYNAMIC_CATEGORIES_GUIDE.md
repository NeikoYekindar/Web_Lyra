# Dynamic Category Buttons - Hướng dẫn sử dụng

## 🎯 Tính năng đã implement

### ✅ **Dynamic Category List**
- Danh sách categories được tải từ API
- Loading state với CircularProgressIndicator
- Fallback data khi API lỗi
- Auto-retry và error handling

### ✅ **Interactive Buttons**
- Selected state với visual feedback
- Dynamic width dựa trên độ dài text
- Smooth animations và elevation changes
- Horizontal scrolling support

### ✅ **State Management**
- Selected category tracking
- Loading states
- Error handling
- Reactive UI updates

## 🚀 Cách sử dụng API thực

### **Bước 1: Cài đặt dependencies**
Thêm vào `pubspec.yaml`:
```yaml
dependencies:
  http: ^1.1.0
```

### **Bước 2: Setup API Service**
```dart
// Trong home_center.dart
import 'package:lyra/services/category_service.dart';

// Trong _loadCategories method:
final List<String> apiResponse = await CategoryService.getCategories();
```

### **Bước 3: Cấu hình API endpoint**
```dart
// Trong category_service.dart
static const String baseUrl = 'https://your-actual-api.com/api';
```

### **Bước 4: Customize API response format**
Nếu API của bạn trả về format khác, update trong `CategoryService.getCategories()`:
```dart
// Ví dụ nếu API trả về: {"data": {"items": ["All", "Music"]}}
final List<dynamic> categoriesJson = jsonResponse['data']['items'];
```

## 📱 UI Features

### **Loading State**
```dart
_isLoadingCategories 
  ? CircularProgressIndicator() 
  : ListView.separated(...)
```

### **Selected State**
- Background color changes
- Text weight changes to bold
- Elevation increases
- Smooth color transitions

### **Responsive Design**
- Dynamic button width: `text.length * 10.0 + 20`
- Horizontal scrolling for many categories
- Proper spacing with separators

## 🔧 Customization Options

### **Colors**
```dart
// Selected button
backgroundColor: Theme.of(context).colorScheme.onBackground,
foregroundColor: Theme.of(context).colorScheme.background,

// Unselected button  
backgroundColor: AppTheme.darkSurfaceButton,
foregroundColor: Theme.of(context).colorScheme.onBackground,
```

### **Button Styling**
```dart
// Shape
shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(15),
),

// Elevation
elevation: isSelected ? 3 : 1,

// Size
minimumSize: Size(dynamicWidth, 40),
```

### **Animation**
```dart
// Để thêm animation smooth hơn
AnimatedContainer(
  duration: Duration(milliseconds: 200),
  // ... properties
)
```

## 🌐 API Integration Examples

### **Example 1: Simple Categories**
```json
{
  "categories": ["All", "Music", "Podcasts", "Audiobooks"]
}
```

### **Example 2: Rich Category Objects**
```json
{
  "data": [
    {
      "id": "1",
      "name": "Music",
      "icon": "music_note",
      "count": 1234
    },
    {
      "id": "2", 
      "name": "Podcasts",
      "icon": "podcast",
      "count": 567
    }
  ]
}
```

### **Example 3: Nested Categories**
```json
{
  "categories": {
    "main": ["All", "Music", "Podcasts"],
    "music": ["Rock", "Pop", "Jazz"],
    "podcasts": ["Tech", "News", "Comedy"]
  }
}
```

## 🔄 State Flow

```
1. initState() → _loadCategories()
2. API Call → Update _categories list
3. User tap button → _onCategorySelected(index)
4. Update _selectedCategoryIndex → _loadContentByCategory()
5. API Call for content → Update content list
6. setState() → UI rebuild
```

## 🐛 Error Handling

### **Network Errors**
```dart
catch (e) {
  // Show fallback data
  _categories = ['All', 'Music', 'Podcasts'];
  // Log error
  print('API Error: $e');
  // Show snackbar to user (optional)
}
```

### **Parsing Errors**
```dart
// Safe casting
final List<dynamic> raw = jsonResponse['categories'] ?? [];
final List<String> categories = raw.cast<String>();
```

## 📋 TODO / Enhancements

- [ ] Add pull-to-refresh
- [ ] Implement caching with SharedPreferences
- [ ] Add category icons
- [ ] Implement nested categories
- [ ] Add search functionality
- [ ] Loading shimmer effect
- [ ] Offline mode support
- [ ] Category count badges