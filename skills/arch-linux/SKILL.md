---
name: arch-linux
description: Arch Linux package management, system maintenance, and troubleshooting commands. Use when working with pacman, AUR helpers (yay/paru), system updates, or Arch Linux-specific tasks.
---

# Arch Linux Package Management

## Базовые команды pacman

### Обновление системы
```bash
# Полное обновление системы
sudo pacman -Syu

# Обновление без синхронизации баз данных (если только что обновляли)
sudo pacman -Su
```

### Поиск и информация
```bash
# Поиск пакета в репозиториях
pacman -Ss <название>

# Информация об установленном пакете
pacman -Qi <название>

# Информация о пакете из репозитория
pacman -Si <название>

# Список файлов в пакете
pacman -Ql <название>

# Какой пакет содержит файл
pacman -Qo /path/to/file
```

### Установка и удаление
```bash
# Установка пакета
sudo pacman -S <название>

# Удаление пакета
sudo pacman -R <название>

# Удаление пакета со всеми зависимостями
sudo pacman -Rns <название>
```

### Очистка
```bash
# Очистка кеша пакетов (оставляет последние 3 версии)
sudo pacman -Sc

# Полная очистка кеша
sudo pacman -Scc

# Удаление осиротевших пакетов
sudo pacman -Rns $(pacman -Qtdq)
```

## AUR (yay/paru)

### Установка из AUR
```bash
# Установка пакета из AUR (yay)
yay -S <название>

# Поиск в AUR
yay -Ss <название>

# Обновление AUR пакетов
yay -Sua
```

## Распространенные проблемы

### Конфликт ключей
```bash
# Обновить ключи
sudo pacman-key --refresh-keys

# Заполнить keyring
sudo pacman -S archlinux-keyring
```

### Поврежденная база данных
```bash
# Синхронизировать базы данных
sudo pacman -Syy
```

## Best Practices

1. **Всегда обновляйте систему перед установкой нового ПО**: `sudo pacman -Syu`
2. **Читайте новости Arch Linux** перед обновлением: https://archlinux.org/news/
3. **Регулярно очищайте кеш** для экономии места
4. **Удаляйте осиротевшие пакеты** после удаления софта

## References

- Arch Wiki: https://wiki.archlinux.org/title/Pacman
- AUR: https://wiki.archlinux.org/title/Arch_User_Repository
