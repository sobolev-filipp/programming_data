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

## 📱 MAUI (Блоки 2–3) — подробно

Приложения с окном (кнопки, поля, списки) для Windows/Android/Mac/iOS из **одного** кода. Ниже — всё по шагам, с упором на Mac (у преподавателя), где капризов больше.

### 1. Установить MAUI workload (один раз)

**🪟 Windows:** в **Visual Studio Installer** отметить workload **«Разработка мобильных приложений на .NET»** (*.NET Multi-platform App UI development*). Без него не будет шаблона проекта.

**🍎 Mac:**
```bash
sudo dotnet workload install maui          # сам MAUI (все платформы Apple + Android)
xcode-select --install                     # инструменты командной строки Xcode
dotnet workload list                       # проверка: ждём maui-*, android, ios, maccatalyst
```
Плюс установи **Xcode** из App Store (нужен для сборки под Mac/iPhone, не только command-line tools).

### 2. Создать проект

| | Как |
|--|-----|
| 🪟 Windows | **Создание проекта** → шаблон **.NET MAUI App** → имя → **.NET 10.0** → Создать |
| 🍎 Mac | `dotnet new maui -o MyApp` → `cd MyApp` → `code .` (открыть в VS Code) |

### 3. Структура проекта (что важно)

- **`MainPage.xaml`** — внешность главного экрана (XAML);
- **`MainPage.xaml.cs`** — логика экрана (C#, code-behind);
- `App.xaml` / `App.xaml.cs` — глобальные ресурсы (цвета, стили), старт;
- `AppShell.xaml` — «оболочка»: какая страница открывается первой;
- `MauiProgram.cs` — «мотор» приложения (регистрация шрифтов, сервисов);
- `Platforms/` — платформенные файлы (Android/iOS/MacCatalyst/Windows); `Resources/` — картинки (`Resources/Images`), шрифты, цвета, иконка.
- **`ИмяПроекта.csproj`** — файл настроек проекта (платформы, версия, id) — см. §6.

90% работы — в `MainPage.xaml` и `MainPage.xaml.cs`.

### 4. Запуск — подробно

**🪟 Windows (ученики):**
1. Вверху рядом с ▶ выбери платформу **Windows Machine** (самый быстрый способ проверки).
2. Нажми **▶ (Start)** / **F5**. Первый запуск долгий (до пары минут) — нормально.
3. Для телефона: **Android** — выбрать эмулятор в «Диспетчере устройств Android» (Android Device Manager), затем ▶. Эмулятор ставится через Visual Studio Installer (компонент Android SDK/Emulator).

**🍎 Mac (преподаватель):**
```bash
# запуск как МАКОВОГО окна (быстрее всего проверять):
dotnet build -t:Run -f net10.0-maccatalyst

# запуск на СИМУЛЯТОРЕ iPhone (нужен Xcode + симулятор):
dotnet build -t:Run -f net10.0-ios
```
- `-t:Run` — собрать **и сразу запустить**;
- `-f net10.0-maccatalyst` — под какую платформу (маковое окно); `net10.0-ios` — айфон-симулятор.
- Первый запуск долгий — подтягиваются пакеты и идёт сборка через Xcode.

> 💡 Если проект многоплатформенный (несколько `TargetFrameworks`), флаг `-f` **обязателен** — он говорит, под что собирать. Без него будет ошибка «нужно указать один TargetFramework».

### 5. 🔄 Обновления (ОБЯЗАТЕЛЬНО после выхода новых macOS / iOS / Xcode)

> ⚠️ **Частая боль на Mac:** вышла новая версия **macOS / iOS**, обновился **Xcode** — и `dotnet build` начинает сыпать ошибками. Причина почти всегда одна: **Xcode и .NET-workload'ы рассинхронизировались** с новой системой. Лечение — обновить обе стороны. Делай по порядку:

```bash
# 1. Обнови Xcode из App Store до версии под новую macOS/iOS. Затем:
sudo xcode-select -s /Applications/Xcode.app   # указать .NET на (новый) Xcode
sudo xcodebuild -license accept                # принять лицензию Xcode (после обновления обязательно)
xcodebuild -runFirstLaunch                     # доустановить компоненты Xcode

# 2. Обнови .NET SDK (если вышел новый — с dotnet.microsoft.com), затем workload'ы MAUI:
dotnet workload update                         # ← главное: подтягивает workload'ы под новый SDK/ОС

# 3. Если всё ещё ругается — почини/переустанови workload:
sudo dotnet workload repair
# или начисто:  sudo dotnet workload install maui

# 4. Почисти проект и пересобери:
rm -rf bin obj
dotnet restore
dotnet build -t:Run -f net10.0-maccatalyst
```

Проверки состояния:
```bash
xcode-select -p         # должен показать путь к Xcode (напр. /Applications/Xcode.app/Contents/Developer)
dotnet --version        # версия SDK
dotnet workload list    # установленные workload'ы и их версии
```

> 💡 **Правило:** после каждого крупного обновления Apple — сначала обнови **Xcode**, прими лицензию, потом `dotnet workload update`, потом `rm -rf bin obj` + пересборка. Это снимает 90% «вдруг перестало собираться».

### 5а. ⚠️ Главное правило: Xcode и MAUI-workload должны совпадать по версии

> Это **самая частая причина** «вдруг не собирается под Mac/iPhone», и `dotnet workload update` её **не всегда** лечит. Разберём отдельно.

Каждый MAUI-workload собран под **конкретную** версию Xcode. Несовпадение в **любую** сторону = ошибка сборки:

```
This version of .NET for MacCatalyst (26.2.xxxxx) requires Xcode 26.2.
The current version of Xcode is 27.0. Either install Xcode 26.2,
or use a different version of .NET for MacCatalyst.
```

Читается так: *«установленный workload хочет Xcode 26.2, а у тебя стоит 27.0 — почини одно из двух»*. Бывает и наоборот (workload новее установленного Xcode).

**Почему `dotnet workload update` иногда не помогает.** Версия workload'а привязана к **ветке SDK**: `10.0.1xx`, `10.0.4xx` и т.д. `workload update` подтягивает новое только **внутри текущей ветки**. Поддержка свежего Xcode может появиться лишь в **более новой ветке SDK** — тогда сначала надо обновить сам **.NET SDK**.

**Как подобрать правильную связку (Xcode → .NET):**
1. Узнай точную версию своего Xcode: `xcodebuild -version` (например `Xcode 27.0`).
2. Посмотри таблицу соответствия: [whichversionofxcodeformaui.com](https://whichversionofxcodeformaui.com/) и релизы [dotnet/macios](https://github.com/dotnet/macios/releases) — там указано, какой **SDK** и какой **набор workload'ов** (`--version X.Y.Z.W`) идут под твой Xcode.
3. Поставь нужную ветку SDK (если надо) и **закрепи** workload под свой Xcode по точной версии:

```bash
sudo dotnet workload install maui --version 10.0.401.1   # пример: набор под Xcode 27.0
dotnet workload list                                     # проверь: MacCatalyst/iOS = нужная версия
```

> `--version` ставит **весь набор** workload'ов фиксированной версии — это и есть способ «прицелиться» ровно в свой Xcode, а не хватать «самое новое» (которое может требовать Xcode ещё новее).

**📌 Рабочий пример (Xcode 27.0, ноябрь 2026):**
```bash
# было: SDK 10.0.101 + workload под Xcode 26.2 → ошибка выше
# 1) скачать и поставить .NET 10 SDK ветки 10.0.4xx:
open "https://dotnet.microsoft.com/download/dotnet/10.0"
# 2) workload ровно под Xcode 27.0:
sudo dotnet workload install maui --version 10.0.401.1
# 3) проверка и чистая пересборка:
dotnet workload list
rm -rf bin obj && dotnet build -t:Run -f net10.0-maccatalyst
```
> Соответствия на тот момент: Xcode **27.0** ↔ SDK `10.0.401`/`10.0.402`, workload `10.0.401.1`. Для Xcode **27.1** — workload `10.0.402.1`. Xcode **27.2** на .NET 10 (MAUI) ещё **не** поддерживался — для него ждём MAUI 11. Поэтому гнаться за «самым новым Xcode» не стоит: держи Xcode той версии, под которую уже есть workload.

> 🐞 **Отдельная засада после Xcode 27:** даже если сборка прошла, приложение может **падать при запуске** (iOS/macOS 27) — из-за нового UIKit Scene Lifecycle. Проекты, созданные **старым** шаблоном, этого не знают. Лечение: пересоздать проект свежим `dotnet new maui` (новый шаблон уже учитывает), либо добавить `SceneDelegate` + запись `UIApplicationSceneManifest` (см. [.NET Blog: UIKit scene lifecycle](https://devblogs.microsoft.com/dotnet/migrate-dotnet-maui-apps-uikit-scene-lifecycle/)).

### 6. 🐞 Ошибки при запуске — таблица

| Симптом / сообщение | Причина | Как починить |
|---------------------|---------|--------------|
| `Xcode.app ... could not be found` / `xcodebuild exited with code 1` (Mac) | .NET не видит Xcode / не настроен | `sudo xcode-select -s /Applications/Xcode.app`, затем `sudo xcodebuild -license accept`, `xcodebuild -runFirstLaunch` |
| `You must accept the license agreement` (Mac) | не принята лицензия Xcode (часто после обновления) | `sudo xcodebuild -license accept` |
| сборка сломалась **после обновления macOS/iOS** | устарел Xcode / рассинхрон workload | см. §5 «Обновления»: обнови Xcode + `dotnet workload update` |
| `requires Xcode 26.2. The current version of Xcode is 27.0` (или любые другие несовпадающие номера) | **версия workload не совпала с версией Xcode** (в любую сторону) | см. §5а: поставь SDK/`workload` ровно под свой Xcode — `sudo dotnet workload install maui --version X.Y.Z.W` |
| `open -a … .app ... exited with code 1` / `MSB3073` при `-t:Run` | `.app` **не собрался** (ошибку спрятала инкрементальная сборка), а `open` пытается запустить несуществующее | сделай чистую сборку `rm -rf bin obj && dotnet build -f net10.0-maccatalyst` — увидишь настоящую причину (часто §5а) |
| приложение собралось, но **падает сразу при запуске** (Xcode/iOS 27) | старый шаблон без UIKit Scene Lifecycle | пересоздай `dotnet new maui` или добавь `SceneDelegate` (§5а, засада после Xcode 27) |
| `workload ... not installed` / `NETSDK1147` | нет нужного workload после обновления SDK | `dotnet workload update`, затем `dotnet workload install maui` |
| `current .NET SDK does not support targeting ...` | версия SDK не совпала с таргетом | обнови .NET SDK и `dotnet workload update` |
| `Specify a single TargetFramework` | в проекте несколько платформ, не указан `-f` | добавь флаг, напр. `-f net10.0-maccatalyst` |
| `Unable to find a valid ... simulator` / нет симулятора iPhone | не установлен симулятор iOS | Xcode → **Settings → Platforms** → скачать iOS Simulator |
| первый запуск «завис» на пару минут | нормальная первая сборка (тянет пакеты) | подождать, **не** прерывать |
| `NU1101` / `unable to load the service index` | нет интернета при восстановлении пакетов | проверь сеть → `dotnet restore` |
| бесконечные непонятные ошибки после правок | «грязные» bin/obj/кэш | `rm -rf bin obj`, `dotnet nuget locals all --clear`, `sudo dotnet workload repair`, пересобрать |
| (🪟 Windows) нет шаблона **.NET MAUI App** | не поставлен workload | Visual Studio Installer → **Modify** → отметить **.NET MAUI** |
| (🪟 Windows) приложение не стартует на телефоне | не выбран/не создан эмулятор Android | Android Device Manager → создать устройство → выбрать его у ▶ |

### 7. Настройки `.csproj` — где писать и что значат

**Где:** файл **`ИмяПроекта.csproj`** в корне проекта (в VS Code виден в дереве; в Visual Studio — двойной клик по имени проекта). Это обычный XML. Все настройки — внутри блока **`<PropertyGroup>`**.

Главные строки и что они значат:
- **`<TargetFrameworks>`** — список платформ, под которые собираем (через `;`). Именно отсюда берутся имена для флага `-f`.
- **`<OutputType>Exe</OutputType>`** — это приложение (а не библиотека).
- **`<UseMaui>true</UseMaui>`** — включает MAUI.
- **`<ApplicationTitle>`** — имя приложения под иконкой; **`<ApplicationId>`** — уникальный id (как `com.school.myapp`); **`<ApplicationVersion>`** — номер сборки.
- **`<SupportedOSPlatformVersion ...>`** — минимальная версия каждой ОС.

<details>
<summary>📄 <b>Полный пример <code>.csproj</code> MAUI-приложения</b> (кликни)</summary>

```xml
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <!-- платформы: имена отсюда идут во флаг -f при запуске -->
    <TargetFrameworks>net10.0-android;net10.0-ios;net10.0-maccatalyst</TargetFrameworks>
    <!-- Windows добавляем ТОЛЬКО когда собираем на Windows -->
    <TargetFrameworks Condition="$([MSBuild]::IsOSPlatform('windows'))">$(TargetFrameworks);net10.0-windows10.0.19041.0</TargetFrameworks>

    <OutputType>Exe</OutputType>
    <RootNamespace>MyApp</RootNamespace>
    <UseMaui>true</UseMaui>
    <SingleProject>true</SingleProject>
    <ImplicitUsings>enable</ImplicitUsings>
    <Nullable>enable</Nullable>

    <!-- как приложение называется и опознаётся -->
    <ApplicationTitle>MyApp</ApplicationTitle>
    <ApplicationId>com.school.myapp</ApplicationId>
    <ApplicationVersion>1</ApplicationVersion>

    <!-- минимальные версии ОС -->
    <SupportedOSPlatformVersion Condition="$([MSBuild]::GetTargetPlatformIdentifier('$(TargetFramework)')) == 'ios'">15.0</SupportedOSPlatformVersion>
    <SupportedOSPlatformVersion Condition="$([MSBuild]::GetTargetPlatformIdentifier('$(TargetFramework)')) == 'maccatalyst'">15.0</SupportedOSPlatformVersion>
    <SupportedOSPlatformVersion Condition="$([MSBuild]::GetTargetPlatformIdentifier('$(TargetFramework)')) == 'android'">21.0</SupportedOSPlatformVersion>
    <SupportedOSPlatformVersion Condition="$([MSBuild]::GetTargetPlatformIdentifier('$(TargetFramework)')) == 'windows'">10.0.17763.0</SupportedOSPlatformVersion>
  </PropertyGroup>

</Project>
```
> Обычно `.csproj` создаётся шаблоном **сам** и трогать его не нужно. Правим, только если хотим убрать лишние платформы (например оставить один `net10.0-maccatalyst`, чтобы быстрее собиралось на Mac) или поменять имя/id приложения.
</details>

### 8. Как создать новую страницу (экран)

Приложение может иметь несколько экранов. Каждый экран = **два файла**: `Имя.xaml` (внешность) + `Имя.xaml.cs` (логика) — как `MainPage`.

**🪟 Windows (Visual Studio):** правый клик по проекту → **Add → New Item → .NET MAUI ContentPage (XAML)** → имя, напр. `SecondPage` → Add. Создадутся оба файла.

**🍎 Mac (VS Code):** проще всего — поставить шаблоны и выполнить команду:
```bash
dotnet new install VijayAnand.MauiTemplates    # один раз
dotnet new maui-page -n SecondPage             # создаст SecondPage.xaml + .cs
```
Или **вручную** создать два файла (см. полный пример ниже).

<details>
<summary>📄 <b>Полный код новой страницы</b> <code>SecondPage.xaml</code> + <code>SecondPage.xaml.cs</code> (кликни)</summary>

**`SecondPage.xaml`:**
```xml
<?xml version="1.0" encoding="utf-8" ?>
<ContentPage xmlns="http://schemas.microsoft.com/dotnet/2021/maui"
             xmlns:x="http://schemas.microsoft.com/winfx/2009/xaml"
             x:Class="MyApp.SecondPage"
             Title="Вторая страница">
    <VerticalStackLayout Padding="24" Spacing="16" VerticalOptions="Center">
        <Label Text="Это вторая страница 👋" FontSize="24" HorizontalOptions="Center" />
        <Button Text="Назад" Clicked="OnBackClicked" />
    </VerticalStackLayout>
</ContentPage>
```

**`SecondPage.xaml.cs`:**
```csharp
namespace MyApp;   // ← имя как у проекта (см. RootNamespace в .csproj)

public partial class SecondPage : ContentPage
{
    public SecondPage()
    {
        InitializeComponent();
    }

    private async void OnBackClicked(object? sender, EventArgs e)
    {
        await Navigation.PopAsync();   // вернуться на предыдущую страницу
    }
}
```

**Как открыть её с первой страницы** (из `MainPage.xaml.cs`, по кнопке):
```csharp
private async void OnOpenSecond(object? sender, EventArgs e)
{
    await Navigation.PushAsync(new SecondPage());   // показать вторую страницу
}
```
> ⚠️ `x:Class` в XAML и `namespace` в `.cs` должны совпадать с именем проекта (`MyApp` в примере). Подробно про навигацию между страницами — в уроке 13 блока 2.
</details>

### 9. Полный код примера (минимальное рабочее приложение «Счётчик»)

<details>
<summary>📄 <b><code>MainPage.xaml</code> + <code>MainPage.xaml.cs</code></b> (кликни)</summary>

**`MainPage.xaml`:**
```xml
<?xml version="1.0" encoding="utf-8" ?>
<ContentPage xmlns="http://schemas.microsoft.com/dotnet/2021/maui"
             xmlns:x="http://schemas.microsoft.com/winfx/2009/xaml"
             x:Class="MyApp.MainPage">
    <VerticalStackLayout Padding="30" Spacing="20" VerticalOptions="Center">
        <Label Text="Мой счётчик" FontSize="28" HorizontalOptions="Center" />
        <Label x:Name="CountLabel" Text="0" FontSize="60" HorizontalOptions="Center" />
        <Button Text="+1" Clicked="OnPlusClicked" />
        <Button Text="Сброс" Clicked="OnResetClicked" />
    </VerticalStackLayout>
</ContentPage>
```

**`MainPage.xaml.cs`:**
```csharp
namespace MyApp;

public partial class MainPage : ContentPage
{
    int count = 0;

    public MainPage()
    {
        InitializeComponent();
    }

    private void OnPlusClicked(object? sender, EventArgs e)
    {
        count++;
        CountLabel.Text = count.ToString();
    }

    private void OnResetClicked(object? sender, EventArgs e)
    {
        count = 0;
        CountLabel.Text = count.ToString();
    }
}
```
</details>

### 10. Если «капризничает» (быстрая чистка)
```bash
rm -rf bin obj                       # удалить служебные папки сборки
dotnet restore                       # восстановить пакеты
dotnet build -t:Rebuild              # пересобрать с нуля
```
Не помогло → раздел §5 «Обновления» (обнови Xcode + `dotnet workload update` + `workload repair`).

> На Windows (ученики) многое делается кнопками Visual Studio: **▶ Run**, менеджер NuGet, добавление страницы через **Add → New Item**.

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
