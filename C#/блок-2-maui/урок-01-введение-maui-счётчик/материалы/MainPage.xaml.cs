using System;
using Microsoft.Maui.Controls;

namespace MoodApp;

public partial class MainPage : ContentPage
{
    public MainPage()
    {
        InitializeComponent();
    }

    private void MoodBtn(object? sender, EventArgs e)
    {
        if (sender is Button button)
        {
            BackgroundColor = button.BackgroundColor;
            MoodLabel.Text = button.Text;

            if (button == HappyBtn)
            {
                MoodImage.Source = "mood_happy.png";
            }
            else if (button == CalmBtn)
            {
                MoodImage.Source = "mood_calm.png";
            }
            else if (button == SadBtn)
            {
                MoodImage.Source = "mood_sad.png";
            }
            else if (button == AngryBtn)
            {
                MoodImage.Source = "mood_angry.png";
            }
        }
    }
}
