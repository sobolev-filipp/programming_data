# 🛠 Среда разработки: Visual Studio (Windows) и VS Code (Mac)

> Общий справочник для всего курса. Дети работают в **Visual Studio на Windows**; преподаватель на Mac — в **VS Code + `dotnet` CLI**. В уроках даётся короткий блок + ссылка сюда.
> Платформа курса — **.NET 10**.

---

## 0. Установить .NET 10 SDK (нужно на любой ОС)

Скачать: [dotnet.microsoft.com/download](https://dotnet.microsoft.com/download) → **.NET 10 SDK**.

Проверить, что установлен (в терминале / командной строке):
```bash
dotnet --version
```
Должно показать номер вида `10.0.xxx`.

---

## 🪟 Windows — Visual Studio 2022 (для учеников)

### Установка
1. Скачать **Visual Studio 2022 Community** (бесплатная): [visualstudio.microsoft.com](https://visualstudio.microsoft.com/).
2. В установщике отметить рабочие нагрузки (workloads):
   - **«Разработка классических приложений .NET»** (.NET desktop development) — для консоли (Блок 1).
   - **«Разработка мобильных приложений .NET»** (.NET Multi-platform App UI development) — для MAUI (Блоки 2–3).

### Консольное приложение (Блок 1)
1. **Create a new project** → шаблон **Console App (C#)** → **Next**.
2. Имя проекта → **Next** → Framework **.NET 10.0** → **Create**.
3. Код — в файле **`Program.cs`**.
4. Запуск: зелёная кнопка **▶ (Start)** или **F5**. Чтобы окно не закрылось сразу — **Ctrl+F5**.

### Полезные клавиши
| Клавиши | Действие |
|---------|----------|
| F5 | запуск (с отладкой) |
| Ctrl+F5 | запуск без отладки (окно остаётся) |
| Ctrl+. | быстрые исправления |
| Ctrl+K, Ctrl+D | форматировать код |
| Ctrl+/ | комментировать строку |

---

## 🍎 Mac — VS Code + dotnet CLI (для преподавателя)

Visual Studio для Mac закрыт, поэтому на Mac работаем в **VS Code** через терминал.

### Установка
1. **VS Code**: [code.visualstudio.com](https://code.visualstudio.com/).
2. Расширение **C# Dev Kit** (Marketplace внутри VS Code) — подсветка, запуск, отладка C#.
3. **.NET 10 SDK** (см. раздел 0).

### Консольное приложение — три главные команды
```bash
dotnet new console      # создать новое консольное приложение
dotnet restore          # пересобрать/восстановить файлы проекта
dotnet run              # скомпилировать и запустить
```
- `dotnet new console` создаёт проект с файлом `Program.cs`.
- `dotnet restore` подтягивает зависимости и пересобирает служебные файлы (полезно, если проект «не видит» пакеты).
- `dotnet run` компилирует и запускает.

> Можно создать проект в отдельной папке: `dotnet new console -o MyApp`, затем `cd MyApp` и `dotnet run`.

### Если что-то сломалось (чистка)
```bash
rm -rf bin obj          # удалить служебные папки сборки
dotnet restore          # и пересобрать заново
dotnet clean            # очистить кэш сборки
dotnet nuget locals all --clear   # очистить кэш пакетов NuGet
```

---

## 📱 MAUI (Блоки 2–3) — забегая вперёд

Полные инструкции будут в уроках MAUI; здесь — команды для Mac под рукой.

Установить MAUI workload:
```bash
dotnet workload install maui
```

Запустить MAUI-приложение на Mac (MacCatalyst):
```bash
dotnet build -t:Run -f net10.0-maccatalyst
```

Настройки проекта (`.csproj`) для сборки под нужную платформу:
```xml
<TargetFramework>net10.0-maccatalyst</TargetFramework>
<RuntimeIdentifiers>maccatalyst-arm64</RuntimeIdentifiers>
<TargetFrameworks Condition="$([MSBuild]::IsOSPlatform('windows'))">$(TargetFrameworks);net10.0-windows10.0.19041.0</TargetFrameworks>
```

Создать вторую страницу (нужен шаблон `VijayAnand.MauiTemplates`):
```bash
dotnet new install VijayAnand.MauiTemplates
dotnet new maui-page -n MyPage -o Pages
```

> На Windows (ученики) всё это делается кнопками в Visual Studio: **▶ Run**, менеджер NuGet, добавление страницы через **Add → New Item**.

---

## 🗄 SQLite (Блок 3) — забегая вперёд

Добавить пакет базы данных:
```bash
dotnet add package sqlite-net-pcl
```
На Windows — через **Manage NuGet Packages** в Visual Studio (искать `sqlite-net-pcl`).

---

## ❓ Частые вопросы

- **`dotnet` не найден** → не установлен .NET SDK или не перезапущен терминал. Проверь `dotnet --version`.
- **Нужна ли Visual Studio на Mac?** Нет, её больше нет — на Mac используем VS Code + `dotnet`.
- **Жёлтые подчёркивания в коде** → это предупреждения (warnings), не ошибки. Программа запускается. Красное — ошибка, надо чинить.
- **Окно консоли закрывается мгновенно (Windows)** → запускай через **Ctrl+F5**.
