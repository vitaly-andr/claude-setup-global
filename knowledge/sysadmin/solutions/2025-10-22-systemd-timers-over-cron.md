# Используем systemd timers вместо cron на Arch Linux

> Дата: 2025-10-22
> Категория: arch-linux/task-scheduling.md
> Система: Omarchy (Arch Linux)

## Проблема

При настройке автоматической очистки скриншотов было предложено использовать cron, но оказалось, что `crontab` не установлен в системе.

## Найденное решение

На Arch Linux (особенно Omarchy) следует использовать **systemd user timers** как стандартный метод для запуска задач по расписанию.

### Причины

1. Systemd уже встроен и настроен
2. В системе уже используются systemd timers (например, `omarchy-battery-monitor.timer`)
3. Лучше интеграция с journalctl для логов
4. Не требует установки дополнительных пакетов
5. Проще управление через systemctl

### Быстрый пример

```bash
# Создать service и timer
~/.config/systemd/user/task.service
~/.config/systemd/user/task.timer

# Активировать
systemctl --user enable --now task.timer
```

## Результат

Решение принято как best practice для Arch Linux систем. Задокументировано в `arch-linux/task-scheduling.md`.

## Обучение

В будущем при задачах по автоматизации на Arch Linux агенты должны сразу предлагать systemd timers как первый вариант, а не cron.

---

См. полную документацию: `/home/vitaly/.claude/knowledge/sysadmin/arch-linux/task-scheduling.md`
