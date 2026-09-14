namespace CafeApp;

public partial class MainPage : ContentPage
{
    public MainPage()
    {
        InitializeComponent();
    }

    // Ползунок номера стола: Value — double, приводим (int) (как в уроке 5)
    private void OnTableChanged(object? sender, ValueChangedEventArgs e)
    {
        TableLabel.Text = $"Стол: {(int)e.NewValue}";
    }

    // Кнопка «Позвать официанта»
    private void OnCall(object? sender, EventArgs e)
    {
        int table = (int)TableStepper.Value;
        ResultLabel.Text = $"Официант идёт к столу №{table}";
    }
}
