using System;
using Microsoft.Maui.Controls;

namespace ShipApp;

public partial class MainPage : ContentPage
{
    private bool ready = false;

    public MainPage()
    {
        InitializeComponent();
        TypePicker.SelectedIndex = 0;
        ready = true;
        UpdateShip();
    }

    private void UpdateShip()
    {
        if (!ready)
            return;

        string name = (NameEntry.Text ?? "").Trim();
        if (name.Length == 0)
            name = "Без названия";
        ShipTitle.Text = name;

        int index = TypePicker.SelectedIndex;
        int price = 1000;
        string type = "Разведчик";
        string image = "ship_scout.png";

        if (index == 1)
        {
            price = 1500;
            type = "Грузовой";
            image = "ship_cargo.png";
        }
        else if (index == 2)
        {
            price = 2000;
            type = "Истребитель";
            image = "ship_fighter.png";
        }

        if (ShieldCheck.IsChecked)
        {
            price += 300;
            InfoLabel.Text = type + " · со щитом";
        }
        else
        {
            InfoLabel.Text = type + " · без щита";
        }

        ShipImage.Source = image;
        PriceLabel.Text = price.ToString();
    }

    private void OnNameChanged(object? sender, TextChangedEventArgs e)
    {
        UpdateShip();
    }

    private void OnTypeChanged(object? sender, EventArgs e)
    {
        UpdateShip();
    }

    private void OnShieldChanged(object? sender, CheckedChangedEventArgs e)
    {
        UpdateShip();
    }

    private void OnResetClicked(object? sender, EventArgs e)
    {
        NameEntry.Text = "";
        TypePicker.SelectedIndex = 0;
        ShieldCheck.IsChecked = false;
        UpdateShip();
    }
}
