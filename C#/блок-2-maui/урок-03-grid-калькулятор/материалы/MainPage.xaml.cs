namespace CalcApp;

public partial class MainPage : ContentPage
{
    string current = "";      // что набираем прямо сейчас
    double stored = 0;        // запомненное первое число
    string op = "";           // выбранная операция (+, −, ×, ÷)

    public MainPage()
    {
        InitializeComponent();
    }

    // любая кнопка-цифра
    private void OnDigit(object? sender, EventArgs e)
    {
        Button b = (Button)sender!;       // узнаём, какую кнопку нажали
        current += b.Text;                // добавляем её цифру справа
        Display.Text = current;           // показываем на экране
    }

    // кнопка-операция
    private void OnOperation(object? sender, EventArgs e)
    {
        if (current == "") return;        // нечего запоминать
        Button b = (Button)sender!;
        stored = Convert.ToDouble(current);   // запомнили первое число
        op = b.Text;                      // запомнили операцию
        current = "";                     // готовимся ко второму числу
    }

    // кнопка «=»
    private void OnEquals(object? sender, EventArgs e)
    {
        if (current == "" || op == "") return;
        double second = Convert.ToDouble(current);
        double result = 0;
        switch (op)
        {
            case "+": result = stored + second; break;
            case "−": result = stored - second; break;
            case "×": result = stored * second; break;
            case "÷": result = second != 0 ? stored / second : 0; break;
        }
        result = Math.Round(result, 4);   // убираем длинный «хвост» (Math из блока 1)
        Display.Text = result.ToString();
        current = result.ToString();      // с результатом можно считать дальше
        op = "";
    }

    // кнопка «C» — сброс
    private void OnClear(object? sender, EventArgs e)
    {
        current = "";
        stored = 0;
        op = "";
        Display.Text = "0";
    }
}
