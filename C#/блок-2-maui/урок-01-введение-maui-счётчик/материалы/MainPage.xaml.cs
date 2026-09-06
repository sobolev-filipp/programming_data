namespace CounterApp;

public partial class MainPage : ContentPage
{
    int count = 0;                       // число-счётчик, помнит значение всё время работы

    public MainPage()
    {
        InitializeComponent();           // «оживляет» XAML: создаёт CountLabel и кнопки
    }

    private void OnPlusClicked(object? sender, EventArgs e)
    {
        count++;                             // +1
        CountLabel.Text = count.ToString();  // показать новое число в метке
    }

    private void OnMinusClicked(object? sender, EventArgs e)
    {
        count--;                             // -1
        CountLabel.Text = count.ToString();
    }

    private void OnResetClicked(object? sender, EventArgs e)
    {
        count = 0;                           // сброс
        CountLabel.Text = count.ToString();
    }
}
