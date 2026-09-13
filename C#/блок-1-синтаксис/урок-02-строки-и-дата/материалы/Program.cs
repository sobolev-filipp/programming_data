// Урок 2 — Проект «Табло аэропорта»
// Дата и время: DateTime (момент) + TimeSpan (промежуток). Имена — по-английски (стиль C#)
// Запуск: Visual Studio ▶ (F5)  |  на Mac: dotnet run
// ⚠️ Вводи БУДУЩИЕ дату и время вылета — тогда «через ...» будут положительными.

Console.Write("Откуда летим (город): ");
string from = Console.ReadLine().Trim();
Console.Write("Куда летим (город): ");
string to = Console.ReadLine().Trim();

// Дата и время вылета — вводим по частям (числами)
Console.WriteLine("Дата и время вылета:");
Console.Write("  год: ");    int year   = Convert.ToInt32(Console.ReadLine());
Console.Write("  месяц: ");  int month  = Convert.ToInt32(Console.ReadLine());
Console.Write("  день: ");   int day    = Convert.ToInt32(Console.ReadLine());
Console.Write("  час: ");    int hour   = Convert.ToInt32(Console.ReadLine());
Console.Write("  минуты: "); int minute = Convert.ToInt32(Console.ReadLine());
DateTime departure = new DateTime(year, month, day, hour, minute, 0);   // момент вылета

Console.Write("За сколько минут до вылета регистрация: ");
int regMin = Convert.ToInt32(Console.ReadLine());
Console.Write("За сколько минут до вылета посадка: ");
int boardMin = Convert.ToInt32(Console.ReadLine());

Console.WriteLine("Сколько лететь:");
Console.Write("  часов: "); int flightH = Convert.ToInt32(Console.ReadLine());
Console.Write("  минут: "); int flightM = Convert.ToInt32(Console.ReadLine());

// TimeSpan — это ПРОМЕЖУТКИ времени (не момент, а «сколько длится»)
TimeSpan beforeReg   = TimeSpan.FromMinutes(regMin);      // за сколько до вылета регистрация
TimeSpan beforeBoard = TimeSpan.FromMinutes(boardMin);    // за сколько до вылета посадка
TimeSpan flight      = new TimeSpan(flightH, flightM, 0); // длительность полёта

// МОМЕНТЫ (DateTime) получаем из вылета ± промежуток:
DateTime registration = departure - beforeReg;   // DateTime − TimeSpan = DateTime
DateTime boarding     = departure - beforeBoard;
DateTime arrival      = departure + flight;       // DateTime + TimeSpan = DateTime

// Сколько ждать от текущего момента: момент − момент = промежуток
TimeSpan tillReg     = registration - DateTime.Now;   // DateTime − DateTime = TimeSpan
TimeSpan tillBoard   = boarding - DateTime.Now;
TimeSpan tillArrival = arrival - DateTime.Now;

Console.WriteLine();
Console.WriteLine("=== ВАШ РЕЙС ===");
Console.WriteLine($"Регистрация в аэропорту города {from} начнётся через {tillReg.Days} дн {tillReg.Hours} ч {tillReg.Minutes} мин, а посадка — через {tillBoard.Days} дн {tillBoard.Hours} ч {tillBoard.Minutes} мин.");
Console.WriteLine($"В аэропорт города {to} прибудете через {tillArrival.Days} дн {tillArrival.Hours} ч {tillArrival.Minutes} мин — в {arrival.ToString("HH:mm")} ({arrival.ToString("dd.MM.yyyy")}).");
Console.WriteLine($"Полёт продлится {flight.Hours} ч {flight.Minutes} мин.");
