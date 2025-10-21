# Hyprland: Основные конфигурации

> Последнее обновление: 2025-10-21
> Версия: Hyprland 0.40+

## Расположение конфигурации

```
~/.config/hypr/
├── hyprland.conf      # Основной файл
├── monitors.conf      # Настройки мониторов (опционально)
├── keybinds.conf      # Горячие клавиши (опционально)
└── windowrules.conf   # Правила окон (опционально)
```

## Базовая структура hyprland.conf

```conf
# Monitors
monitor=,preferred,auto,1

# Input
input {
    kb_layout = us,ru
    kb_options = grp:alt_shift_toggle
    follow_mouse = 1
    touchpad {
        natural_scroll = false
    }
}

# General
general {
    gaps_in = 5
    gaps_out = 10
    border_size = 2
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    col.inactive_border = rgba(595959aa)
    layout = dwindle
}

# Decoration
decoration {
    rounding = 10
    blur {
        enabled = true
        size = 3
        passes = 1
    }
    drop_shadow = true
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
}

# Animations
animations {
    enabled = true
    bezier = myBezier, 0.05, 0.9, 0.1, 1.05
    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = borderangle, 1, 8, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}
```

## Частые команды

### Перезагрузка конфигурации
```bash
hyprctl reload
```

### Проверка синтаксиса
```bash
# Запустить в отладочном режиме
Hyprland --config ~/.config/hypr/hyprland.conf
```

### Просмотр активных окон
```bash
hyprctl clients
```

### Просмотр мониторов
```bash
hyprctl monitors
```

## Модульная конфигурация

Для удобства можно разбить на модули:

**hyprland.conf**:
```conf
source = ~/.config/hypr/monitors.conf
source = ~/.config/hypr/keybinds.conf
source = ~/.config/hypr/windowrules.conf
```

**monitors.conf**:
```conf
monitor=DP-1,1920x1080@144,0x0,1
monitor=HDMI-A-1,1920x1080@60,1920x0,1
```

**keybinds.conf**:
```conf
$mainMod = SUPER

bind = $mainMod, Return, exec, kitty
bind = $mainMod, Q, killactive
bind = $mainMod, M, exit
bind = $mainMod, V, togglefloating
bind = $mainMod, P, pseudo
bind = $mainMod, J, togglesplit

# Move focus
bind = $mainMod, left, movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up, movefocus, u
bind = $mainMod, down, movefocus, d
```

## Проблемы и решения

### Мониторы не распознаются
```bash
# Получить список доступных выходов
hyprctl monitors all

# Применить конфигурацию монитора
hyprctl keyword monitor "DP-1,1920x1080@144,0x0,1"
```

### Тормоза/лаги
```conf
# Отключить blur для повышения производительности
decoration {
    blur {
        enabled = false
    }
}
```

---
**Источники**:
- https://wiki.hyprland.org/Configuring/Configuring-Hyprland/
- https://wiki.hyprland.org/Configuring/Variables/
