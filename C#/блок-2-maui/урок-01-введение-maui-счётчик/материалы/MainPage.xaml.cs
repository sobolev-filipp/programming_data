using System;
using Microsoft.Maui.Controls;
using Microsoft.Maui.Graphics;

namespace MoodApp;

public partial class MainPage : ContentPage
{
    public MainPage()
    {
        InitializeComponent();
    }

    private void SetMood(string title, string advice, string image, Color color)
    {
        MoodLabel.Text = title;
        AdviceLabel.Text = advice;
        MoodImage.Source = image;
        BackgroundColor = color;
    }

    private void OnHappyClicked(object sender, EventArgs e)
    {
        SetMood("Отличный день!", "Поделись хорошим настроением.", "mood_happy.png", Color.FromArgb("#FFF4D6"));
    }

    private void OnCalmClicked(object sender, EventArgs e)
    {
        SetMood("Спокойный день", "Найди время для любимого дела.", "mood_calm.png", Color.FromArgb("#E2F7F5"));
    }

    private void OnSadClicked(object sender, EventArgs e)
    {
        SetMood("Бывает и так", "Можно отдохнуть или поговорить с близкими.", "mood_sad.png", Color.FromArgb("#EFEAFF"));
    }

    private void OnRandomClicked(object sender, EventArgs e)
    {
        int choice = Random.Shared.Next(3);
        if (choice == 0) OnHappyClicked(sender, e);
        else if (choice == 1) OnCalmClicked(sender, e);
        else OnSadClicked(sender, e);
    }
}
