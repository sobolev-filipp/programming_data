# 📦 Материалы урока 2 — проект «Карточка профиля»

Здесь **два файла**, которые ученик собирает в этом уроке:

- [`MainPage.xaml`](MainPage.xaml) — внешность: вложенные стеки (шапка «аватар + имя/роль», строки информации, кнопки);
- [`MainPage.xaml.cs`](MainPage.xaml.cs) — логика (лайк-счётчик и изменение `Spacing` карточки из кода).

## Как этим пользоваться

Весь MAUI-проект в репозиторий **не кладём** (папки `bin/obj/Platforms` генерируются сами). Вместо этого:

1. Создай новый MAUI-проект с именем **`ProfileCard`**:
   - **Windows (Visual Studio):** Создание проекта → шаблон **.NET MAUI App** → имя `ProfileCard` → .NET 10.0.
   - **Mac (VS Code):** `dotnet new maui -o ProfileCard`
2. **Замени** содержимое сгенерированных `MainPage.xaml` и `MainPage.xaml.cs` на файлы отсюда.
3. Запусти:
   - **Windows:** платформа **Windows Machine** → ▶ (F5).
   - **Mac:** `dotnet build -t:Run -f net10.0-maccatalyst`

> ⚠️ **Важно про имя проекта.** В `MainPage.xaml.cs` первая строка — `namespace ProfileCard;`, а в `MainPage.xaml` — `x:Class="ProfileCard.MainPage"`. Слово `ProfileCard` должно **совпадать с именем твоего проекта**. Назвал иначе — поменяй `ProfileCard` на своё имя в обоих файлах.

## Проверено

Код собран на **.NET 10** (`net10.0-windows`) — сборка успешна, **0 ошибок, 0 предупреждений**.
