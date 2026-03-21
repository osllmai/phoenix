// ThemeData.js — All theme palettes for Phoenix
// Source of truth: docs/themes/*.json
// Each theme provides light/dark arrays matching Colors.qml palette structure:
//   textColor[7], textSelectionColor[2], backgroundColor[5], primaryColor[5],
//   errorColor[5], successColor[5], warningColor[5], infoColor[5],
//   orangeColor[5], magentaColor[5], overlayColor[2]

var themes = {
    "editra": {
        light: {
            textColor:          ["#FFFFFF", "#9CA3AF", "#F8F9FA", "#6B7280", "#6B7280", "#111827", "#111827"],
            textSelectionColor: ["#FFFFFF", "#6B7280"],
            backgroundColor:    ["#FFFFFF", "#F8F9FA", "#F3F4F6", "#E5E7EB", "#9CA3AF"],
            primaryColor:       ["#EDE9FE", "#8B7CF6", "#6C5CE7", "#5B4BD5", "#4A3CB0"],
            errorColor:         ["#FCE4E4", "#F87171", "#EF4444", "#DC2626", "#B91C1C"],
            successColor:       ["#E4F9ED", "#34D399", "#10B981", "#059669", "#047857"],
            warningColor:       ["#FEF3C7", "#F59E0B", "#D97706", "#B45309", "#92400E"],
            infoColor:          ["#DBEAFE", "#60A5FA", "#2563EB", "#1D4ED8", "#1E40AF"],
            orangeColor:        ["#FFF3EB", "#FDBA74", "#F97316", "#EA580C", "#C2410C"],
            magentaColor:       ["#FCE7F3", "#F472B6", "#DB2777", "#BE185D", "#9D174D"],
            overlayColor:       ["#47c8c8c8", "#b80a0a0a"]
        },
        dark: {
            textColor:          ["#FFFFFF", "#6B7280", "#1A1A1A", "#9CA3AF", "#9CA3AF", "#F9FAFB", "#F9FAFB"],
            textSelectionColor: ["#9CA3AF", "#F9FAFB"],
            backgroundColor:    ["#0F0F0F", "#1A1A1A", "#1A1A1A", "#2D2D2D", "#6B7280"],
            primaryColor:       ["#2D2654", "#6C5CE7", "#8B7CF6", "#A78BFA", "#C4B5FD"],
            errorColor:         ["#3B1111", "#DC2626", "#EF4444", "#F87171", "#FCA5A5"],
            successColor:       ["#0D3320", "#059669", "#10B981", "#34D399", "#6EE7B7"],
            warningColor:       ["#78350F", "#B45309", "#F59E0B", "#FBBF24", "#FDE68A"],
            infoColor:          ["#1E3A5F", "#1D4ED8", "#2563EB", "#60A5FA", "#93C5FD"],
            orangeColor:        ["#431407", "#C2410C", "#F97316", "#FDBA74", "#FED7AA"],
            magentaColor:       ["#500724", "#9D174D", "#DB2777", "#F472B6", "#F9A8D4"],
            overlayColor:       ["#b80a0a0a", "#b80a0a0a"]
        }
    },
    "copper": {
        light: {
            textColor:          ["#FFFFFF", "#A8A29E", "#FAF5EF", "#78716C", "#78716C", "#1C1210", "#1C1210"],
            textSelectionColor: ["#FFFFFF", "#78716C"],
            backgroundColor:    ["#FFFBF7", "#FAF5EF", "#FAF5EF", "#E7E0D9", "#A8A29E"],
            primaryColor:       ["#FDE8D0", "#D4915A", "#B87333", "#9A5F28", "#7D4B1E"],
            errorColor:         ["#FCE4E4", "#F87171", "#DC2626", "#B91C1C", "#991B1B"],
            successColor:       ["#E4F9ED", "#34D399", "#059669", "#047857", "#065F46"],
            warningColor:       ["#FEF3C7", "#D97706", "#B45309", "#92400E", "#78350F"],
            infoColor:          ["#DBEAFE", "#60A5FA", "#2563EB", "#1D4ED8", "#1E40AF"],
            orangeColor:        ["#FFF3EB", "#FDBA74", "#F97316", "#EA580C", "#C2410C"],
            magentaColor:       ["#FCE7F3", "#F472B6", "#DB2777", "#BE185D", "#9D174D"],
            overlayColor:       ["#47c8c8c8", "#b80a0a0a"]
        },
        dark: {
            textColor:          ["#FFFFFF", "#78716C", "#1A1614", "#A8A29E", "#A8A29E", "#F5F0EB", "#F5F0EB"],
            textSelectionColor: ["#A8A29E", "#F5F0EB"],
            backgroundColor:    ["#110E0C", "#1A1614", "#1A1614", "#302824", "#78716C"],
            primaryColor:       ["#3D2A1A", "#B87333", "#D4915A", "#E0A87A", "#ECC5A5"],
            errorColor:         ["#3B1111", "#B91C1C", "#DC2626", "#F87171", "#FCA5A5"],
            successColor:       ["#0D3320", "#047857", "#059669", "#34D399", "#6EE7B7"],
            warningColor:       ["#78350F", "#92400E", "#D97706", "#FBBF24", "#FDE68A"],
            infoColor:          ["#1E3A5F", "#1D4ED8", "#2563EB", "#60A5FA", "#93C5FD"],
            orangeColor:        ["#431407", "#C2410C", "#F97316", "#FDBA74", "#FED7AA"],
            magentaColor:       ["#500724", "#9D174D", "#DB2777", "#F472B6", "#F9A8D4"],
            overlayColor:       ["#b80a0a0a", "#b80a0a0a"]
        }
    },
    "obsidian": {
        light: {
            textColor:          ["#FFFFFF", "#94A3B8", "#F1F5F9", "#64748B", "#64748B", "#0F172A", "#0F172A"],
            textSelectionColor: ["#FFFFFF", "#64748B"],
            backgroundColor:    ["#FFFFFF", "#F1F5F9", "#F1F5F9", "#CBD5E1", "#94A3B8"],
            primaryColor:       ["#E2E8F0", "#94A3B8", "#334155", "#1E293B", "#0F172A"],
            errorColor:         ["#FCE4E4", "#F87171", "#DC2626", "#B91C1C", "#991B1B"],
            successColor:       ["#E4F9ED", "#34D399", "#059669", "#047857", "#065F46"],
            warningColor:       ["#FEF3C7", "#D97706", "#B45309", "#92400E", "#78350F"],
            infoColor:          ["#DBEAFE", "#60A5FA", "#2563EB", "#1D4ED8", "#1E40AF"],
            orangeColor:        ["#FFF3EB", "#FDBA74", "#F97316", "#EA580C", "#C2410C"],
            magentaColor:       ["#FCE7F3", "#F472B6", "#DB2777", "#BE185D", "#9D174D"],
            overlayColor:       ["#47c8c8c8", "#b80a0a0a"]
        },
        dark: {
            textColor:          ["#FFFFFF", "#64748B", "#1E293B", "#94A3B8", "#94A3B8", "#F1F5F9", "#F1F5F9"],
            textSelectionColor: ["#94A3B8", "#F1F5F9"],
            backgroundColor:    ["#0F172A", "#1E293B", "#1E293B", "#334155", "#64748B"],
            primaryColor:       ["#1E293B", "#334155", "#94A3B8", "#CBD5E1", "#E2E8F0"],
            errorColor:         ["#3B1111", "#B91C1C", "#DC2626", "#F87171", "#FCA5A5"],
            successColor:       ["#0D3320", "#047857", "#059669", "#34D399", "#6EE7B7"],
            warningColor:       ["#78350F", "#92400E", "#D97706", "#FBBF24", "#FDE68A"],
            infoColor:          ["#1E3A5F", "#1D4ED8", "#2563EB", "#60A5FA", "#93C5FD"],
            orangeColor:        ["#431407", "#C2410C", "#F97316", "#FDBA74", "#FED7AA"],
            magentaColor:       ["#500724", "#9D174D", "#DB2777", "#F472B6", "#F9A8D4"],
            overlayColor:       ["#b80a0a0a", "#b80a0a0a"]
        }
    },
    "indigo": {
        light: {
            textColor:          ["#FFFFFF", "#A5B4FC", "#F5F5FA", "#6366F1", "#6366F1", "#1E1B4B", "#1E1B4B"],
            textSelectionColor: ["#FFFFFF", "#6366F1"],
            backgroundColor:    ["#FFFFFF", "#F5F5FA", "#F5F5FA", "#DDD6FE", "#A5B4FC"],
            primaryColor:       ["#E0E7FF", "#818CF8", "#4F46E5", "#3730A3", "#312E81"],
            errorColor:         ["#FCE4E4", "#F87171", "#EF4444", "#DC2626", "#B91C1C"],
            successColor:       ["#E4F9ED", "#34D399", "#10B981", "#059669", "#047857"],
            warningColor:       ["#FEF3C7", "#F59E0B", "#D97706", "#B45309", "#92400E"],
            infoColor:          ["#DBEAFE", "#60A5FA", "#2563EB", "#1D4ED8", "#1E40AF"],
            orangeColor:        ["#FFF3EB", "#FDBA74", "#F97316", "#EA580C", "#C2410C"],
            magentaColor:       ["#FCE7F3", "#F472B6", "#DB2777", "#BE185D", "#9D174D"],
            overlayColor:       ["#47c8c8c8", "#b80a0a0a"]
        },
        dark: {
            textColor:          ["#FFFFFF", "#6366F1", "#1A1840", "#A5B4FC", "#A5B4FC", "#E0E7FF", "#E0E7FF"],
            textSelectionColor: ["#A5B4FC", "#E0E7FF"],
            backgroundColor:    ["#0F0F1A", "#1A1840", "#1A1840", "#312E81", "#6366F1"],
            primaryColor:       ["#272262", "#4F46E5", "#818CF8", "#A5B4FC", "#C7D2FE"],
            errorColor:         ["#3B1111", "#DC2626", "#EF4444", "#F87171", "#FCA5A5"],
            successColor:       ["#0D3320", "#059669", "#10B981", "#34D399", "#6EE7B7"],
            warningColor:       ["#78350F", "#B45309", "#F59E0B", "#FBBF24", "#FDE68A"],
            infoColor:          ["#1E3A5F", "#1D4ED8", "#2563EB", "#60A5FA", "#93C5FD"],
            orangeColor:        ["#431407", "#C2410C", "#F97316", "#FDBA74", "#FED7AA"],
            magentaColor:       ["#500724", "#9D174D", "#DB2777", "#F472B6", "#F9A8D4"],
            overlayColor:       ["#b80a0a0a", "#b80a0a0a"]
        }
    },
    "news": {
        light: {
            textColor:          ["#FFFFFF", "#ACAFC3", "#F3F4F6", "#7C82A1", "#7C82A1", "#333647", "#333647"],
            textSelectionColor: ["#FFFFFF", "#7C82A1"],
            backgroundColor:    ["#FFFFFF", "#F3F4F6", "#F3F4F6", "#E8E8E8", "#ACAFC3"],
            primaryColor:       ["#EEF0FB", "#8A96E5", "#475AD7", "#2536A7", "#1B2878"],
            errorColor:         ["#FCE4E4", "#E74C3C", "#E74C3C", "#C0392B", "#A93226"],
            successColor:       ["#E4F9ED", "#58D68D", "#2ECC71", "#27AE60", "#1E8449"],
            warningColor:       ["#FEF3C7", "#F59E0B", "#D97706", "#B45309", "#92400E"],
            infoColor:          ["#DBEAFE", "#60A5FA", "#2563EB", "#1D4ED8", "#1E40AF"],
            orangeColor:        ["#FFF3EB", "#FDBA74", "#F97316", "#EA580C", "#C2410C"],
            magentaColor:       ["#FCE7F3", "#F472B6", "#DB2777", "#BE185D", "#9D174D"],
            overlayColor:       ["#47c8c8c8", "#b80a0a0a"]
        },
        dark: {
            textColor:          ["#FFFFFF", "#7C82A1", "#333647", "#ACAFC3", "#ACAFC3", "#F3F4F6", "#F3F4F6"],
            textSelectionColor: ["#ACAFC3", "#F3F4F6"],
            backgroundColor:    ["#22242F", "#333647", "#333647", "#44485F", "#7C82A1"],
            primaryColor:       ["#2A2D45", "#475AD7", "#8A96E5", "#B0B8F0", "#D5D9F7"],
            errorColor:         ["#3B1111", "#C0392B", "#E74C3C", "#E74C3C", "#F1948A"],
            successColor:       ["#0D3320", "#1E8449", "#2ECC71", "#58D68D", "#ABEBC6"],
            warningColor:       ["#78350F", "#B45309", "#F59E0B", "#FBBF24", "#FDE68A"],
            infoColor:          ["#1E3A5F", "#1D4ED8", "#2563EB", "#60A5FA", "#93C5FD"],
            orangeColor:        ["#431407", "#C2410C", "#F97316", "#FDBA74", "#FED7AA"],
            magentaColor:       ["#500724", "#9D174D", "#DB2777", "#F472B6", "#F9A8D4"],
            overlayColor:       ["#b80a0a0a", "#b80a0a0a"]
        }
    },
    "pencilly": {
        light: {
            textColor:          ["#FFFFFF", "#8888AA", "#FFFFFF", "#8888AA", "#8888AA", "#1A1A2E", "#1A1A2E"],
            textSelectionColor: ["#FFFFFF", "#8888AA"],
            backgroundColor:    ["#F8F8FC", "#FFFFFF", "#FFFFFF", "#EBEBF5", "#8888AA"],
            primaryColor:       ["#F0EFFE", "#8B7FE8", "#5B4FCF", "#5B4FCF", "#4A3FB0"],
            errorColor:         ["#FCE4E4", "#EF4444", "#EF4444", "#DC2626", "#B91C1C"],
            successColor:       ["#E4F9ED", "#4ADE80", "#22C55E", "#16A34A", "#15803D"],
            warningColor:       ["#FEF3C7", "#F97316", "#D97706", "#B45309", "#92400E"],
            infoColor:          ["#DBEAFE", "#60A5FA", "#2563EB", "#1D4ED8", "#1E40AF"],
            orangeColor:        ["#FFF3EB", "#FDBA74", "#F97316", "#EA580C", "#C2410C"],
            magentaColor:       ["#FCE7F3", "#F472B6", "#E040A0", "#BE185D", "#9D174D"],
            overlayColor:       ["#47c8c8c8", "#b80a0a0a"]
        },
        dark: {
            textColor:          ["#1A1A2E", "#9999BB", "#1A1A2E", "#9999BB", "#9999BB", "#F0F0FF", "#F0F0FF"],
            textSelectionColor: ["#9999BB", "#F0F0FF"],
            backgroundColor:    ["#0F0F1A", "#1A1A2E", "#1A1A2E", "#2A2A4A", "#9999BB"],
            primaryColor:       ["#2A2560", "#5B4FCF", "#8B7FE8", "#AFA4F0", "#D0C9F5"],
            errorColor:         ["#3B1111", "#DC2626", "#EF4444", "#F87171", "#FCA5A5"],
            successColor:       ["#0D3320", "#16A34A", "#22C55E", "#4ADE80", "#86EFAC"],
            warningColor:       ["#78350F", "#B45309", "#F97316", "#FBBF24", "#FDE68A"],
            infoColor:          ["#1E3A5F", "#1D4ED8", "#3B82F6", "#60A5FA", "#93C5FD"],
            orangeColor:        ["#431407", "#C2410C", "#F97316", "#FDBA74", "#FED7AA"],
            magentaColor:       ["#500724", "#9D174D", "#E040A0", "#F472B6", "#F9A8D4"],
            overlayColor:       ["#b80a0a0a", "#b80a0a0a"]
        }
    },
    "indox": {
        light: {
            textColor:          ["#FFFFFF", "#9BA3AE", "#FBFBFF", "#434D5A", "#434D5A", "#252525", "#252525"],
            textSelectionColor: ["#FFFFFF", "#434D5A"],
            backgroundColor:    ["#FBFBFF", "#FBFBFF", "#EEF0F5", "#CDD0D8", "#9BA3AE"],
            primaryColor:       ["#ECEFFD", "#4989FF", "#1F3AB3", "#1F3AB3", "#162D8A"],
            errorColor:         ["#FCE4E4", "#F87171", "#F00500", "#DC2626", "#B91C1C"],
            successColor:       ["#E4F9ED", "#34D399", "#00A14E", "#059669", "#047857"],
            warningColor:       ["#FEF3C7", "#F5AC37", "#D97706", "#B45309", "#92400E"],
            infoColor:          ["#ECEFFD", "#4989FF", "#1F3AB3", "#1D4ED8", "#1E40AF"],
            orangeColor:        ["#FFF3EB", "#FDBA74", "#F97316", "#EA580C", "#C2410C"],
            magentaColor:       ["#FCE7F3", "#F472B6", "#8247E5", "#6D28D9", "#5B21B6"],
            overlayColor:       ["#47c8c8c8", "#b80a0a0a"]
        },
        dark: {
            textColor:          ["#081125", "#434D5A", "#081125", "#9BA3AE", "#9BA3AE", "#FFFFFF", "#FFFFFF"],
            textSelectionColor: ["#9BA3AE", "#FFFFFF"],
            backgroundColor:    ["#081125", "#081125", "#0C204E", "#434D5A", "#9BA3AE"],
            primaryColor:       ["#1A3B8B", "#1F3AB3", "#4989FF", "#6BA3FF", "#A3C4FF"],
            errorColor:         ["#3B1111", "#DC2626", "#F00500", "#F87171", "#FCA5A5"],
            successColor:       ["#0D3320", "#047857", "#2FCF6E", "#34D399", "#6EE7B7"],
            warningColor:       ["#78350F", "#B45309", "#F5AC37", "#FBBF24", "#FDE68A"],
            infoColor:          ["#1A3B8B", "#1D4ED8", "#4989FF", "#6BA3FF", "#A3C4FF"],
            orangeColor:        ["#431407", "#C2410C", "#F97316", "#FDBA74", "#FED7AA"],
            magentaColor:       ["#500724", "#5B21B6", "#8247E5", "#A78BFA", "#C4B5FD"],
            overlayColor:       ["#b80a0a0a", "#b80a0a0a"]
        }
    }
}

function getPalette(themeName, mode) {
    var t = themes[themeName]
    if (!t) t = themes["editra"]
    return (mode === "Light") ? t.light : t.dark
}
