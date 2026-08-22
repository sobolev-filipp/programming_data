// Урок 9 — Проект «Дневник рекордов»
// File.* — сохраняем рекорды в файл (не теряются при перезапуске)
// try/catch + int.TryParse — защита от ошибок ввода и чтения
// Имена: методы PascalCase, переменные camelCase (стиль C#)
// Запуск: Visual Studio ▶ (F5)  |  на Mac: dotnet run

string fileName = "records.txt";   // файл появится рядом с программой

while (true)
{
    Console.ForegroundColor = ConsoleColor.Cyan;
    Console.WriteLine("\n=== ДНЕВНИК РЕКОРДОВ ===");
    Console.ResetColor();
    Console.WriteLine("1 — добавить рекорд");
    Console.WriteLine("2 — показать все рекорды");
    Console.WriteLine("3 — лучший результат");
    Console.WriteLine("0 — выход");
    Console.Write("Твой выбор: ");
    string choice = Console.ReadLine();

    if (choice == "1") AddRecord(fileName);
    else if (choice == "2") ShowRecords(fileName);
    else if (choice == "3") ShowBest(fileName);
    else if (choice == "0") { Console.WriteLine("Пока!"); break; }
    else Console.WriteLine("Нет такого пункта меню.");
}

// ---------- методы ----------

// добавляет строку "имя;очки" в файл, с защитой ввода
void AddRecord(string file)
{
    Console.Write("Имя игрока: ");
    string name = Console.ReadLine();

    Console.Write("Очки (число): ");
    string scoreText = Console.ReadLine();

    if (!int.TryParse(scoreText, out int score))   // защита: точно ли число?
    {
        Console.ForegroundColor = ConsoleColor.Red;
        Console.WriteLine("Очки должны быть числом! Запись отменена.");
        Console.ResetColor();
        return;
    }

    File.AppendAllText(file, $"{name};{score}\n");   // дописываем в конец
    Console.WriteLine($"Рекорд сохранён: {name} — {score}");
}

// показывает все рекорды из файла
void ShowRecords(string file)
{
    if (!File.Exists(file))                 // ещё ни одной записи?
    {
        Console.WriteLine("Пока нет ни одного рекорда.");
        return;
    }

    string[] lines = File.ReadAllLines(file);
    Console.ForegroundColor = ConsoleColor.Yellow;
    Console.WriteLine($"Всего рекордов: {lines.Length}");
    Console.ResetColor();
    foreach (string line in lines)
    {
        string[] parts = line.Split(';');   // "имя;очки" → ["имя","очки"]
        Console.WriteLine($"  {parts[0]}: {parts[1]} очков");
    }
}

// находит лучший результат (максимум очков)
void ShowBest(string file)
{
    if (!File.Exists(file)) { Console.WriteLine("Рекордов пока нет."); return; }

    string bestName = "-";
    int bestScore = -1;
    foreach (string line in File.ReadAllLines(file))
    {
        string[] parts = line.Split(';');
        if (int.TryParse(parts[1], out int score) && score > bestScore)
        {
            bestScore = score;
            bestName = parts[0];
        }
    }
    Console.WriteLine($"Лучший: {bestName} — {bestScore} очков");
}
