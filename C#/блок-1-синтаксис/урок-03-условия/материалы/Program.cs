// Урок 3 — Проект «Меню-калькулятор» на switch
// Выбор действия через switch + проверка деления на ноль
// Запуск: Visual Studio ▶ (F5)  |  на Mac: dotnet run

Console.Write("Первое число: ");
int a = Convert.ToInt32(Console.ReadLine());
Console.Write("Действие (+, -, *, /): ");
string op = Console.ReadLine();
Console.Write("Второе число: ");
int b = Convert.ToInt32(Console.ReadLine());

switch (op)
{
    case "+":
        Console.WriteLine($"= {a + b}");
        break;
    case "-":
        Console.WriteLine($"= {a - b}");
        break;
    case "*":
        Console.WriteLine($"= {a * b}");
        break;
    case "/":
        if (b == 0)
            Console.WriteLine("На ноль делить нельзя!");
        else
            Console.WriteLine($"= {Math.Round((double)a / b, 2)}");
        break;
    default:
        Console.WriteLine("Не знаю такого действия");
        break;
}
