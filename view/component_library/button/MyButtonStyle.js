// MyButtonStyle.js — Color lookup tables for MyButton
// Colors object must be passed to init() before use.
// Indexed by [buttonType][state] matching RoleEnum integer values:
//   BottonType: Primary=0, Secondary=1, Danger=2, Feature=3, Progress=4
//   State:      Normal=0, Hover=1, Pressed=2, Disabled=3, Selected=4

var _bg, _grad0, _grad1, _text, _border
var _ready = false

function init(C) {
    if (_ready) return
    _bg = [
        [C.buttonPrimaryNormal,   C.buttonPrimaryHover,   C.buttonPrimaryPressed,   C.buttonPrimaryDisabled,   C.buttonPrimarySelected],
        [C.buttonSecondaryNormal,  C.buttonSecondaryHover,  C.buttonSecondaryPressed,  C.buttonSecondaryDisabled,  C.buttonSecondarySelected],
        [C.buttonDangerNormal,     C.buttonDangerHover,     C.buttonDangerPressed,     C.buttonDangerDisabled,     C.buttonDangerSelected],
        [C.buttonFeatureNormal,    C.buttonFeatureHover,    C.buttonFeaturePressed,    C.buttonFeatureDisabled,    C.buttonFeatureSelected],
        [C.buttonProgressNormal,   C.buttonProgressHover,   C.buttonProgressPressed,   C.buttonProgressDisabled,   C.buttonProgressSelected]
    ]
    _grad0 = [
        [C.buttonPrimaryNormal, C.buttonPrimaryHover, C.buttonPrimaryPressed, C.buttonPrimaryDisabled, C.buttonPrimarySelected],
        [C.buttonPrimaryNormal, C.buttonPrimaryHover, C.buttonPrimaryPressed, C.buttonPrimaryDisabled, C.buttonPrimarySelected],
        [C.buttonPrimaryNormal, C.buttonPrimaryHover, C.buttonPrimaryPressed, C.buttonPrimaryDisabled, C.buttonPrimarySelected],
        [C.buttonPrimaryNormal, C.buttonPrimaryHover, C.buttonPrimaryPressed, C.buttonPrimaryDisabled, C.buttonPrimarySelected],
        [C.buttonProgressNormalGradient0, C.buttonProgressHoverGradient0, C.buttonProgressPressedGradient0, C.buttonProgressDisabledGradient0, C.buttonProgressSelectedGradient0]
    ]
    _grad1 = [
        [C.buttonPrimaryNormal, C.buttonPrimaryHover, C.buttonPrimaryPressed, C.buttonPrimaryDisabled, C.buttonPrimarySelected],
        [C.buttonPrimaryNormal, C.buttonPrimaryHover, C.buttonPrimaryPressed, C.buttonPrimaryDisabled, C.buttonPrimarySelected],
        [C.buttonPrimaryNormal, C.buttonPrimaryHover, C.buttonPrimaryPressed, C.buttonPrimaryDisabled, C.buttonPrimarySelected],
        [C.buttonPrimaryNormal, C.buttonPrimaryHover, C.buttonPrimaryPressed, C.buttonPrimaryDisabled, C.buttonPrimarySelected],
        [C.buttonProgressNormalGradient1, C.buttonProgressHoverGradient1, C.buttonProgressPressedGradient1, C.buttonProgressDisabledGradient1, C.buttonProgressSelectedGradient1]
    ]
    _text = [
        [C.buttonPrimaryTextNormal,   C.buttonPrimaryTextHover,   C.buttonPrimaryTextPressed,   C.buttonPrimaryTextDisabled,   C.buttonPrimaryTextSelected],
        [C.buttonSecondaryTextNormal,  C.buttonSecondaryTextHover,  C.buttonSecondaryTextPressed,  C.buttonSecondaryTextDisabled,  C.buttonSecondaryTextSelected],
        [C.buttonDangerTextNormal,     C.buttonDangerTextHover,     C.buttonDangerTextPressed,     C.buttonDangerTextDisabled,     C.buttonDangerTextSelected],
        [C.buttonFeatureTextNormal,    C.buttonFeatureTextHover,    C.buttonFeatureTextPressed,    C.buttonFeatureTextDisabled,    C.buttonFeatureTextSelected],
        [C.buttonProgressBorderNormal, C.buttonProgressBorderNormal, C.buttonProgressBorderNormal, C.buttonProgressBorderNormal, C.buttonProgressBorderNormal]
    ]
    _border = [
        [C.buttonPrimaryBorderNormal,   C.buttonPrimaryBorderHover,   C.buttonPrimaryBorderPressed,   C.buttonPrimaryBorderDisabled,   C.buttonPrimaryBorderSelected],
        [C.buttonSecondaryBorderNormal,  C.buttonSecondaryBorderHover,  C.buttonSecondaryBorderPressed,  C.buttonSecondaryBorderDisabled,  C.buttonSecondaryBorderSelected],
        [C.buttonDangerBorderNormal,     C.buttonDangerBorderHover,     C.buttonDangerBorderPressed,     C.buttonDangerBorderDisabled,     C.buttonDangerBorderSelected],
        [C.buttonFeatureBorderNormal,    C.buttonFeatureBorderHover,    C.buttonFeatureBorderPressed,    C.buttonFeatureBorderDisabled,    C.buttonFeatureBorderSelected],
        [C.buttonProgressBorderNormal,   C.buttonProgressBorderNormal,  C.buttonProgressBorderNormal,   C.buttonProgressBorderNormal,    C.buttonProgressBorderNormal]
    ]
    _ready = true
}

function _lookup(table, buttonType, state) {
    var row = table[buttonType] || table[0]
    return row[state] || row[0]
}

function choiceBackgroundColor(bt, st)         { return _lookup(_bg, bt, st) }
function choiceBackgroundColorGradient0(bt, st) { return _lookup(_grad0, bt, st) }
function choiceBackgroundColorGradient1(bt, st) { return _lookup(_grad1, bt, st) }
function choiceTextColor(bt, st)               { return _lookup(_text, bt, st) }
function choiceBorderColor(bt, st)             { return _lookup(_border, bt, st) }
