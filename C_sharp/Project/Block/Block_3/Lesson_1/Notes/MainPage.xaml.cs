using Notes.Models;
using Notes.Data;
using SQLite;
namespace Notes
{
    public partial class MainPage : ContentPage
    {
        NotesDatabase database;
        public MainPage()
        {
            InitializeComponent();

            database = new NotesDatabase();
            LoadNotes();
        }

        void LoadNotes()
        {
            NotesLayout.Children.Clear();

            var notes = database.GetNotes();

            foreach (var note in notes)
            {
                var frame = new Frame
                {
                    BackgroundColor = Colors.White,
                    CornerRadius = 10,
                    Padding = 10
                };

                var label = new Label
                {
                    Text = note.Text,
                    TextColor = Colors.Black,
                    FontSize = 16
                };

                var deleteButton = new Button
                {
                    Text = "Удалить",
                    BackgroundColor = Colors.LightPink
                };

                deleteButton.Clicked += (s, e) =>
                {
                    database.DeleteNote(note);
                    LoadNotes();
                };

                frame.Content = new VerticalStackLayout
                {
                    Children = { label, deleteButton }
                };

                NotesLayout.Children.Add(frame);
            }
        }

        void OnAddClicked(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(NoteEntry.Text))
                return;

            database.AddNote(NoteEntry.Text);
            NoteEntry.Text = "";
            LoadNotes();
        }
    }
}
