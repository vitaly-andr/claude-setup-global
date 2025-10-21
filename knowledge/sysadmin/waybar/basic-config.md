# Waybar: Основные конфигурации

> Последнее обновление: 2025-10-21
> Версия: Waybar 0.10+

## Расположение конфигурации

```
~/.config/waybar/
├── config       # Конфигурация модулей (JSON)
└── style.css    # Стили (CSS)
```

## Базовая структура config

```json
{
    "layer": "top",
    "position": "top",
    "height": 30,
    "spacing": 4,

    "modules-left": ["hyprland/workspaces", "hyprland/window"],
    "modules-center": ["clock"],
    "modules-right": ["pulseaudio", "network", "cpu", "memory", "battery", "tray"],

    "hyprland/workspaces": {
        "disable-scroll": true,
        "all-outputs": true,
        "format": "{name}"
    },

    "clock": {
        "timezone": "Europe/Moscow",
        "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
        "format": "{:%H:%M   %d.%m.%Y}"
    },

    "cpu": {
        "format": " {usage}%",
        "tooltip": false
    },

    "memory": {
        "format": " {}%"
    },

    "battery": {
        "states": {
            "warning": 30,
            "critical": 15
        },
        "format": "{icon} {capacity}%",
        "format-charging": " {capacity}%",
        "format-plugged": " {capacity}%",
        "format-icons": ["", "", "", "", ""]
    },

    "network": {
        "format-wifi": " {essid} ({signalStrength}%)",
        "format-ethernet": " {ifname}",
        "format-disconnected": "⚠ Disconnected",
        "tooltip-format": "{ifname}: {ipaddr}"
    },

    "pulseaudio": {
        "format": "{icon} {volume}%",
        "format-muted": " Muted",
        "format-icons": {
            "default": ["", "", ""]
        },
        "on-click": "pavucontrol"
    }
}
```

## Базовый style.css

```css
* {
    border: none;
    border-radius: 0;
    font-family: "JetBrainsMono Nerd Font";
    font-size: 13px;
    min-height: 0;
}

window#waybar {
    background: rgba(26, 27, 38, 0.9);
    color: #ffffff;
}

#workspaces button {
    padding: 0 5px;
    background: transparent;
    color: #ffffff;
}

#workspaces button.active {
    background: rgba(255, 255, 255, 0.1);
}

#clock,
#battery,
#cpu,
#memory,
#network,
#pulseaudio {
    padding: 0 10px;
}

#battery.charging {
    color: #26a269;
}

#battery.warning:not(.charging) {
    color: #f9e2af;
}

#battery.critical:not(.charging) {
    color: #f38ba8;
}
```

## Частые команды

### Перезапуск Waybar
```bash
killall waybar && waybar &
```

### Отладка конфигурации
```bash
# Запустить с выводом в терминал
waybar -l debug
```

## Полезные модули

### Hyprland workspaces (активные рабочие столы)
```json
"hyprland/workspaces": {
    "format": "{id}: {icon}",
    "format-icons": {
        "1": "",
        "2": "",
        "3": "",
        "4": "",
        "5": ""
    },
    "persistent_workspaces": {
        "1": [],
        "2": [],
        "3": [],
        "4": [],
        "5": []
    }
}
```

### Custom module (произвольные скрипты)
```json
"custom/weather": {
    "exec": "curl 'wttr.in/Moscow?format=3'",
    "interval": 3600,
    "format": "{}"
}
```

## Частые проблемы

### Waybar не запускается
```bash
# Проверить JSON на ошибки
cat ~/.config/waybar/config | jq .

# Проверить логи
journalctl --user -u waybar
```

### Модуль battery не работает
```json
"battery": {
    "bat": "BAT0",  // Укажите правильное имя батареи
    "adapter": "AC"
}
```

Узнать имя батареи:
```bash
ls /sys/class/power_supply/
```

### Иконки не отображаются
Установите Nerd Font:
```bash
sudo pacman -S ttf-jetbrains-mono-nerd
```

---
**Источники**:
- https://github.com/Alexays/Waybar/wiki
- https://github.com/Alexays/Waybar/wiki/Configuration
