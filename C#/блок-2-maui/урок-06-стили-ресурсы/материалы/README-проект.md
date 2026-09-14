# Проект урока 6 — «Меню кафе ☕»

Готовые файлы приложения. В репозиторий кладём только **правимые** файлы — сам MAUI-проект создаётся из шаблона.

## Как собрать

1. Создай новый проект **.NET MAUI App** (или открой любой существующий).
   - Visual Studio: *Create a new project → .NET MAUI App*.
   - VS Code / Mac: `dotnet new maui -o CafeApp`.
2. Замени содержимое `MainPage.xaml` на [MainPage.xaml](MainPage.xaml).
3. Замени содержимое `MainPage.xaml.cs` на [MainPage.xaml.cs](MainPage.xaml.cs).
4. Картинка `dotnet_bot.png` уже лежит в `Resources/Images` в любом свежем проекте — менять ничего не нужно.
5. Запусти: **Windows Machine ▶** (VS) или `dotnet build -t:Run -f net10.0-maccatalyst` (Mac).

## Про namespace

В файлах указан `x:Class="CafeApp.MainPage"` и `namespace CafeApp`. Если твой проект называется иначе — замени `CafeApp` на имя своего проекта (оно же в `AppShell.xaml`/`App.xaml`).

## App.xaml — необязательно (глобальная тема)

Файл [App.xaml](App.xaml) показывает, как вынести цвета и неявный стиль `Label` в ресурсы **всего приложения** (Часть 6 урока). Это альтернатива страничным ресурсам: если перенесёшь ресурсы в `App.xaml`, их можно убрать из `<ContentPage.Resources>` в `MainPage.xaml` — оформление всё равно применится, потому что ресурсы стали глобальными. Для базового варианта проекта App.xaml трогать не обязательно — всё уже работает через ресурсы страницы.

## Что показывает проект

- **Ресурсы** (`<Color>`, `<x:Double>`) и `{StaticResource}`.
- **Явные стили** (`CardStyle`, `DishTitle`, `PriceTag`) и **неявный стиль** `Label`.
- **`Border`** как карточка (`StrokeShape="RoundRectangle 14"`).
- **`Image`** (`dotnet_bot.png`, `Aspect="AspectFit"`).
- Немного C#: `Stepper` + событие `ValueChanged` и кнопка (повтор урока 5).

Проверено сборкой `dotnet build -f net10.0-windows10.0.19041.0` — 0 ошибок, 0 предупреждений.
