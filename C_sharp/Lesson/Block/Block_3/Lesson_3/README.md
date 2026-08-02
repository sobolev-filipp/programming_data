<h1>Занятие 3. Приложение «Контакты»</h1>

<br>
<h2>1️⃣ Структура проекта</h2>

```
ContactsApp
│
├── Models
│   └── Contact.cs
│
├── Data
│   └── ContactsDatabase.cs
│
├── Pages
│   ├── ContactsPage.xaml
│   ├── ContactsPage.xaml.cs
│   ├── AddEditContactPage.xaml
│   └── AddEditContactPage.xaml.cs
│
├── App.xaml.cs
└── MauiProgram.cs
```

<p>Где:</p>
<ul>
    <li><b>Models</b> — содержит классы моделей данных, например, <i>Contact.cs</i></li>
    <li><b>Data</b> — содержит логику работы с базой данных, например, <i>ContactsDatabase.cs</i></li>
    <li><b>Pages</b> — содержит файлы страниц приложения, например, <i>ContactsPage.xaml</i>, <i>AddEditContactPage.xaml</i></li>
    <li><b>App.xaml.cs</b> — основной файл приложения с логикой запуска и настройками</li>
    <li><b>MauiProgram.cs</b> — точка входа в приложение .NET MAUI</li>
</ul>

<br>
<h2>🧱 MODEL — ОПИСАНИЕ КОНТАКТА (Contact.cs)</h2>

```c#
using SQLite;

public class Contact
{
    [PrimaryKey, AutoIncrement]
    public int Id { get; set; }

    public string Name { get; set; }
    public string Phone { get; set; }
    public string Email { get; set; }
}
```

<p>В данной модели используются следующие свойства:</p>
<ul>
    <li><b>Id</b> — уникальный идентификатор контакта (PrimaryKey, AutoIncrement)</li>
    <li><b>Name</b> — имя контакта</li>
    <li><b>Phone</b> — номер телефона контакта</li>
    <li><b>Email</b> — адрес электронной почты контакта</li>
</ul>

<br>
<h2>🗄 DATA — РАБОТА С БАЗОЙ ДАННЫХ (ContactsDatabase.cs)</h2>

```c#
using SQLite;
using ContactApp.Models;

namespace ContactApp.Data
{
    internal class ContactsDatabase
    {
        SQLiteConnection db;

        public ContactsDatabase(string path)
        {
            db = new SQLiteConnection(path);
            db.CreateTable<Contact>();
        }

        public List<Contact> GetContacts()
        {
            return db.Table<Contact>().ToList();
        }

        public void SaveContact(Contact contact)
        {
            if (contact.Id == 0)
                db.Insert(contact);
            else
                db.Update(contact);
        }

        public void DeleteContact(Contact contact)
        {
            db.Delete(contact);
        }
    }
}
```

<p>Объяснение работы с базой данных:</p>
<ul>
    <li>Создание таблицы контактов при инициализации базы данных</li>
    <li>Метод <b>GetContacts()</b> для получения всех контактов из базы данных</li>
    <li>Метод <b>SaveContact(Contact contact)</b> для добавления нового контакта или обновления существующего</li>
    <li>Метод <b>DeleteContact(Contact contact)</b> для удаления контакта из базы данных</li>
</ul>

<br>

<h3>Передача PATH в App.xaml.cs</h3>

```c#
using ContactApp.Data;
using ContactApp.Pages;

namespace ContactApp
{
    public partial class App : Application
    {
        public static contactsdatabase database;
        public App()
        {
            InitializeComponent();
            string dbPath = Path.Combine(FileSystem.AppDataDirectory,"contacts.db");
            database = new contactsdatabase(dbPath);
        }

        protected override Window CreateWindow(IActivationState? activationState)
        {
            return new Window(new NavigationPage(new ContactsPage()));
        }
    }
}
```

<p>Объяснение:</p>
<ul>
    <li>Создание пути к файлу базы данных в безопасной папке приложения</li>
    <li>Инициализация экземпляра базы данных при запуске приложения</li>
    <li>Обеспечение доступа к базе данных из любого места приложения через статическое свойство</li>
</ul>
<h4>Полная цепочка работы с базой данных</h4>

```
App.xaml.cs
   ↓
Создали путь к файлу
   ↓
new ContactsDatabase(path)
   ↓
Конструктор ContactsDatabase(string path)
   ↓
SQLiteConnection(path)
   ↓
Файл БД создан / открыт
```

<br>
<h2>📱 ГЛАВНАЯ СТРАНИЦА — СПИСОК КОНТАКТОВ (ContactsPage.xaml)</h2>

```xml
<ContentPage xmlns="http://schemas.microsoft.com/dotnet/2021/maui"
             xmlns:x="http://schemas.microsoft.com/winfx/2009/xaml"
             x:Class="ContactApp.Pages.ContactsPage"
             Title="ContactsPage">
    <VerticalStackLayout Padding="10">
        <Entry x:Name="SearchEntry"
               Placeholder="Поиск по имени"
               TextChanged="OnSearchChanged"/>

        <ScrollView>
            <VerticalStackLayout x:Name="ContactsLayout"/>
        </ScrollView>

        <Button Text="Добавить контакт"
                Clicked="OnAddClicked"/>
    </VerticalStackLayout>
</ContentPage>
```

<p>Элементы страницы:</p>
<ul>
    <li><b>Entry</b> для поиска контактов по имени</li>
    <li><b>ScrollView</b> с <b>VerticalStackLayout</b> для отображения списка контактов</li>
    <li><b>Button</b> для добавления нового контакта</li>
</ul>

<h3>Загрузка, поиск и сортировка (Загрузка, поиск и сортировка)</h3>

```c#
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
```

<p>Объяснение работы с базой данных:</p>
<ul>
    <li>Метод <b>LoadContacts(string search = "")</b> загружает и отображает контакты, сортируя их по имени и фильтруя по поисковому запросу</li>
    <li>Метод <b>OnSearchChanged(object sender, EventArgs e)</b> обновляет список контактов при изменении текста в поле поиска</li>
    <li>Метод <b>OnAddClicked(object sender, EventArgs e)</b> открывает страницу для добавления нового контакта</li>
    <li>Метод <b>AddContactView(Contact cont)</b> создает визуальное представление контакта с возможностью редактирования и удаления</li>
</ul>

<ul>
    <li><mark>Where</mark> - фильтрует коллекцию по заданному условию</li>
    <li><mark>OrderBy</mark> - сортирует коллекцию по указанному ключу</li>
</ul>

<br>
<h2>➕ СТРАНИЦА ДОБАВЛЕНИЯ / РЕДАКТИРОВАНИЯ (AddEditContactPage.xaml)</h2>

```xml
<ContentPage xmlns="http://schemas.microsoft.com/dotnet/2021/maui"
             xmlns:x="http://schemas.microsoft.com/winfx/2009/xaml"
             x:Class="ContactApp.Pages.AddEditContactPage"
             Title="AddEditContactPage">
    <VerticalStackLayout Padding="20">
        <Entry x:Name="NameEntry" Placeholder="Имя"/>
        <Entry x:Name="PhoneEntry" Placeholder="Телефон"/>
        <Entry x:Name="EmailEntry" Placeholder="Email"/>

        <Button Text="Сохранить"
                Clicked="OnSaveClicked"/>
    </VerticalStackLayout>
</ContentPage>
```

<p>Элементы страницы:</p>
<ul>
    <li><b>Entry</b> для ввода имени, телефона и email контакта</li>
    <li><b>Button</b> для сохранения контакта</li>
</ul>

<h3>AddEditContactPage.xaml.cs</h3>

```c#
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
```

<p>Объяснение работы страницы:</p>
<ul>
    <li>Конструктор принимает необязательный параметр <b>Contact mycontact</b> для редактирования существующего контакта или создания нового</li>
    <li >Метод <b>OnSaveClicked(object sender, EventArgs e)</b> сохраняет контакт в базе данных и возвращается на страницу списка контактов</li>
</ul>