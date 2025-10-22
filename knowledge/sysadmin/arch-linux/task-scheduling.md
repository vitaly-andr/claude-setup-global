# Запуск задач по расписанию в Arch Linux

> Дата: 2025-10-22
> Валидировано: User experience (Omarchy system)
> Система: Arch Linux
> Теги: #systemd #timers #scheduling #automation #best-practices

## Контекст

При необходимости запускать задачи по расписанию на Arch Linux системах (особенно на Omarchy).

**ВАЖНО**: На Arch Linux следует использовать **systemd user timers**, а НЕ cron.

## Решение

### Предпочтительный метод: systemd user timers

```bash
# 1. Создать service файл (задача для выполнения)
nano ~/.config/systemd/user/my-task.service

# 2. Создать timer файл (расписание)
nano ~/.config/systemd/user/my-task.timer

# 3. Перезагрузить конфигурацию systemd
systemctl --user daemon-reload

# 4. Включить и запустить timer
systemctl --user enable --now my-task.timer

# 5. Проверить статус
systemctl --user status my-task.timer
systemctl --user list-timers
```

### Пример service файла

```ini
# ~/.config/systemd/user/cleanup-screenshots.service
[Unit]
Description=Cleanup old screenshots

[Service]
Type=oneshot
ExecStart=/home/user/scripts/cleanup-screenshots.sh
```

### Пример timer файла

```ini
# ~/.config/systemd/user/cleanup-screenshots.timer
[Unit]
Description=Run screenshot cleanup daily

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
```

### Расписание (OnCalendar примеры)

```ini
OnCalendar=daily           # каждый день в 00:00
OnCalendar=weekly          # каждую неделю в понедельник в 00:00
OnCalendar=monthly         # первое число месяца в 00:00
OnCalendar=*-*-* 02:00:00  # каждый день в 02:00
OnCalendar=Mon *-*-* 10:00 # каждый понедельник в 10:00
OnCalendar=*:0/15          # каждые 15 минут
```

### Управление timers

```bash
# Просмотр всех таймеров
systemctl --user list-timers --all

# Просмотр логов
journalctl --user -u my-task.service

# Остановка и отключение
systemctl --user disable --now my-task.timer

# Перезапуск после изменения файлов
systemctl --user daemon-reload
systemctl --user restart my-task.timer
```

## Объяснение

### Почему systemd timers, а не cron:

1. **Встроенность**: Systemd уже настроен и работает в Arch Linux
2. **Интеграция с системой**: Логи через `journalctl`, удобный просмотр и отладка
3. **Простое управление**: Единый интерфейс через `systemctl`
4. **Уже используется**: В системе уже есть systemd timers (например, `omarchy-battery-monitor.timer`)
5. **Не требует установки**: Не нужно устанавливать дополнительные пакеты (cronie)
6. **Лучшая надежность**: Persistent=true позволяет запустить пропущенные задачи после выключения
7. **Пользовательский уровень**: User timers работают без root прав

### Почему НЕ cron:

- `crontab` не установлен по умолчанию в Arch Linux
- Требует установки пакета `cronie`
- Менее интегрирован с современными системами
- Сложнее отладка (логи не в journalctl)
- Дублирование функциональности systemd

## Реальный пример из системы

В системе Omarchy уже используется systemd timer:

```bash
$ systemctl --user list-timers
NEXT                        LEFT          LAST                        PASSED       UNIT                              ACTIVATES
Mon 2025-10-22 12:00:00 UTC 45min left    Mon 2025-10-22 11:00:00 UTC 15min ago    omarchy-battery-monitor.timer     omarchy-battery-monitor.service
```

Это подтверждает, что systemd timers - стандартный подход для данной системы.

## Альтернативы

### Cron (НЕ рекомендуется)

Если по какой-то причине необходимо использовать cron:

```bash
# Установка
sudo pacman -S cronie
sudo systemctl enable --now cronie

# Редактирование crontab
crontab -e

# Пример задачи (каждый день в 2:00)
0 2 * * * /home/user/scripts/cleanup.sh
```

**Используйте только если**:
- Требуется совместимость со старыми скриптами
- Миграция с другой системы, где использовался cron
- Специфические требования проекта

### At (разовые задачи)

Для одноразового выполнения в будущем:

```bash
# Установка (если нужно)
sudo pacman -S at

# Пример
echo "/home/user/script.sh" | at 14:00
```

## Troubleshooting

### Timer не запускается

```bash
# Проверить статус
systemctl --user status my-task.timer
systemctl --user status my-task.service

# Проверить логи
journalctl --user -u my-task.service -n 50

# Проверить синтаксис таймера
systemd-analyze verify ~/.config/systemd/user/my-task.timer
```

### Задача не выполняется по расписанию

```bash
# Убедиться что timer активен
systemctl --user is-enabled my-task.timer

# Проверить следующий запуск
systemctl --user list-timers

# Вручную запустить service для проверки
systemctl --user start my-task.service
```

## Источники

- [ArchWiki - systemd/Timers](https://wiki.archlinux.org/title/Systemd/Timers)
- [systemd.timer man page](https://www.freedesktop.org/software/systemd/man/systemd.timer.html)
- Проверено: 2025-10-22 на Omarchy (Arch Linux)
- Контекст: Настройка автоматической очистки скриншотов

---

**История обновлений:**
- 2025-10-22: Первая версия - задокументировано предпочтение systemd timers для Arch Linux
