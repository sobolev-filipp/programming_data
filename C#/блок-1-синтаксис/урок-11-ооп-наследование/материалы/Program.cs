// Урок 11 — Проект «Банк: счета клиентов» (наследование)
// Общий родитель Account, наследники SavingsAccount / CheckingAccount / SalaryAccount
// Каждый переопределяет ApplyMonthly() по-своему (полиморфизм)
// Имена: классы/методы/свойства PascalCase, поля-хранилища camelCase
// Запуск: Visual Studio ▶ (F5)  |  на Mac: dotnet run

List<Account> accounts = new()
{
    new SavingsAccount("Аня", 1000),      // вклад
    new CheckingAccount("Боря", 500),     // карта
    new SalaryAccount("Вера", 0, 300),    // зарплатный (+300 в месяц)
};

Console.ForegroundColor = ConsoleColor.Cyan;
Console.WriteLine("=== Клиенты банка ===");
Console.ResetColor();
foreach (Account a in accounts) a.Show();

Console.WriteLine("\n=== Операции ===");
accounts[0].Deposit(500);                 // Аня положила
accounts[1].Withdraw(600);                // Боре не хватит

Console.WriteLine("\n=== Конец месяца (полиморфизм) ===");
foreach (Account a in accounts) a.ApplyMonthly();   // у каждого своё правило

Console.ForegroundColor = ConsoleColor.Yellow;
Console.WriteLine("\n=== Итоговый отчёт ===");
Console.ResetColor();
foreach (Account a in accounts) a.Show();

// ---------- классы ----------

class Account                                  // РОДИТЕЛЬ: общее для всех счетов
{
    public string Owner;
    protected int balance;                     // прячем баланс (инкапсуляция)

    public int Balance => balance;             // только чтение

    public Account(string owner, int start) { Owner = owner; balance = start; }

    public void Deposit(int sum)               // положить — общее
    {
        if (sum > 0) balance += sum;
        Console.WriteLine($"  {Owner} положил(а) {sum} -> {balance}");
    }

    public void Withdraw(int sum)              // снять — с проверкой
    {
        if (sum > balance) { Console.WriteLine($"  {Owner}: недостаточно средств"); return; }
        balance -= sum;
        Console.WriteLine($"  {Owner} снял(а) {sum} -> {balance}");
    }

    public void Show() => Console.WriteLine($"{Owner}: баланс {balance}");

    public virtual void ApplyMonthly()         // ежемесячно — переопределяется наследниками
    {
        Console.WriteLine($"{Owner}: без изменений");
    }
}

class SavingsAccount : Account                 // ВКЛАД: +5% в месяц
{
    public SavingsAccount(string owner, int start) : base(owner, start) { }

    public override void ApplyMonthly()
    {
        balance += balance / 20;               // +5%
        Console.WriteLine($"{Owner}: начислены проценты +5% -> {balance}");
    }
}

class CheckingAccount : Account                // КАРТА: -10 обслуживание
{
    public CheckingAccount(string owner, int start) : base(owner, start) { }

    public override void ApplyMonthly()
    {
        balance -= 10;
        Console.WriteLine($"{Owner}: списано обслуживание -10 -> {balance}");
    }
}

class SalaryAccount : Account                  // ЗАРПЛАТНЫЙ: +зарплата в месяц
{
    private int salary;

    public SalaryAccount(string owner, int start, int salary) : base(owner, start)
    {
        this.salary = salary;
    }

    public override void ApplyMonthly()
    {
        balance += salary;
        Console.WriteLine($"{Owner}: зарплата +{salary} -> {balance}");
    }
}
