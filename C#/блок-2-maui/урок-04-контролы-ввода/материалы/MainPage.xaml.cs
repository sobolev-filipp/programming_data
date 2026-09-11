namespace ProfileApp;

public partial class MainPage : ContentPage
{
    public MainPage()
    {
        InitializeComponent();
    }

    // срабатывает на КАЖДОЕ изменение текста в поле имени (живой ввод)
    private void OnNameChanged(object? sender, TextChangedEventArgs e)
    {
        HelloLabel.Text = $"Привет, {e.NewTextValue}!";   // e.NewTextValue — что в поле сейчас
    }

    // кнопка «Готово» — собираем анкету
    private void OnDone(object? sender, EventArgs e)
    {
        string name = NameEntry.Text;                     // читаем введённое имя

        // проверка: имя не пустое?
        if (string.IsNullOrWhiteSpace(name))
        {
            ResultLabel.Text = "Впиши, пожалуйста, имя!";
            return;                                       // дальше не идём
        }

        string about = AboutEditor.Text;                  // текст из многострочного поля

        // возраст должен быть числом (TryParse из блока 1)
        if (int.TryParse(AgeEntry.Text, out int age))
            ResultLabel.Text = $"Привет, {name}! Тебе {age} лет.\nО себе: {about}";
        else
            ResultLabel.Text = $"Привет, {name}! А возраст введи числом.";
    }
}
