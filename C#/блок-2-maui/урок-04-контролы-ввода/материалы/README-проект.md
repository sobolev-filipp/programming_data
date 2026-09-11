# 📦 Материалы урока 4 — проект «Анкета / Профиль»

Здесь **два файла**, которые ученик собирает в этом уроке:

- [`MainPage.xaml`](MainPage.xaml) — внешность: поля `Entry`/`Editor`, кнопка, метка результата (внутри `ScrollView`);
- [`MainPage.xaml.cs`](MainPage.xaml.cs) — логика: чтение `.Text`, живое приветствие (`TextChanged`), проверка ввода (`IsNullOrWhiteSpace`, `int.TryParse`), сборка ответа.

## Как этим пользоваться

Весь MAUI-проект в репозиторий **не кладём** (папки `bin/obj/Platforms` генерируются сами). Вместо этого:

1. Создай новый MAUI-проект с именем **`ProfileApp`**:
   - **Windows (Visual Studio):** Создание проекта → шаблон **.NET MAUI App** → имя `ProfileApp` → .NET 10.0.
   - **Mac (VS Code):** `dotnet new maui -o ProfileApp`
2. **Замени** содержимое сгенерированных `MainPage.xaml` и `MainPage.xaml.cs` на файлы отсюда.
3. Запусти:
   - **Windows:** платформа **Windows Machine** → ▶ (F5).
   - **Mac:** `dotnet build -t:Run -f net10.0-maccatalyst`

> ⚠️ **Важно про имя проекта.** В `MainPage.xaml.cs` первая строка — `namespace ProfileApp;`, а в `MainPage.xaml` — `x:Class="ProfileApp.MainPage"`. Слово `ProfileApp` должно **совпадать с именем твоего проекта**. Назвал иначе — поменяй `ProfileApp` на своё имя в обоих файлах.

## Что умеет

Поле имени (`Entry`) с живым приветствием во время набора (`TextChanged`), поле возраста с цифровой клавиатурой (`Keyboard="Numeric"`), многострочное поле «о себе» (`Editor`). Кнопка «Готово» читает `.Text`, проверяет, что имя не пустое (`string.IsNullOrWhiteSpace`) и что возраст — число (`int.TryParse`), и собирает ответ через интерполяцию строк.

## Проверено

Код собран на **.NET 10** (`net10.0-windows`) — сборка успешна, **0 ошибок, 0 предупреждений**.
