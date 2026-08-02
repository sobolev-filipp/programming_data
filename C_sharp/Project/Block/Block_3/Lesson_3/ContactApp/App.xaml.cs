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