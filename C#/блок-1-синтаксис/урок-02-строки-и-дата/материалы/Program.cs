// Урок 2 — Проект «Профиль / анализатор имени»
// Работа со строками (методы) + дата. Имена переменных — по-английски (стиль C#)
// Запуск: Visual Studio ▶ (F5)  |  на Mac: dotnet run

Console.Write("Имя: ");
string firstName = Console.ReadLine().Trim();          // читаем и убираем пробелы по краям
Console.Write("Фамилия: ");
string lastName = Console.ReadLine().Trim();

Console.WriteLine("=== ПРОФИЛЬ ===");
Console.WriteLine($"Привет, {firstName.ToUpper()}!");             // ЗАГЛАВНЫМИ
Console.WriteLine($"В имени {firstName.Length} букв.");          // длина (без скобок)
Console.WriteLine($"Первая буква: {firstName[0]}");             // символ по индексу
Console.WriteLine($"Инициалы: {firstName.Substring(0, 1)}.{lastName.Substring(0, 1)}.");
Console.WriteLine($"Логин: {firstName.ToLower()}{lastName.Length}");   // напр. аня6

// Дата
Console.WriteLine($"Дата регистрации: {DateTime.Now.ToString("dd.MM.yyyy")}");

// 🎓 Глубже: сколько дней прожито (поставь свою дату рождения)
DateTime birthday = new DateTime(2013, 5, 20);
Console.WriteLine($"Ты живёшь уже {(DateTime.Now - birthday).Days} дней");
