---
name: systemd-timers
description: Systemd user timers for scheduling tasks on Arch Linux systems. Use instead of cron for automated task scheduling, periodic jobs, and system maintenance tasks.
---

# Systemd User Timers

**ВАЖНО**: На Arch Linux следует использовать **systemd user timers**, а НЕ cron.

## Быстрый старт

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

## Пример service файла

```ini
# ~/.config/systemd/user/cleanup-screenshots.service
[Unit]
Description=Cleanup old screenshots

[Service]
Type=oneshot
ExecStart=/home/user/scripts/cleanup-screenshots.sh
```

## Пример timer файла

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

## Расписание (OnCalendar примеры)

```ini
OnCalendar=daily           # каждый день в 00:00
OnCalendar=weekly          # каждую неделю в понедельник в 00:00
OnCalendar=monthly         # первое число месяца в 00:00
OnCalendar=*-*-* 02:00:00  # каждый день в 02:00
OnCalendar=Mon *-*-* 10:00 # каждый понедельник в 10:00
OnCalendar=*:0/15          # каждые 15 минут
```

## Управление timers

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

## Почему systemd timers, а не cron

1. **Встроенность**: Systemd уже настроен и работает в Arch Linux
2. **Интеграция с системой**: Логи через `journalctl`, удобный просмотр и отладка
3. **Простое управление**: Единый интерфейс через `systemctl`
4. **Не требует установки**: Не нужно устанавливать дополнительные пакеты (cronie)
5. **Лучшая надежность**: Persistent=true позволяет запустить пропущенные задачи после выключения
6. **Пользовательский уровень**: User timers работают без root прав

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

## References

- [ArchWiki - systemd/Timers](https://wiki.archlinux.org/title/Systemd/Timers)
- [systemd.timer man page](https://www.freedesktop.org/software/systemd/man/systemd.timer.html)
