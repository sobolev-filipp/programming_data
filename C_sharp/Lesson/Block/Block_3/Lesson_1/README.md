<h1>Занятие 1. Введение в SQLite + первое приложение «Заметки»</h1>

<br>
<h2>Структура проекта</h2>

```
Notes
│
├── Models
│   └── Note.cs          ← модель данных
│
├── Data
│   └── NotesDatabase.cs ← работа с SQLite
│
├── MainPage.xaml        ← интерфейс
├── MainPage.xaml.cs     ← логика страницы
│
└── App.xaml.cs          ← запуск приложения
```

<br>
<p>Далее необходимо <a href="../../../../../C_sharp_guide/README.md#link_sqlite">установить SQLite</a></p>

<br>
<h3>МОДЕЛЬ ДАННЫХ — Note.cs</h3>

> Объяснение: Модель — это описание одной записи в базе данных.
> Одна строка в таблице = один объект Note

```c#
using SQLite;
namespace Notes.Models
{
    public class Note
    {
        [PrimaryKey, AutoIncrement]
        public int Id { get; set; }

        public string Text { get; set; }
    }
}
```

<p>В данной моделе используется <b>[PrimaryKey, AutoIncrement]</b></p>
<ul>
    <li><b>PrimaryKey</b> → это <b>главный ключ</b></li>
    <li><b>AutoIncrement</b> → номер создаётся автоматически</li>
</ul>

<p>Аналог в SQL:</p>

```sql
Id INTEGER PRIMARY KEY AUTOINCREMENT
```

<br>
<h3>РАБОТА С БАЗОЙ — NotesDatabase.cs</h3>

```c#
using SQLite;
using Notes.Models;
namespace Notes.Data
{
    public class NotesDatabase
    {
        SQLiteConnection database;

        public NotesDatabase()
        {
            string path = Path.Combine(
                FileSystem.AppDataDirectory,
                "notes.db"
            );

            database = new SQLiteConnection(path);
            database.CreateTable<Note>();
        }

        public List<Note> GetNotes()
        {
            return database.Table<Note>()
                           .OrderByDescending(n => n.Id)
                           .ToList();
        }

        public void AddNote(string text)
        {
            database.Insert(new Note { Text = text });
        }

        public void DeleteNote(Note note)
        {
            database.Delete(note);
        }
    }
}
```

<h4>Объяснение</h4>
<ul>
    <li><b><mark>SQLiteConnection database;</mark></b> - Переменная, через которую мы общаемся с базой</li>
    <li><b><mark>FileSystem.AppDataDirectory</mark></b>
        <ul>
            <li>безопасная папка приложения</li>
            <li>работает на всех платформах</li>
        </ul>
    </li>
    <p>📌 Именно здесь создаётся <b>notes.db</b></p>
    <li><b><mark>database.CreateTable<Note>();</mark></b>
        <li>Если таблицы <b>ещё нет → создаётся</b></li>
        <li>Если <b>есть → ничего не происходит</b></li>
    </li>
    <p>✔️ Безопасно вызывать каждый раз</p>
</ul>