#!/bin/bash
# Инициализация базы знаний для проекта

set -e

PROJECT_ROOT="${1:-.}"
KNOWLEDGE_DIR="$PROJECT_ROOT/.claude/knowledge"

echo "🚀 Initializing project knowledge base in: $PROJECT_ROOT"

# Создать структуру
mkdir -p "$KNOWLEDGE_DIR"/{setup,docker,deployment,issues,solutions}

# Скопировать шаблон README
cat > "$KNOWLEDGE_DIR/README.md" << 'EOF'
# Project Knowledge Base

База знаний для этого проекта. Создана на основе шаблона из глобальной конфигурации.

## Структура

```
.claude/knowledge/
├── setup/       # Инструкции по настройке
├── docker/      # Docker конфигурации
├── deployment/  # Деплой
├── issues/      # Частые проблемы
└── solutions/   # Архив решений
```

## Как использовать

Агенты (sysadmin, librarian) автоматически:
1. Проверяют эту директорию при работе в проекте
2. Сохраняют project-specific решения сюда
3. Используют глобальную базу для системных вопросов

## Workflow

- **При добавлении решения**: Коммитить в git вместе с кодом
- **При получении обновлений**: `git pull` синхронизирует знания команды

---
Создано: $(date +%Y-%m-%d)
Проект: $(basename "$PWD")
EOF

# Создать базовые файлы
cat > "$KNOWLEDGE_DIR/setup/README.md" << 'EOF'
# Project Setup

Инструкции по первоначальной настройке проекта.

## Добавьте сюда:
- Установка зависимостей
- Конфигурация окружения
- Инициализация БД
- Необходимые инструменты
EOF

cat > "$KNOWLEDGE_DIR/solutions/README.md" << 'EOF'
# Solutions Archive

Хронологический архив решений проблем в этом проекте.

Формат файлов: `YYYY-MM-DD-description.md`

Автоматически пополняется при успешном решении задач.
EOF

# Обновить .gitignore проекта
if [ -f "$PROJECT_ROOT/.gitignore" ]; then
    if ! grep -q ".claude/knowledge/" "$PROJECT_ROOT/.gitignore" 2>/dev/null; then
        echo "" >> "$PROJECT_ROOT/.gitignore"
        echo "# Claude Code - ignore session files but keep knowledge base" >> "$PROJECT_ROOT/.gitignore"
        echo ".claude/todos/" >> "$PROJECT_ROOT/.gitignore"
        echo ".claude/debug/" >> "$PROJECT_ROOT/.gitignore"
        echo ".claude/shell-snapshots/" >> "$PROJECT_ROOT/.gitignore"
        echo ".claude/projects/" >> "$PROJECT_ROOT/.gitignore"
        echo ".claude/file-history/" >> "$PROJECT_ROOT/.gitignore"
        echo ".claude/history.jsonl" >> "$PROJECT_ROOT/.gitignore"
        echo "" >> "$PROJECT_ROOT/.gitignore"
        echo "# Keep knowledge base and agents" >> "$PROJECT_ROOT/.gitignore"
        echo "!.claude/knowledge/" >> "$PROJECT_ROOT/.gitignore"
        echo "!.claude/agents/" >> "$PROJECT_ROOT/.gitignore"
    fi
fi

echo "✅ Project knowledge base initialized!"
echo ""
echo "📁 Created:"
echo "   $KNOWLEDGE_DIR/setup/"
echo "   $KNOWLEDGE_DIR/docker/"
echo "   $KNOWLEDGE_DIR/deployment/"
echo "   $KNOWLEDGE_DIR/issues/"
echo "   $KNOWLEDGE_DIR/solutions/"
echo ""
echo "📝 Next steps:"
echo "   1. Add project-specific knowledge to .claude/knowledge/"
echo "   2. Commit to git: git add .claude/ && git commit -m 'Initialize project knowledge base'"
echo "   3. Agents will automatically use this knowledge when working in this project"
