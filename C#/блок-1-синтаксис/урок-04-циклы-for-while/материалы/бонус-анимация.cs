// Урок 4 — БОНУС: цвет и анимация в консоли (для интересных программ)
// Новые команды: Console.ForegroundColor (цвет), Thread.Sleep (пауза)
// Запуск: Visual Studio ▶ (F5)  |  на Mac: dotnet run

// 1) Прогресс-бар «Загрузка»
Console.Write("Загрузка: ");
for (int i = 0; i < 20; i++)
{
    Console.Write("█");                       // рисуем по одному блоку
    System.Threading.Thread.Sleep(100);       // пауза 100 мс — видно, как растёт
}
Console.WriteLine(" 100% ✅");

// 2) Анимированный бросок кубика
Random rnd = new Random();
Console.Write("Кручу кубик:");
for (int i = 0; i < 6; i++)                   // «мелькают» случайные грани
{
    Console.Write(" " + rnd.Next(1, 7));
    System.Threading.Thread.Sleep(150);
}
int result = rnd.Next(1, 7);
Console.ForegroundColor = ConsoleColor.Green; // включаем зелёный цвет
Console.WriteLine($"\nВыпало: {result}!");
Console.ResetColor();                         // возвращаем обычный цвет

// 3) Радужный отсчёт до старта
ConsoleColor[] colors = { ConsoleColor.Red, ConsoleColor.Yellow, ConsoleColor.Green };
for (int n = 3; n >= 1; n--)
{
    Console.ForegroundColor = colors[n - 1];
    Console.WriteLine(n);
    System.Threading.Thread.Sleep(500);
}
Console.ResetColor();
Console.WriteLine("Поехали! 🚀");
