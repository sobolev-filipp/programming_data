using ContactApp.Data;
using ContactApp.Models;

namespace ContactApp.Pages;

public partial class ContactsPage : ContentPage
{
	public ContactsPage()
	{
		InitializeComponent();
        LoadContacts();
    }
    void LoadContacts(string search = "")
    {
        ContactsLayout.Children.Clear();

        var contacts = App.database.GetContacts();

        // Сортировка
        contacts = contacts
            .OrderBy(c => c.Name)
            .ToList();

        foreach (var cont in contacts)
        {
            AddContactView(cont);
        }
    }

    void OnSearchChanged(object sender, EventArgs e)
    {
        var edit = sender as Entry;
        var contacts = App.database.GetContacts();
        if (!string.IsNullOrWhiteSpace(edit.Text))
        {
            contacts = contacts
                .Where(c => c.Name.ToLower().Contains(edit.Text.ToLower()))
                .ToList();
        }
        LoadContacts(edit.Text);
        edit.Text = string.Empty;
    }

    async void OnAddClicked(object sender, EventArgs e)
    {
        await Navigation.PushAsync(
            new AddEditContactPage()
        );
    }

    void AddContactView(contact cont)
    {
        var nameLabel = new Label { Text = cont.Name };
        var phoneLabel = new Label { Text = cont.Phone };

        var editButton = new Button { Text = "✏️" };
        editButton.Clicked += async (s, e) =>
        {
            await Navigation.PushAsync(
                new AddEditContactPage(cont)
            );
        };

        var deleteButton = new Button { Text = "🗑" };
        deleteButton.Clicked += async (s, e) =>
        {
            bool answer = await DisplayAlert(
                "Удаление",
                $"Удалить контакт {cont.Name}?",
                "Да",
                "Нет"
            );

            if (answer)
            {
                App.database.DeleteContact(cont);
                LoadContacts(SearchEntry.Text);
            }
        };

        var row = new HorizontalStackLayout
        {
            Children =
        {
            nameLabel,
            phoneLabel,
            editButton,
            deleteButton
        }
        };

        ContactsLayout.Children.Add(row);
    }
}