# Memory Bank: Быстрый старт

## Для пользователя

### Как это работает?

1. **Задаете задачу** sysadmin агенту (например, "настрой dual monitor для Hyprland")

2. **Sysadmin проверяет локальную базу** `~/.claude/knowledge/sysadmin/`
   - Если находит похожее решение → адаптирует и применяет
   - Если нет → ищет в интернете

3. **После успешного решения** sysadmin предложит:
   ```
   "Решение успешно применено! Вызываю librarian для валидации
   и сохранения в memory bank."
   ```

4. **Librarian проверяет** решение и сохраняет в базу знаний

5. **В следующий раз** похожая задача решится быстрее, без поиска в интернете

### Команды для работы с базой

```bash
# Просмотреть структуру базы знаний
tree ~/.claude/knowledge/

# Посмотреть последние решения
ls -lt ~/.claude/knowledge/sysadmin/solutions/

# Прочитать конкретное решение
cat ~/.claude/knowledge/sysadmin/solutions/2025-10-21-example.md

# Найти решение по ключевому слову
grep -r "waybar battery" ~/.claude/knowledge/sysadmin/
```

### Когда вручную пополнять базу?

Вы можете вручную добавлять файлы в `~/.claude/knowledge/sysadmin/`, следуя формату из `METHODOLOGY.md`. Но обычно агенты делают это автоматически.

## Для sysadmin агента

### Алгоритм работы

**На каждую задачу**:

```
1. Read ~/.claude/knowledge/sysadmin/[relevant-category]/*.md
2. Grep solutions/ для похожих проблем
3. Нашли локальное решение?
   ├─ ДА → Адаптировать и применить
   └─ НЕТ → WebSearch/WebFetch → Найти решение

4. Решение работает?
   ├─ ДА → Сложная задача? → Предложить сохранить
   └─ НЕТ → Отладка

5. Пользователь согласен сохранить?
   ├─ ДА → Вызвать librarian для валидации
   └─ НЕТ → Пропустить
```

### Когда предлагать сохранение?

✅ **Да** (стоит сохранить):
- Решение требовало исследования (не первая ссылка в Google)
- Нестандартная конфигурация
- Частая проблема, которая может повториться
- Найдено лучшее решение, чем в существующей базе

❌ **Нет** (не стоит):
- Тривиальная команда из man page
- Слишком специфичная для конкретного пользователя
- Уже есть в базе знаний

### Формулировка для вызова librarian

```
"Прошу librarian проверить решение для сохранения в memory bank:

Проблема: [краткое описание]
Решение: [команды/конфигурация]
Источники: [ссылки]
Протестировано: успешно на [система/версия]
"
```

## Для librarian агента

### Чек-лист валидации

При запросе от sysadmin проверьте:

- [ ] Решение технически корректно (WebFetch официальную документацию)
- [ ] Команды/методы актуальны (не deprecated)
- [ ] Нет уязвимостей безопасности
- [ ] Решение достаточно общее (переиспользуемое)
- [ ] Источники авторитетны и актуальны
- [ ] Формат соответствует METHODOLOGY.md

### Если все ОК

```markdown
## Memory Bank Validation

### ✅ Approved for Saving

**Verified**:
- Technical correctness: Confirmed via [source]
- Version compatibility: Works on [versions]
- Security: No issues found
- Reusability: General pattern applicable to similar cases

**Suggested Categories**:
- `~/.claude/knowledge/sysadmin/solutions/2025-10-21-description.md`
- `~/.claude/knowledge/sysadmin/[category]/subcategory.md` (if general pattern)

Proceeding to save...
```

Затем **Write** файл в указанное место.

### Если есть проблемы

```markdown
## Memory Bank Validation

### ⚠️ Needs Revision

**Issues Found**:
1. Command uses deprecated flag `--old-flag`: This was replaced in v2.0 - [source]
   **Fix**: Use `--new-flag` instead

2. Missing error handling: Solution doesn't account for missing dependencies
   **Fix**: Add check: `command -v dependency || sudo pacman -S dependency`

Please revise and resubmit.
```

## Метрики успеха

**Цель через 1 месяц**: >70% задач решаются из локальной базы

**Отслеживать** (неформально):
- Сколько раз использовали локальное решение
- Сколько новых решений добавлено
- Сколько раз обновили устаревшие решения

## Примеры workflow

### Пример 1: Задача решена из базы

```
Пользователь: "Настрой Waybar battery widget"
↓
Sysadmin:
  - Read ~/.claude/knowledge/sysadmin/waybar/basic-config.md
  - Находит секцию про battery
  - Применяет конфигурацию
  - Работает!
  - "Решение применено из локальной базы знаний"
  - (Не предлагает сохранение, т.к. уже в базе)
```

### Пример 2: Новая задача, сохраняем решение

```
Пользователь: "Hyprland не показывает второй монитор"
↓
Sysadmin:
  - Read ~/.claude/knowledge/sysadmin/hyprland/*.md
  - Grep solutions/ "monitor"
  - Не находит точного решения
  - WebSearch → находит решение на wiki.hyprland.org
  - Применяет → работает!
  - "Вызываю librarian для валидации"
↓
Librarian:
  - WebFetch wiki.hyprland.org для проверки
  - Проверяет актуальность
  - Одобряет
  - Write ~/.claude/knowledge/sysadmin/solutions/2025-10-21-hyprland-second-monitor.md
  - Write (append) в ~/.claude/knowledge/sysadmin/hyprland/monitors.md
```

### Пример 3: Устаревшее решение

```
Sysadmin пытается применить решение из knowledge/
↓
Решение не работает (команда изменилась)
↓
Sysadmin:
  - WebSearch → находит обновленное решение
  - Применяет → работает!
  - Вызывает librarian
↓
Librarian:
  - Валидирует новое решение
  - Edit существующий файл:
    - Добавляет "⚠️ Deprecated: old command (до версии X)"
    - Добавляет "✨ Updated 2025-10-21: new command (версия Y+)"
  - Сохраняет
```

---

## Готово!

Система настроена. Начинайте использовать sysadmin агента как обычно - он автоматически будет:
1. Проверять локальную базу перед поиском в интернете
2. Предлагать сохранять успешные решения
3. Постепенно накапливать знания

**Качество > количество**. Сохраняйте только проверенные решения.

---
Создано: 2025-10-21
