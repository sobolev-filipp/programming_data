// Урок 5 — Проект «Генератор узоров»
// switch (Урок 3) + ввод + вложенные циклы + new string() + цвет
// Запуск: Visual Studio ▶ (F5)  |  на Mac: dotnet run

Console.Write("Что нарисовать? (1-ёлочка, 2-пирамида, 3-шахматка): ");
string choice = Console.ReadLine();
Console.Write("Размер: ");
int n = Convert.ToInt32(Console.ReadLine());

switch (choice)
{
    case "1":                                   // ёлочка (цветная)
        Console.ForegroundColor = ConsoleColor.Green;
        for (int row = 1; row <= n; row++)
        {
            Console.Write(new string(' ', n - row));       // отступ слева
            Console.WriteLine(new string('*', row * 2 - 1)); // 1,3,5,7... звёзд
        }
        Console.ResetColor();
        break;

    case "2":                                   // пирамида
        for (int i = 1; i <= n; i++)
            Console.WriteLine(new string('#', i));
        break;

    case "3":                                   // шахматка (вложенные циклы)
        for (int r = 0; r < n; r++)
        {
            for (int c = 0; c < n; c++)
                Console.Write((r + c) % 2 == 0 ? "██" : "  ");
            Console.WriteLine();                // перевод строки после ряда
        }
        break;

    default:
        Console.WriteLine("Не знаю такой узор");
        break;
}
