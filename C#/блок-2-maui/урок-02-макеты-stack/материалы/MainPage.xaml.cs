namespace HeroCard;

public partial class MainPage : ContentPage
{
    bool compact = false;

    public MainPage()
    {
        InitializeComponent();
    }

    private void OnDetailsClicked(object sender, EventArgs e)
    {
        DetailsPanel.IsVisible = !DetailsPanel.IsVisible;
        DetailsButton.Text = DetailsPanel.IsVisible ? "Скрыть навыки" : "Показать навыки";
    }

    private void OnThemeClicked(object sender, EventArgs e)
    {
        compact = !compact;
        ApplyLayout(compact);
    }

    private void ApplyLayout(bool small)
    {
        HeroLayout.Spacing = small ? 6 : 14;
        HeroBorder.Padding = new Thickness(small ? 8 : 16);
        HeroBorder.BackgroundColor = small ? Color.FromArgb("#E0F2FE") : Colors.White;
        StatusLabel.Text = small ? "Компактный режим" : "Готова к походу";
    }
}
