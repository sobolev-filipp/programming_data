namespace QuizApp;

public partial class MainPage : ContentPage
{
    string correct = "Париж";   // правильный ответ

    public MainPage()
    {
        InitializeComponent();
    }

    // Один обработчик на все три кнопки-ответа — узнаём нажатую через sender
    private async void OnAnswer(object? sender, EventArgs e)
    {
        if (sender is not Button btn) return;   // sender — это кнопка? кладём в btn
        string answer = btn.Text;

        if (answer == correct)
        {
            await DisplayAlertAsync("Результат", "Верно! 🎉", "OK");
            ResultLabel.Text = "Правильно!";
        }
        else
        {
            await DisplayAlertAsync("Результат", $"Неверно. Правильный ответ: {correct}", "OK");
            ResultLabel.Text = "В следующий раз получится!";
        }

        // отвечать второй раз нельзя — гасим кнопки
        Btn1.IsEnabled = false;
        Btn2.IsEnabled = false;
        Btn3.IsEnabled = false;
        RestartButton.IsVisible = true;   // показываем «Заново»
    }

    // Кнопка «Пройти заново» — с подтверждением
    private async void OnRestart(object? sender, EventArgs e)
    {
        bool yes = await DisplayAlertAsync("Заново?", "Начать викторину сначала?", "Да", "Нет");
        if (!yes) return;                 // нажал «Нет» — выходим

        Btn1.IsEnabled = true;            // включаем кнопки обратно
        Btn2.IsEnabled = true;
        Btn3.IsEnabled = true;
        ResultLabel.Text = "";
        RestartButton.IsVisible = false;  // снова прячем «Заново»
    }
}
