namespace PizzaApp;

public partial class MainPage : ContentPage
{
    public MainPage()
    {
        InitializeComponent();
    }

    // Stepper изменился — показываем число (Value — это double, приводим к int)
    private void OnQtyChanged(object? sender, ValueChangedEventArgs e)
    {
        QtyLabel.Text = $"Количество: {(int)e.NewValue}";
    }

    // Slider двигают — показываем остроту
    private void OnSpicyChanged(object? sender, ValueChangedEventArgs e)
    {
        SpicyLabel.Text = $"Острота: {(int)e.NewValue}/10";
    }

    // Кнопка «Оформить» — собираем заказ и считаем цену
    private void OnOrder(object? sender, EventArgs e)
    {
        // Picker: если не выбрали — SelectedIndex равен -1
        if (SizePicker.SelectedIndex == -1)
        {
            ResultLabel.Text = "Сначала выбери размер пиццы!";
            return;
        }

        int[] prices = { 300, 450, 600 };                 // цены по индексу размера
        int basePrice = prices[SizePicker.SelectedIndex];
        int qty = (int)QtyStepper.Value;                  // Stepper.Value — double
        int total = basePrice * qty;

        if (CheeseSwitch.IsToggled) total += 50 * qty;    // Switch: да/нет
        if (DeliveryCheck.IsChecked) total += 150;        // CheckBox: да/нет

        int spicy = (int)SpicySlider.Value;               // Slider.Value — double

        // В .NET 10 OrderDate.Date может быть «не выбрана» (DateTime?),
        // поэтому ?? DateTime.Today — «если не выбрана, берём сегодня»
        DateTime date = OrderDate.Date ?? DateTime.Today;

        ResultLabel.Text = $"{SizePicker.SelectedItem} ×{qty}, острота {spicy}/10\n"
                         + $"Дата: {date:dd.MM.yyyy}\n"
                         + $"Итого: {total} ₽";
    }
}
