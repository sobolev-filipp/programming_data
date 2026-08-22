// Урок 4 — Проект «Угадай число»
// while (true) + Random + if/else + break + счётчик попыток
// Имена переменных — по-английски (стиль C#)
// Запуск: Visual Studio ▶ (F5)  |  на Mac: dotnet run

Random rnd = new Random();
int secret = rnd.Next(1, 101);      // случайное число 1..100 (101 НЕ входит)
int count = 0;

Console.WriteLine("Угадай число от 1 до 100!");
while (true)
{
    Console.Write("Твой вариант: ");
    int guess = Convert.ToInt32(Console.ReadLine());
    count++;

    if (guess == secret)
    {
        Console.WriteLine($"🎉 Угадал за {count} попыток!");
        break;                       // победа — выходим из цикла
    }
    else if (guess < secret)
        Console.WriteLine("Загадано больше ⬆");
    else
        Console.WriteLine("Загадано меньше ⬇");
}
