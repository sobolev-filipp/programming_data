// Урок 1 — Проект «Анкета героя»
// Ввод (ReadLine) + приведение типа (Convert.ToInt32) + красивый вывод ($"...")
// Имена переменных — по-английски (стиль C#), тексты и комментарии — по-русски
// Запуск: Visual Studio ▶ (F5)  |  на Mac: dotnet run

const int MaxLevel = 100;

Console.Write("Как зовут героя? ");
string name = Console.ReadLine();                      // строка — как есть

Console.Write("Какой у героя уровень? ");
int level = Convert.ToInt32(Console.ReadLine());       // число — превращаем из строки

Console.WriteLine("=== ВИЗИТКА ГЕРОЯ ===");
Console.WriteLine($"Имя: {name}");
Console.WriteLine($"Уровень: {level}");
Console.WriteLine($"До максимума: {MaxLevel - level} уровней");

// 🎓 Глубже: очки опыта = уровень * 100
Console.WriteLine($"Опыт: {level * 100} очков");
