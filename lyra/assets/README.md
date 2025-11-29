# Assets Directory Structure

Thư mục này chứa tất cả các assets (hình ảnh, logo, icon) cho ứng dụng Lyra Spotify Clone.

## Cấu trúc thư mục:

```
assets/
├── images/          # Hình ảnh album, nghệ sĩ, background
├── logos/           # Logo của ứng dụng và các brand
└── icons/           # Icons tùy chỉnh cho ứng dụng
```

## Hướng dẫn sử dụng:

### 1. Thêm hình ảnh:
- Copy các file hình ảnh vào thư mục tương ứng
- Supported formats: PNG, JPG, JPEG, GIF, WebP, SVG

### 2. Sử dụng trong code:

```dart
// Sử dụng hình ảnh
Image.asset('assets/images/album_cover.jpg')

// Sử dụng logo
Image.asset('assets/logos/lyra_logo.png')

// Sử dụng icon
Image.asset('assets/icons/play_button.png')
```

### 3. Gợi ý tên file:

**Images:**
- `album_covers/` - Ảnh bìa album
- `artist_photos/` - Ảnh nghệ sĩ
- `backgrounds/` - Ảnh nền
- `placeholders/` - Ảnh placeholder

**Logos:**
- `lyra_logo.png` - Logo chính của ứng dụng
- `lyra_logo_white.png` - Logo trắng
- `lyra_icon.png` - Icon ứng dụng

**Icons:**
- `play_button.png`
- `pause_button.png`
- `next_button.png`
- `previous_button.png`
- `heart_icon.png`
- `shuffle_icon.png`

### 4. Kích thước khuyến nghị:

- **Logo chính**: 512x512px
- **Album covers**: 300x300px
- **Artist photos**: 400x400px
- **Icons**: 24x24px, 48x48px (multiple sizes)

### 5. Lưu ý:
- Sau khi thêm assets mới, chạy `flutter pub get` để cập nhật
- Đặt tên file không có dấu cách, sử dụng underscore (_) thay vì space
- Sử dụng format PNG cho hình ảnh có transparency
- Sử dụng format JPG cho hình ảnh không có transparency (nhẹ hơn)