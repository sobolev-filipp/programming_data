# Запуск проекта

Создай стандартный .NET MAUI App с именем `HeroCard` на локальном диске. На Windows выбери Windows Machine, на Mac — MacCatalyst. Сначала запусти шаблон. Затем замени MainPage.xaml и MainPage.xaml.cs файлами из этой папки, а hero.png скопируй в Resources/Images проекта. Если имя проекта другое, измени namespace и x:Class одинаково. Не заменяй csproj и Platforms.

На Mac: `dotnet new maui -n HeroCard`, затем в папке проекта `dotnet build -t:Run -f net10.0-maccatalyst` для установленного .NET 10.
