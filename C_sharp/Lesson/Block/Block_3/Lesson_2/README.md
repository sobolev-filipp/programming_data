<h1>Занятие 2. Приложение «To-Do List с базой данных»</h1>

<br>
<h2>1️⃣ Структура проекта To-Do List</h2>

```
ToDoApp/
 ├── MainPage.xaml        // экран приложения
 ├── MainPage.xaml.cs     // логика
 ├── Models/
 │     └── TodoItem.cs    // задача
 ├── Data/
 │     └── TodoDatabase.cs // база данных
 └── App.xaml.cs          // запуск приложения
```

<br>
<p>Далее необходимо <a href="../../../../../C_sharp_guide/README.md#link_sqlite">установить SQLite</a></p>

<br>
<h2>2️⃣ Модель данных (Model/TodoItem.cs)</h2>

```c#
using SQLite;

public class TodoItem
{
    [PrimaryKey, AutoIncrement]
    public int Id { get; set; }

    public string Text { get; set; }

    public bool IsDone { get; set; }
}
```

<p>В данной моделе используется <b>[PrimaryKey, AutoIncrement]</b></p>
<ul>
    <li><b>PrimaryKey</b> → это <b>главный ключ</b></li>
    <li><b>AutoIncrement</b> → номер создаётся автоматически</li>
</ul>

<p>Также:</p>
<ul>
    <li><b>Id</b> → уникальный идентификатор задачи</li>
    <li><b>Text</b> → текст задачи</li>
    <li><b>IsDone</b> → выполнена ли задача (true/false)</li>
</ul>

<br>
<h2>3️⃣ Работа с базой данных (Data/TodoDatabase.cs)</h2>

```c#
using SQLite;
using ToDoApp.Models;

namespace ToDoApp.Data;

public class TodoDatabase
{
    SQLiteConnection db;

    public TodoDatabase(string path)
    {
        db = new SQLiteConnection(path);
        db.CreateTable<TodoItem>();
    }

    public List<TodoItem> GetAll()
    {
        return db.Table<TodoItem>().ToList();
    }

    public List<TodoItem> GetDone()
    {
        return db.Table<TodoItem>().Where(t => t.IsDone).ToList();
    }

    public List<TodoItem> GetNotDone()
    {
        return db.Table<TodoItem>().Where(t => !t.IsDone).ToList();
    }

    public void Add(string text)
    {
        db.Insert(new TodoItem
        {
            Text = text,
            IsDone = false
        });
    }

    public void Update(TodoItem item)
    {
        db.Update(item);
    }

    public void Delete(TodoItem item)
    {
        db.Delete(item);
    }
}
```

<h3>Объяснение</h3>
<ul>
    <li><b>SQLiteConnection db;</b> → подключение к базе данных SQLite</li>
    <li><b>public TodoDatabase(string path)</b> → конструктор класса, который принимает путь к файлу базы данных</li>
    <li><b>db.CreateTable<TodoItem>()</b> → создание таблицы для модели TodoItem</li>
    <li><b>GetAll()</b> → получение всех задач из базы данных</li>
    <li><b>GetDone()</b> → получение выполненных задач</li>
    <li><b>GetNotDone()</b> → получение невыполненных задач</li>
    <li><b>Add(string text)</b> → добавление новой задачи в базу данных</li>
    <li><b>Update(TodoItem item)</b> → обновление существующей задачи в базе данных</li>
    <li><b>Delete(TodoItem item)</b> → удаление задачи из базы данных</li>
</ul>

<br>
<h2>4️⃣ Подключение БД в приложении (App.xaml.cs)</h2>

```c#
using SQLite;
using To_Do_App_DB.Data;

namespace To_Do_App_DB;

public partial class App : Application
{
	// Экземпляр базы данных, доступный по всему приложению
	public static TodoDatabase Database;
	public App()
	{
		InitializeComponent();

		// Инициализируем базу данных
		string path = Path.Combine(
            FileSystem.AppDataDirectory,
            "todo.db"
        );

		// Создаем экземпляр базы данных
        Database = new TodoDatabase(path);
	}

	protected override Window CreateWindow(IActivationState? activationState)
	{
		return new Window(new NavigationPage(new MainPage()));
	}
}
```

> База создаётся один раз и доступна всему приложению

<h3>Объяснение</h3>
<ul>
    <li><b>public static TodoDatabase Database;</b> → статическое свойство для доступа к базе данных из любого места приложения</li>
    <li><b>FileSystem.AppDataDirectory</b> → безопасная папка для хранения данных приложения</li>
    <li><b>"todo.db"</b> → имя файла базы данных</li>
    <li><b>Database = new TodoDatabase(path);</b> → инициализация базы данных при запуске приложения</li>
</ul>

<h4>Полная цепочка работы с базой данных</h4>

```
App.xaml.cs
   ↓
Создали путь к файлу
   ↓
new TodoDatabase(path)
   ↓
Конструктор TodoDatabase(string path)
   ↓
SQLiteConnection(path)
   ↓
Файл БД создан / открыт
    ↓
db.CreateTable<TodoItem>()
    ↓
Таблица создана / проверена
```

<h4>Почему path НЕ объявлен внутри класса</h4>
<ul>
    <li>Путь зависит от устройства</li>
    <li>Позволяет легко изменить расположение файла базы данных при необходимости</li>
    <li>Обеспечивает гибкость в управлении файлами базы данных для разных сред (например, тестирование, продакшн)</li>
</ul>

<br>
<h2>5️⃣ Логика главной страницы (MainPage.xaml.cs)</h2>

```c#
<?xml version="1.0" encoding="utf-8" ?>
<ContentPage xmlns="http://schemas.microsoft.com/dotnet/2021/maui"
             xmlns:x="http://schemas.microsoft.com/winfx/2009/xaml"
             x:Class="ToDoApp.MainPage"
             Title="To-Do List">

    <ScrollView>
        <VerticalStackLayout Padding="20" Spacing="10">

            <!-- Ввод задачи -->
            <Entry x:Name="TaskEntry"
                   Placeholder="Введите задачу" />

            <Button Text="Добавить"
                    Clicked="OnAddClicked"/>

            <!-- Фильтры -->
            <HorizontalStackLayout Spacing="10">
                <Button Text="Все"
                        Clicked="OnShowAll"/>
                <Button Text="Выполнено"
                        Clicked="OnShowDone"/>
                <Button Text="Не выполнено"
                        Clicked="OnShowNotDone"/>
            </HorizontalStackLayout>

            <!-- Список задач -->
            <VerticalStackLayout x:Name="TasksLayout"
                                 Spacing="10"/>

        </VerticalStackLayout>
    </ScrollView>
</ContentPage>
```

> Задачи будут добавляться в TasksLayout вручную

<h3>Объяснение интерфейса</h3>
<ul>
    <li><b>Entry</b> → ввод текста задачи</li>
    <li><b>Button</b> → кнопки для добавления задачи и фильтрации</li>
    <li><b>TasksLayout</b> → контейнер для отображения списка задач</li>
</ul>

<br>
<h3>Логика страницы (MainPage.xaml.cs)</h3>

```c#
using ToDoApp.Models;

namespace ToDoApp;

public partial class MainPage : ContentPage
{
    public MainPage()
    {
        InitializeComponent();
        LoadTasks(App.Database.GetAll());
    }

    void OnAddClicked(object sender, EventArgs e)
    {
        if (string.IsNullOrWhiteSpace(TaskEntry.Text))
            return;

        App.Database.Add(TaskEntry.Text);
        TaskEntry.Text = "";

        LoadTasks(App.Database.GetAll());
    }

    void LoadTasks(List<TodoItem> tasks)
    {
        TasksLayout.Children.Clear();

        foreach (var task in tasks)
        {
            var checkBox = new CheckBox
            {
                IsChecked = task.IsDone
            };

            var label = new Label
            {
                Text = task.Text,
                VerticalOptions = LayoutOptions.Center
            };

            checkBox.CheckedChanged += (s, e) =>
            {
                task.IsDone = e.Value;
                App.Database.Update(task);
            };

            var deleteBtn = new Button
            {
                Text = "❌",
                WidthRequest = 50
            };

            deleteBtn.Clicked += (s, e) =>
            {
                App.Database.Delete(task);
                LoadTasks(App.Database.GetAll());
            };

            var row = new HorizontalStackLayout
            {
                Spacing = 10,
                Children = { checkBox, label, deleteBtn }
            };

            TasksLayout.Children.Add(row);
        }
    }

    void OnShowAll(object sender, EventArgs e)
    {
        LoadTasks(App.Database.GetAll());
    }

    void OnShowDone(object sender, EventArgs e)
    {
        LoadTasks(App.Database.GetDone());
    }

    void OnShowNotDone(object sender, EventArgs e)
    {
        LoadTasks(App.Database.GetNotDone());
    }
}
```

<h3>Объяснение логики</h3>
<ul>
    <li><b>LoadTasks(List&lt;TodoItem&gt; tasks)</b> → метод для загрузки и отображения задач в интерфейсе</li>
    <li>Для каждой задачи создаются элементы: <b>CheckBox</b> (для отметки выполнения), <b>Label</b> (для текста задачи) и <b>Button</b> (для удаления задачи)</li>
    <li>Обработчики событий для <b>CheckBox</b> и <b>Button</b> обновляют базу данных при изменении состояния задачи или её удалении</li>
    <li>Методы <b>OnShowAll</b>, <b>OnShowDone</b>, и <b>OnShowNotDone</b> фильтруют задачи по их состоянию выполнения</li>
</ul>