using ContactApp.Data;
using ContactApp.Models;
namespace ContactApp.Pages;

public partial class AddEditContactPage : ContentPage
{
    contact currentContact;
    public AddEditContactPage(contact mycontact = null)
	{
		InitializeComponent();
        currentContact = mycontact ?? new contact();

        if (mycontact != null)
        {
            NameEntry.Text = mycontact.Name;
            PhoneEntry.Text = mycontact.Phone;
            EmailEntry.Text = mycontact.Email;
        }
    }
    async void OnSaveClicked(object sender, EventArgs e)
    {
        currentContact.Name = NameEntry.Text;
        currentContact.Phone = PhoneEntry.Text;
        currentContact.Email = EmailEntry.Text;

        App.database.SaveContact(currentContact);
        await Navigation.PushAsync(
            new ContactsPage()
        );
    }
}