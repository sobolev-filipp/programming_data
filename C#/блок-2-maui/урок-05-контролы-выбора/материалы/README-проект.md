# 📦 Материалы урока 5 — проект «Собери пиццу»

Здесь **два файла**, которые ученик собирает в этом уроке:

- [`MainPage.xaml`](MainPage.xaml) — внешность: контролы выбора (`Picker`, `Stepper`, `Switch`, `Slider`, `CheckBox`, `DatePicker`) + кнопка и метка итога;
- [`MainPage.xaml.cs`](MainPage.xaml.cs) — логика: чтение выбранного (`SelectedIndex`/`IsToggled`/`Value`/`IsChecked`/`Date`), живые метки (`ValueChanged`), подсчёт цены.

## Как этим пользоваться

Весь MAUI-проект в репозиторий **не кладём** (папки `bin/obj/Platforms` генерируются сами). Вместо этого:

1. Создай новый MAUI-проект с именем **`PizzaApp`**:
   - **Windows (Visual Studio):** Создание проекта → шаблон **.NET MAUI App** → имя `PizzaApp` → .NET 10.0.
   - **Mac (VS Code):** `dotnet new maui -o PizzaApp`
2. **Замени** содержимое сгенерированных `MainPage.xaml` и `MainPage.xaml.cs` на файлы отсюда.
3. Запусти:
   - **Windows:** платформа **Windows Machine** → ▶ (F5).
   - **Mac:** `dotnet build -t:Run -f net10.0-maccatalyst`

> ⚠️ **Важно про имя проекта.** В `MainPage.xaml.cs` первая строка — `namespace PizzaApp;`, а в `MainPage.xaml` — `x:Class="PizzaApp.MainPage"`. Слово `PizzaApp` должно **совпадать с именем твоего проекта**. Назвал иначе — поменяй `PizzaApp` на своё имя в обоих файлах.

## Что умеет

Выбор размера (`Picker`), количества (`Stepper`, живая метка), сыра (`Switch`), остроты (`Slider`, живая метка), доставки (`CheckBox`), даты (`DatePicker`). Кнопка «Оформить» проверяет, что размер выбран (`SelectedIndex != -1`), и считает итоговую цену.

## Проверено

Код собран на **.NET 10** (`net10.0-windows`) — сборка успешна, **0 ошибок, 0 предупреждений**. Арифметика проверена прогоном: Средняя ×2 + сыр + доставка = 1150 ₽; Большая ×1 = 600 ₽.
