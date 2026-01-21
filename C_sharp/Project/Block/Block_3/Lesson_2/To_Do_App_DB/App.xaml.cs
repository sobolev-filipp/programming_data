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