// Урок 12 — 🏆 ФИНАЛЬНЫЙ ПРОЕКТ «Медиатека» (каталог книг и фильмов)
// Соединяет весь блок 1:
//   классы + наследование/полиморфизм (MediaItem -> Book/Movie)  — уроки 10, 11
//   List<MediaItem> (растущий каталог)                            — урок 8
//   меню в цикле while(true) + методы                             — уроки 4, 7
//   сохранение/загрузка в файл + try/catch + int.TryParse         — урок 9
// Имена: классы/методы PascalCase, поля-переменные camelCase
// Запуск: Visual Studio ▶ (F5)  |  на Mac: dotnet run

string fileName = "media.txt";
List<MediaItem> catalog = new List<MediaItem>();

while (true)
{
    Console.ForegroundColor = ConsoleColor.Cyan;
    Console.WriteLine("\n=== МЕДИАТЕКА ===");
    Console.ResetColor();
    Console.WriteLine("1 — добавить книгу");
    Console.WriteLine("2 — добавить фильм");
    Console.WriteLine("3 — показать всё");
    Console.WriteLine("4 — найти по названию");
    Console.WriteLine("5 — сортировать по году");
    Console.WriteLine("6 — сохранить в файл");
    Console.WriteLine("7 — загрузить из файла");
    Console.WriteLine("0 — выход");
    Console.Write("Твой выбор: ");
    string choice = Console.ReadLine();

    if (choice == "1") AddBook(catalog);
    else if (choice == "2") AddMovie(catalog);
    else if (choice == "3") ShowAll(catalog);
    else if (choice == "4") Find(catalog);
    else if (choice == "5") { catalog = catalog.OrderBy(m => m.Year).ToList(); Console.WriteLine("Отсортировано по году."); }
    else if (choice == "6") Save(catalog, fileName);
    else if (choice == "7") catalog = Load(fileName);
    else if (choice == "0") { Console.WriteLine("Пока!"); break; }
    else Console.WriteLine("Нет такого пункта меню.");
}

// ---------- методы ----------

void AddBook(List<MediaItem> list)
{
    Console.Write("Название книги: ");
    string title = Console.ReadLine();
    Console.Write("Автор: ");
    string author = Console.ReadLine();
    int year = AskYear();
    list.Add(new Book(title, year, author));
    Console.WriteLine($"Книга добавлена (всего в каталоге: {list.Count})");
}

void AddMovie(List<MediaItem> list)
{
    Console.Write("Название фильма: ");
    string title = Console.ReadLine();
    Console.Write("Режиссёр: ");
    string director = Console.ReadLine();
    int year = AskYear();
    list.Add(new Movie(title, year, director));
    Console.WriteLine($"Фильм добавлен (всего в каталоге: {list.Count})");
}

// спрашивает год с защитой ввода (int.TryParse) — переспрашивает, пока не введут число
int AskYear()
{
    int year;
    Console.Write("Год: ");
    while (!int.TryParse(Console.ReadLine(), out year))
        Console.Write("Нужно число! Год: ");
    return year;
}

void ShowAll(List<MediaItem> list)
{
    if (list.Count == 0) { Console.WriteLine("Каталог пуст."); return; }
    Console.ForegroundColor = ConsoleColor.Yellow;
    Console.WriteLine($"В каталоге {list.Count} записей:");
    Console.ResetColor();
    foreach (MediaItem m in list)
        Console.WriteLine("  " + m.Info());   // полиморфизм: у книги и фильма свой Info()
}

void Find(List<MediaItem> list)
{
    Console.Write("Что ищем (часть названия): ");
    string query = Console.ReadLine().ToLower();
    bool found = false;
    foreach (MediaItem m in list)
        if (m.Title.ToLower().Contains(query))
        {
            Console.WriteLine("  " + m.Info());
            found = true;
        }
    if (!found) Console.WriteLine("Ничего не найдено.");
}

void Save(List<MediaItem> list, string file)
{
    List<string> lines = new List<string>();
    foreach (MediaItem m in list) lines.Add(m.ToLine());
    File.WriteAllLines(file, lines);
    Console.WriteLine($"Сохранено записей: {lines.Count}");
}

List<MediaItem> Load(string file)
{
    List<MediaItem> result = new List<MediaItem>();
    if (!File.Exists(file)) { Console.WriteLine("Файла ещё нет — сначала сохрани."); return result; }

    foreach (string line in File.ReadAllLines(file))
    {
        try
        {
            string[] p = line.Split(';');            // "BOOK;название;год;автор"
            if (!int.TryParse(p[2], out int year)) continue;   // кривой год — пропускаем
            if (p[0] == "BOOK") result.Add(new Book(p[1], year, p[3]));
            else if (p[0] == "MOVIE") result.Add(new Movie(p[1], year, p[3]));
        }
        catch (Exception)
        {
            Console.WriteLine($"Пропущена испорченная строка: {line}");
        }
    }
    Console.WriteLine($"Загружено записей: {result.Count}");
    return result;
}

// ---------- классы ----------

// РОДИТЕЛЬ: общее для книги и фильма
class MediaItem
{
    public string Title;
    public int Year;

    public MediaItem(string title, int year) { Title = title; Year = year; }

    public virtual string Info() => $"\"{Title}\" ({Year})";       // переопределяется
    public virtual string ToLine() => $"MEDIA;{Title};{Year}";     // строка для файла
}

// КНИГА
class Book : MediaItem
{
    public string Author;

    public Book(string title, int year, string author) : base(title, year)
    {
        Author = author;
    }

    public override string Info() => $"[книга] \"{Title}\" — {Author}, {Year}";
    public override string ToLine() => $"BOOK;{Title};{Year};{Author}";
}

// ФИЛЬМ
class Movie : MediaItem
{
    public string Director;

    public Movie(string title, int year, string director) : base(title, year)
    {
        Director = director;
    }

    public override string Info() => $"[фильм] \"{Title}\" — реж. {Director}, {Year}";
    public override string ToLine() => $"MOVIE;{Title};{Year};{Director}";
}
