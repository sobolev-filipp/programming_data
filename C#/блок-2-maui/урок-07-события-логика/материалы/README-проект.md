# Проект урока 7 — «Викторина 🎯»

Готовые файлы приложения. В репозиторий кладём только правимые файлы — проект создаётся из шаблона.

## Как собрать

1. Создай новый проект **.NET MAUI App** (или открой существующий).
   - Visual Studio: *Create a new project → .NET MAUI App*.
   - VS Code / Mac: `dotnet new maui -o QuizApp`.
2. Замени содержимое `MainPage.xaml` на [MainPage.xaml](MainPage.xaml).
3. Замени содержимое `MainPage.xaml.cs` на [MainPage.xaml.cs](MainPage.xaml.cs).
4. Запусти: **Windows Machine ▶** (VS) или `dotnet build -t:Run -f net10.0-maccatalyst` (Mac).

## Про namespace

В файлах указан `x:Class="QuizApp.MainPage"` и `namespace QuizApp`. Если твой проект называется иначе — замени `QuizApp` на имя своего проекта.

## Что показывает проект

- **`sender`** — один обработчик `OnAnswer` на три кнопки-ответа; нажатую узнаём через `sender is Button btn`.
- **`DisplayAlertAsync`** — всплывающее окно: сообщение о результате (`"OK"`) и подтверждение «Заново?» (`"Да","Нет"` → `bool`).
- **`async`/`await`** — чтобы дождаться закрытия окна.
- **`IsEnabled`** — гасим кнопки ответов после ответа.
- **`IsVisible`** — прячем/показываем кнопку «Пройти заново».

## ⚠️ Важно (.NET 10)

Метод всплывающего окна называется **`DisplayAlertAsync`** (со словом `Async`). Старое `DisplayAlert` ещё компилируется, но помечено устаревшим — используем новое имя.

Проверено сборкой `dotnet build -f net10.0-windows10.0.19041.0` — 0 ошибок, 0 предупреждений.
