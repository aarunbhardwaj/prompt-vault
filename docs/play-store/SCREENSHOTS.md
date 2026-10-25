# Phone screenshots (Play Store)

## Requirements

- **Count:** 4–8 phone screenshots (JPEG or 24-bit PNG, no alpha).
- **Aspect:** 16:9 or 9:16; min long edge often **1080 px** (check Console for current rules).
- **Content:** No misleading UI; show real app screens.

## Suggested set (6)

1. **Library** — list with starter prompts visible  
2. **Search** — query with results  
3. **Favorites** — filtered list  
4. **Editor** — template with `{{variables}}` in body  
5. **Editor** — variable chips row  
6. **Runner** — filled fields + preview + Copy  

## Capture on emulator

```bash
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

# Boot PromptVault_API34 or your device, run the app:
cd /path/to/prompt-vault
flutter run -d emulator-5554

# Navigate to each screen, then:
adb exec-out screencap -p > assets/store/screenshots/01-library.png
```

Repeat for each screen. Crop status bar if desired (optional).

## Capture on physical device

Enable USB debugging, run `flutter run`, use **adb exec-out screencap** as above or the device screenshot shortcut, then pull files:

```bash
adb pull /sdcard/Download/screenshot.png assets/store/screenshots/
```

## Feature graphic

- **Size:** 1024 × 500 px  
- **Format:** JPEG or 24-bit PNG  
- **File:** `assets/store/feature_graphic.png` (you create; not committed until you add it)

Use brand color `#6750A4` and `assets/branding/app_icon.png` in Figma/Canva, or any design tool. Upload to **Store listing → Feature graphic**.
