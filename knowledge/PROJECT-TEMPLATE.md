# Project Knowledge Base Template

Этот файл - шаблон для создания базы знаний в проектах.

## Как использовать

При создании нового проекта:

```bash
cd /path/to/your/project
mkdir -p .claude/knowledge/{setup,docker,deployment,issues,solutions}
cp ~/.claude/knowledge/PROJECT-TEMPLATE.md .claude/knowledge/README.md
```

## Структура проектной базы знаний

```
.claude/knowledge/
├── README.md           # Описание базы знаний этого проекта
├── setup/             # Инструкции по первоначальной настройке
│   ├── local-dev.md   # Настройка локального окружения
│   ├── dependencies.md # Зависимости и их установка
│   └── database.md    # Настройка БД
├── docker/            # Docker конфигурации и решения
│   ├── dockerfile-notes.md
│   └── compose-tips.md
├── deployment/        # Деплой на продакшн/staging
│   ├── production.md
│   └── staging.md
├── issues/            # Частые проблемы проекта
│   └── [problem-name].md
└── solutions/         # Хронологический архив решений
    └── YYYY-MM-DD-description.md
```

## Адаптация под конкретный проект

### Для Django проекта

```
.claude/knowledge/
├── setup/
│   ├── django-settings.md
│   └── migrations.md
├── deployment/
│   ├── gunicorn.md
│   └── nginx.md
└── api/
    └── endpoints.md
```

### Для Node.js/React проекта

```
.claude/knowledge/
├── setup/
│   ├── npm-scripts.md
│   └── env-vars.md
├── deployment/
│   ├── build-process.md
│   └── ci-cd.md
└── components/
    └── architecture.md
```

### Для микросервисов

```
.claude/knowledge/
├── services/
│   ├── auth-service.md
│   ├── api-gateway.md
│   └── payment-service.md
├── docker/
│   └── orchestration.md
└── deployment/
    └── kubernetes.md
```

## Формат записей

Используйте тот же формат, что в глобальной базе знаний (см. `~/.claude/knowledge/METHODOLOGY.md`):

```markdown
# [Название решения/проблемы]

> Дата: YYYY-MM-DD
> Валидировано: librarian
> Проект: [название проекта]
> Теги: #tag1 #tag2

## Контекст
[Когда это применимо]

## Решение
\`\`\`bash
команды
\`\`\`

## Объяснение
[Почему это работает]

## Источники
- [Документация](url)
```

## Принципы

1. **Специфичность**: Только знания, относящиеся к ЭТОМУ проекту
2. **Версионирование**: Храните в git репозитории проекта
3. **Актуальность**: Обновляйте при изменении архитектуры
4. **Командная работа**: Доступно всей команде через git

## Workflow с глобальной базой

```
Проблема возникла
    ↓
Это проблема проекта или системы?
    ↓
┌──────────────────────┬──────────────────────┐
│ Проект               │ Система              │
├──────────────────────┼──────────────────────┤
│ ./.claude/knowledge/ │ ~/.claude/knowledge/ │
│ • Setup              │ • Linux commands     │
│ • Dependencies       │ • Hyprland config    │
│ • Project config     │ • System services    │
└──────────────────────┴──────────────────────┘
```

## Синхронизация с командой

Проектная база знаний хранится В репозитории проекта:

```bash
# .gitignore проекта - НЕ игнорировать .claude/knowledge/
!.claude/knowledge/

# Коммитить вместе с кодом
git add .claude/knowledge/
git commit -m "Add solution for Docker build issue"
git push
```

Команда получает знания через `git pull`!

---
Создано: 2025-10-21
