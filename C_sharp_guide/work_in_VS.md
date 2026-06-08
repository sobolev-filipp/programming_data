<h1>Работа с C# в Visual Studio</h1>
<p>Тут будут основные команды которые небходимо использовать в терминале и
    настройки для работы с <b>проектом C# в Visual Studio</b></p>
<hr>
<br>

<h2>Требования</h2>
<ul>
    <li>Установленная <b>Visual Studio 2022</b> (или новее) с поддержкой <b>.NET
            MAUI</b></li>
    <li>Установленный <b>.NET 7 SDK</b> (или новее)</li>
    <li>Установленные расширения: <b>.NET MAUI</b>, <b>C# Dev Kit</b>,
        <b>C#</b>, <b>XAML Completion</b>, <b>XAML Styler</b>, <b>SQLite
            for Visual Studio Code</b></li>
</ul>
<br>

<h2 name="vs">Создание проекта в Visual Studio</h2>
<ol>
    <li>Открыть Visual Studio</li>
    <li>Создать новый проект</li>
    <li>Выбрать шаблон проекта <b>.NET MAUI App</b></li>
    <li>Нажать Далее</li>
    <li>Задать имя проекта и путь для сохранения</li>
    <li>Нажать Создать</li>
    <li>Дождаться создания проекта</li>
</ol>
<hr>
<br>
<h2>Основные терминальные команды в VS Code</h2>

<ul>
    <li><b>dotnet build</b> — сборка проекта</li>
    <li><b>dotnet run</b> — запуск проекта</li>
    <li><b>dotnet clean</b> — очистка проекта</li>
    <li><b>dotnet add package [имя_пакета]</b> — установка пакета NuGet</li>
    <li><b>dotnet restore</b> — восстановление зависимостей проекта</li>
    <li><b>dotnet new maui</b> — создание нового проекта MAUI</li>
</ul>

<br>
<h3>Терминальные команды для работы с MAUI</h3>

<h4>Проверка MAUI workload для .NET 10</h4>

```bash
sudo dotnet workload install maui --source https://api.nuget.org/v3/index.json
```

<h4>Установка Xcode последней версии</h4>

```bash
sudo xcode-select --install
```

<h4>Удаление папок bin и obj </h4>

```bash
dotnet clean
```

<h4>Очищение кэша сборки</h4>

```bash
dotnet build --no-incremental
```

<br>
<h3>Запуск проекта</h3>

<h4>Пересборка проекта</h4>

```bashbash
dotnet build -t:Rebuild
```

<h4>Запуск проекта на Windows</h4>

```bashbash
dotnet build -t:Run -f net10.0-windows10.0.19041.0
```

<h4>Запуск проекта на MacBook</h4>

```bashbash
dotnet build -t:Run -f net10.0-maccatalyst
```

<h4>Запуск проекта MAUI на iOS симуляторе</h4>

```bashbash
dotnet build -t:Run -f net10.0-ios /p:Platform=iPhoneSimulator
``` 

<h4>Запуск проекта MAUI на Android эмуляторе</h4>

```bashbash
dotnet build -t:Run -f net10.0-android /p:Platform=Android
``` 

<h4>Запуск конкретного симулятора</h4>

```bashbash
dotnet build -t:Run -f net10.0-ios -p:RuntimeIdentifier=ios-x64 -p:_DeviceName="iPhone 16 Pro"
```

<br>
<hr>
<h2>Настройка SQLite в VSCode</h2>

<ol>
    <li>Открыть проект в Visual Studio</li>
    <li>Открыть терминал в Visual Studio</li>
    <li>Выполнить команду для установки пакета SQLite:</li>

```bash
dotnet add package SQLite-net-pcl
```

<p>Или добавить в файл конфигурации:</p>

```xml
<ItemGroup>
    <PackageReference Include="Microsoft.Data.Sqlite" Version="10.0.0" />
</ItemGroup>
```

<hr>
<br>
<h2>Настройки проекта для MacBook</h2>
<ol>
    <li>Открыть проект в Visual Studio</li>
    <li>Перейти в свойства проекта</li>
    <li>Выбрать вкладку "iOS Bundle Signing"</li>
    <li>Настроить параметры подписи приложения (Apple ID, сертификаты и профили)</li>
    <li>Выбрать вкладку "iOS Build"</li>
    <li>Настроить параметры сборки (целевые версии iOS, архитектуры и т.д.)</li>
    <li>Сохранить изменения</li>
</ol>
<p>В файле конфигурации проекта (например, .csproj) можно настроить дополнительные параметры сборки и подписи:</p>

```xml
<TargetFramework>net10.0-maccatalyst</TargetFramework>
        <RuntimeIdentifiers>maccatalyst-arm64</RuntimeIdentifiers>
        <TargetFrameworks Condition="$([MSBuild]::IsOSPlatform('windows'))">$(TargetFrameworks);net10.0-windows10.0.19041.0</TargetFrameworks>
        <TargetFrameworks Condition="$([MSBuild]::IsOSPlatform('macos'))">$(TargetFrameworks);net10.0-maccatalyst</TargetFrameworks>
``` 

<hr>
<br>
<h2>Настройки проекта для Windows</h2>
<ol>
    <li>Открыть проект в Visual Studio</li>
    <li>Перейти в свойства проекта</li>
    <li>Выбрать вкладку "Windows Application Packaging"</li>
    <li>Настроить параметры упаковки приложения (пакетное имя, версия и т.д.)</li>
    <li>Выбрать вкладку "Build"</li>
    <li>Настроить параметры сборки (целевые версии Windows, архитектуры и т.д.)</li>
    <li>Сохранить изменения</li>
</ol>
<p>В файле конфигурации проекта (например, .csproj) можно настроить дополнительные параметры сборки и упаковки:</p> 

```xml
<TargetFramework>net10.0-windows10.0.19041.0</TargetFramework>
        <RuntimeIdentifiers>win10-x64;win10-x86</RuntimeIdentifiers>
        <TargetFrameworks Condition="$([MSBuild]::IsOSPlatform('windows'))">$(TargetFrameworks);net10.0-windows10.0.19041.0</TargetFrameworks>
        <TargetFrameworks Condition="$([MSBuild]::IsOSPlatform('macos'))">$(TargetFrameworks);net10.0-maccatalyst</TargetFrameworks>
```

<hr>
<br>
<h2>Настройки проекта IOS</h2>
<ol>
    <li>Открыть проект в Visual Studio</li>
    <li>Перейти в свойства проекта</li>
    <li>Выбрать вкладку "iOS Bundle Signing"</li>
    <li>Настроить параметры подписи приложения (Apple ID, сертификаты и профили)</li>
    <li>Выбрать вкладку "iOS Build"</li>
    <li>Настроить параметры сборки (целевые версии iOS, архитектуры и т.д.)</li>
    <li>Сохранить изменения</li>
</ol>
<p>В файле конфигурации проекта (например, .csproj) можно настроить дополнительные параметры сборки и подписи:</p>  

```xml
<TargetFramework>net10.0-ios</TargetFramework>
        <RuntimeIdentifiers>ios-arm64;ios-x64</RuntimeIdentifiers>
        <TargetFrameworks Condition="$([MSBuild]::IsOSPlatform('windows'))">$(TargetFrameworks);net10.0-windows10.0.19041.0</TargetFrameworks>
        <TargetFrameworks Condition="$([MSBuild]::IsOSPlatform('macos'))">$(TargetFrameworks);net10.0-maccatalyst;net10.0-ios</TargetFrameworks>
```

<hr>
<br>
<h2 name="debugging">Отладка проекта в Visual Studio</h2>
<ol>
    <li>Открыть проект в Visual Studio</li>
    <li>Выбрать конфигурацию сборки (Debug/Release)</li>
    <li>Выбрать целевую платформу (Windows, Android, iOS, MacCatalyst)</li>
    <li>Установить точки останова в коде</li>
    <li>Нажать F5 или выбрать "Запустить отладку"</li>
    <li>Использовать окна отладки для просмотра переменных, стека вызовов и
        выполнения команд</li>
</ol>

<hr>
<br>
<h2 name="resources">Полезные ресурсы</h2>
<ul>
    <li><a href="https://learn.microsoft.com/en-us/dotnet/maui/get-started/installation"
            target="_blank">Установка .NET MAUI</a></li>
    <li><a href="https://learn.microsoft.com/en-us/dotnet/maui/" target="_blank">Документация
            .NET MAUI</a></li>
    <li><a href="https://learn.microsoft.com/en-us/dotnet/csharp/" target="_blank">Документация
            C#</a></li>
    <li><a href="https://docs.microsoft.com/en-us/visualstudio/" target="_blank">Документация
            Visual Studio</a></li>
</ul>
