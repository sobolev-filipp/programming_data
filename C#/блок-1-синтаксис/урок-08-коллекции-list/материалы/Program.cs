// Урок 8 — Проект «Инвентарь героя»
// List<string> — рюкзак (растущий список предметов)
// Dictionary<string,int> — счётчик: сколько каждого предмета
// Имена: методы PascalCase, переменные camelCase (стиль C#)
// Запуск: Visual Studio ▶ (F5)  |  на Mac: dotnet run

List<string> backpack = new List<string>();

while (true)
{
    Console.ForegroundColor = ConsoleColor.Cyan;
    Console.WriteLine("\n=== ИНВЕНТАРЬ ГЕРОЯ ===");
    Console.ResetColor();
    Console.WriteLine("1 — добавить предмет");
    Console.WriteLine("2 — удалить предмет");
    Console.WriteLine("3 — показать рюкзак");
    Console.WriteLine("4 — сортировать по алфавиту");
    Console.WriteLine("5 — счётчик: сколько каждого");
    Console.WriteLine("0 — выход");
    Console.Write("Твой выбор: ");
    string choice = Console.ReadLine();

    if (choice == "1")
    {
        Console.Write("Что положить в рюкзак? ");
        string item = Console.ReadLine();
        backpack.Add(item);                                  // список растёт!
        Console.WriteLine($"+ {item}  (всего предметов: {backpack.Count})");
    }
    else if (choice == "2")
    {
        Console.Write("Что выбросить? ");
        string item = Console.ReadLine();
        if (backpack.Contains(item))                         // есть ли такой?
        {
            backpack.Remove(item);                           // удаляем ПЕРВЫЙ такой
            Console.WriteLine($"- {item} выброшен.");
        }
        else Console.WriteLine("Такого предмета нет.");
    }
    else if (choice == "3")
    {
        ShowBackpack(backpack);
    }
    else if (choice == "4")
    {
        backpack.Sort();                                     // по алфавиту
        Console.WriteLine("Рюкзак отсортирован.");
        ShowBackpack(backpack);
    }
    else if (choice == "5")
    {
        ShowCounts(backpack);
    }
    else if (choice == "0")
    {
        Console.WriteLine("Пока!");
        break;
    }
    else Console.WriteLine("Нет такого пункта меню.");
}

// ---------- методы ----------

// красиво печатает весь рюкзак с номерами
void ShowBackpack(List<string> items)
{
    if (items.Count == 0) { Console.WriteLine("Рюкзак пуст."); return; }
    Console.ForegroundColor = ConsoleColor.Yellow;
    Console.WriteLine($"В рюкзаке {items.Count} предмет(ов):");
    Console.ResetColor();
    for (int i = 0; i < items.Count; i++)
        Console.WriteLine($"  {i + 1}. {items[i]}");
}

// считает, сколько каждого предмета — через Dictionary
void ShowCounts(List<string> items)
{
    Dictionary<string, int> counts = new Dictionary<string, int>();
    foreach (string item in items)
    {
        if (counts.ContainsKey(item)) counts[item]++;        // уже был — +1
        else counts[item] = 1;                               // новый — ставим 1
    }
    Console.WriteLine("Счётчик добычи:");
    foreach (var pair in counts)
        Console.WriteLine($"  {pair.Key}: {pair.Value} шт.");
}
