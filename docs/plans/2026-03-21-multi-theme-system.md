# Multi-Theme System for Phoenix

**Date:** 2026-03-21
**Status:** PLANNING — awaiting approval

---

## Goal
Apply all 7 theme variants from `docs/themes/` to Phoenix, allowing runtime theme switching.

## Current State
- `Colors.qml` uses array-based palettes (textColor[0-6], backgroundColor[0-4], primaryColor[0-4], etc.)
- A single `isDarkTheme` boolean toggles light/dark
- ~90 semantic tokens derived from palette arrays
- `MyButtonStyle.js` uses array-indexed lookup tables referencing Colors properties
- All QML files use `Style.Colors.<token>` — this pattern stays

## Theme JSON Token Schema (shared across all 7 themes)
```
primary, primaryDark, primaryLight, primarySurface,
background, scaffold, surface, surfaceVariant,
textPrimary, textSecondary, textHint, textOnPrimary,
inputBg, inputBorder, inputIcon,
navBarBg, navBarActive, navBarInactive, navBarBorder,
divider, borderLight, shadow,
categoryBg, categorySelectedBg, categorySelectedText,
settingsItemBg, articleOverlay,
error, errorLight, errorSurface, success, successSurface,
warning, warningLight, blue, blueLight, pink, pinkLight, savedStar
```

## Mapping: Theme JSON → Colors.qml Tokens

### Direct mapping (new semantic tokens to add)
| JSON Token | Colors.qml Property |
|------------|-------------------|
| primary | → primaryColor[2] equivalent |
| primaryDark | → primaryColor[3] equivalent |
| primaryLight | → primaryColor[1] equivalent |
| primarySurface | → primaryColor[0] equivalent |
| background | → background (already exists) |
| surface | → backgroundColor[1-2] equivalent |
| surfaceVariant | → backgroundColor[2-3] equivalent |
| textPrimary | → textTitle (already exists) |
| textSecondary | → textInformation (already exists) |
| textHint | → textPlaceholder equivalent |
| textOnPrimary | → buttonPrimaryTextNormal equivalent |
| inputBg | → new token |
| inputBorder | → boxBorder equivalent |
| divider | → new token |
| borderLight | → new token |
| error | → errorColor[2] equivalent |
| success | → successColor[2] equivalent |
| warning | → warningColor[2] equivalent |

### Strategy: Theme Data Files + Loader

**Phase 1: Create theme data files** (QML)
- `view/component_library/style/themes/EditraTheme.qml`
- `view/component_library/style/themes/CopperTheme.qml`
- `view/component_library/style/themes/ObsidianTheme.qml`
- `view/component_library/style/themes/IndigoTheme.qml`
- `view/component_library/style/themes/NewsTheme.qml`
- `view/component_library/style/themes/PencillyTheme.qml`
- `view/component_library/style/themes/IndoxTheme.qml`

Each file exports light/dark palette arrays that match the current Colors.qml array structure. This preserves backward compatibility with MyButtonStyle.js and all existing tokens.

**Phase 2: Add theme switching to Colors.qml**
- Add `property string currentTheme: "editra"` (default)
- Load the matching theme data based on `currentTheme`
- All existing `currentXxxColor` properties stay — they just read from the active theme's arrays
- No breaking changes to downstream consumers

**Phase 3: Add theme picker UI**
- Add theme selection in Settings view
- Persist selection via database/settings

**Phase 4: Verify build + test all themes**

## Array Mapping Per Theme

Each theme JSON needs to be converted into the existing palette array format:

```
textColor:       [textOnPrimary, textHint, surface, textSecondary, textSecondary, textPrimary, textPrimary(inverse)]
backgroundColor: [background, surface, surfaceVariant, borderLight, textHint]
primaryColor:    [primarySurface, primaryLight, primary, primaryDark, primaryDark(darker)]
errorColor:      [errorSurface, errorLight, error, error(dark), error(darker)]
successColor:    [successSurface, success(light), success, success(dark), success(darker)]
warningColor:    [warningLight, warning, warning(dark), warning(darker), warning(darkest)]
infoColor:       [blueLight, blue, blue(dark), blue(darker), blue(darkest)]
```

## File Changes

| File | Action |
|------|--------|
| `view/component_library/style/themes/*.qml` (7 files) | CREATE |
| `view/component_library/style/Colors.qml` | MODIFY — add theme switching |
| `view/component_library/style/qmldir` | MODIFY — register theme types |
| `CMakeLists.txt` | MODIFY — add new QML files |
| `view/settings/` | MODIFY — add theme picker |

## Risk Assessment
- **Low risk**: All existing `Style.Colors.xxx` references unchanged
- **Low risk**: MyButtonStyle.js unchanged — it reads Colors properties
- **Medium risk**: Array index mapping must be precise per theme
- Current "Atlassian-style" palette (the existing one) becomes the default "Phoenix" theme

## Decisions
1. Remove current palette entirely — replace with theme JSON palettes
2. Default theme: **editra**
3. Persist via **QSettings** (simple key-value, no DB table needed)

---

**Status: APPROVED — implementing**
