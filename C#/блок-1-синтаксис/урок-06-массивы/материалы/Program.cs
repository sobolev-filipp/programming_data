// Урок 6 — Проект «Топ игроков» с диаграммой
// Параллельные массивы + поиск чемпиона + диаграмма-бары + цвет + готовые методы
// Имена переменных — по-английски (стиль C#)
// Запуск: Visual Studio ▶ (F5)  |  на Mac: dotnet run

string[] players = { "Аня", "Боря", "Вика", "Гена" };
int[] scores     = {  40,    90,     65,     20   };

// 1) Чемпион — перебор параллельных массивов
int max = scores[0];
string champion = players[0];
for (int i = 1; i < scores.Length; i++)
    if (scores[i] > max)
    {
        max = scores[i];
        champion = players[i];
    }

// 2) Диаграмма: длина бара = scores / 5
Console.WriteLine("=== ТОП ИГРОКОВ ===");
for (int i = 0; i < players.Length; i++)
{
    Console.Write($"{players[i],-6} ");                 // имя по левому краю (6 позиций)
    Console.WriteLine(new string('█', scores[i] / 5));  // бар из блоков
}

// 3) Итоги: чемпион (жёлтым) + готовые методы Sum/Average
Console.ForegroundColor = ConsoleColor.Yellow;
Console.WriteLine($"🏆 Чемпион: {champion} ({max} очков)");
Console.ResetColor();
Console.WriteLine($"Всего очков: {scores.Sum()}, средний балл: {scores.Average()}");
