// Урок 10 — Проект «Арена: Герой против Монстра» (ООП)
// Два класса — Hero и Enemy: у каждого свои поля, свойства и методы (поведение)
// Имена: классы/методы/свойства PascalCase, поля-переменные camelCase
// Запуск: Visual Studio ▶ (F5)  |  на Mac: dotnet run

Random rnd = new Random();

Hero hero = new Hero("Артур", 100, 22);        // имя, hp, сила удара
Enemy dragon = new Enemy("Дракон", 130, 18);

Console.WriteLine("=== АРЕНА: бой начинается! ===\n");
hero.Introduce();
dragon.Introduce();

int turn = 0;
while (hero.IsAlive && dragon.IsAlive)
{
    turn++;
    Console.WriteLine($"\n--- Ход {turn} ---");

    hero.Attack(dragon, rnd);         // герой бьёт монстра
    if (!dragon.IsAlive) break;

    dragon.Attack(hero, rnd);         // монстр отвечает
}

Console.WriteLine();
Console.ForegroundColor = ConsoleColor.Yellow;
Console.WriteLine(hero.IsAlive ? $"Победил: {hero.Name}!" : $"Победил: {dragon.Name}!");
Console.ResetColor();

// ---------- классы ----------

class Hero
{
    public string Name;               // поле — имя
    public int Power;                 // поле — базовая сила удара
    private int hp;                   // приватное хранилище для свойства Hp

    // свойство Hp: не даём уйти в минус
    public int Hp
    {
        get { return hp; }
        set { hp = value < 0 ? 0 : value; }
    }

    // вычисляемое свойство: жив, пока hp > 0
    public bool IsAlive => Hp > 0;

    // конструктор — создаёт героя сразу с данными
    public Hero(string name, int hp, int power)
    {
        Name = name;
        Hp = hp;
        Power = power;
    }

    public void Introduce()
    {
        Console.WriteLine($"{Name}: HP={Hp}, сила={Power}");
    }

    // герой атакует монстра
    public void Attack(Enemy target, Random rnd)
    {
        int dmg = Power + rnd.Next(-4, 5);           // небольшой разброс урона
        target.Hp -= dmg;
        Console.WriteLine($"{Name} наносит {dmg} урона. {target.Name}: HP={target.Hp}");
    }
}

class Enemy
{
    public string Name;
    public int Power;
    private int hp;

    public int Hp
    {
        get { return hp; }
        set { hp = value < 0 ? 0 : value; }
    }

    public bool IsAlive => Hp > 0;

    public Enemy(string name, int hp, int power)
    {
        Name = name;
        Hp = hp;
        Power = power;
    }

    public void Introduce()
    {
        Console.WriteLine($"{Name}: HP={Hp}, сила={Power}");
    }

    // монстр атакует героя
    public void Attack(Hero target, Random rnd)
    {
        int dmg = Power + rnd.Next(-4, 5);
        target.Hp -= dmg;
        Console.WriteLine($"{Name} наносит {dmg} урона. {target.Name}: HP={target.Hp}");
    }
}
