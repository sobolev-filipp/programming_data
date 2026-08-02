using To_Do_App_DB.Models;
namespace To_Do_App_DB;

public partial class MainPage : ContentPage
{

	public MainPage()
	{
		InitializeComponent();
		LoadTasks(App.Database.GetAll());
	}

	void OnAddClicked(object sender, EventArgs e)
    {
		// Добавляем новую задачу
        if (string.IsNullOrWhiteSpace(TaskEntry.Text))
            return;

        App.Database.Add(TaskEntry.Text);
        TaskEntry.Text = "";

        LoadTasks(App.Database.GetAll());
    }

    void LoadTasks(List<TodoItem> tasks)
    {
		// Загружаем задачи в интерфейс
        TasksLayout.Children.Clear();

        foreach (var task in tasks)
        {
			// Создаем элементы интерфейса для каждой задачи
            var checkBox = new CheckBox
            {
                IsChecked = task.IsDone
            };

	// Создаем метку с текстом задачи
            var label = new Label
            {
                Text = task.Text,
                VerticalOptions = LayoutOptions.Center
            };

	// Обрабатываем изменение статуса задачи
            checkBox.CheckedChanged += (s, e) =>
            {
                task.IsDone = e.Value;
                App.Database.Update(task);
            };

	// Создаем кнопку удаления задачи
            var deleteBtn = new Button
            {
                Text = "❌",
                WidthRequest = 50
            };

	// Обрабатываем нажатие кнопки удаления
            deleteBtn.Clicked += (s, e) =>
            {
                App.Database.Delete(task);
                LoadTasks(App.Database.GetAll());
            };

	// Создаем горизонтальный стек для размещения элементов задачи
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
		// Показываем все задачи
        LoadTasks(App.Database.GetAll());
    }

    void OnShowDone(object sender, EventArgs e)
    {
		// Показываем выполненные задачи
        LoadTasks(App.Database.GetDone());
    }

    void OnShowNotDone(object sender, EventArgs e)
    {
		// Показываем невыполненные задачи
        LoadTasks(App.Database.GetNotDone());
    }
}
