# 📦 Материалы урока 1 — проект «Счётчик»

Здесь лежат **два файла**, которые ученик правит в этом уроке:

- [`MainPage.xaml`](MainPage.xaml) — внешность экрана (заголовок, число, три кнопки);
- [`MainPage.xaml.cs`](MainPage.xaml.cs) — логика (переменная `count` и три обработчика).

## Как этим пользоваться

Весь MAUI-проект целиком в репозиторий **не кладём** (он большой, папки `bin/obj/Platforms` генерируются сами). Вместо этого:

1. Создай новый MAUI-проект с именем **`CounterApp`**:
   - **Windows (Visual Studio):** Создание проекта → шаблон **.NET MAUI App** → имя `CounterApp` → .NET 10.0.
   - **Mac (VS Code):** `dotnet new maui -o CounterApp`
2. **Замени** содержимое сгенерированных `MainPage.xaml` и `MainPage.xaml.cs` на файлы отсюда.
3. Запусти:
   - **Windows:** платформа **Windows Machine** → ▶ (F5).
   - **Mac:** `dotnet build -t:Run -f net10.0-maccatalyst`

> ⚠️ **Важно про имя проекта.** В `MainPage.xaml.cs` первая строка — `namespace CounterApp;`, а в `MainPage.xaml` — `x:Class="CounterApp.MainPage"`. Слово `CounterApp` должно **совпадать с именем твоего проекта**. Если назвал проект иначе — поменяй `CounterApp` на своё имя в обоих файлах.

## Проверено

Код собран на **.NET 10** (`net10.0-windows`) — сборка успешна, 0 ошибок, 0 предупреждений.
