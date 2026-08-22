// Урок 7 — Проект «RPG-бой»
// Свои методы: Damage() возвращает урон, DrawHp(name, hp) рисует полосу здоровья
// Имена методов — PascalCase, переменные — camelCase (стиль C#)
// Запуск: Visual Studio ▶ (F5)  |  на Mac: dotnet run

Random rnd = new Random();
int heroHp = 100, dragonHp = 120;
int turn = 0;

Console.WriteLine("⚔  БОЙ: Герой против Дракона!\n");
while (heroHp > 0 && dragonHp > 0)
{
    turn++;
    Console.WriteLine($"--- Ход {turn} ---");

    dragonHp -= Damage();               // герой атакует
    Console.WriteLine("Герой атакует!");
    DrawHp("Дракон", dragonHp);
    if (dragonHp <= 0) break;

    heroHp -= Damage();                 // дракон атакует
    Console.WriteLine("Дракон атакует!");
    DrawHp("Герой", heroHp);
    Console.WriteLine();
}

ShowResult(heroHp > 0 ? "Герой 🎉" : "Дракон 🐉");

// ---------- методы ----------

// возвращает случайный урон 15..30
int Damage() => rnd.Next(15, 31);

// рисует полосу здоровья: зелёная если hp > 30, иначе красная
void DrawHp(string name, int hp)
{
    if (hp < 0) hp = 0;
    Console.ForegroundColor = hp > 30 ? ConsoleColor.Green : ConsoleColor.Red;
    Console.WriteLine($"{name,-7} HP {hp,3} {new string('█', hp / 5)}");
    Console.ResetColor();
}

// печатает итог боя жёлтым
void ShowResult(string who)
{
    Console.ForegroundColor = ConsoleColor.Yellow;
    Console.WriteLine($"\nПобедил: {who}!");
    Console.ResetColor();
}
