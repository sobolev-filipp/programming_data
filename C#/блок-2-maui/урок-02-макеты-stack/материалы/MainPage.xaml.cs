namespace ProfileCard;

public partial class MainPage : ContentPage
{
    int likes = 0;                       // число лайков, помнит значение всё время работы

    public MainPage()
    {
        InitializeComponent();           // «оживляет» XAML: создаёт LikesLabel, Card и кнопки
    }

    private void OnLikeClicked(object? sender, EventArgs e)
    {
        likes++;                              // +1 лайк
        LikesLabel.Text = likes.ToString();   // показать новое число в метке
    }

    private void OnSpaceClicked(object? sender, EventArgs e)
    {
        Card.Spacing = 40;                    // раздвинуть всё содержимое карточки из кода
    }
}
