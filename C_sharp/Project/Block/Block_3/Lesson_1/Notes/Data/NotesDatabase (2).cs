using System;
using System.Collections.Generic;
using System.Text;
using SQLite;
using Notes.Models;

namespace Notes.Data
{
    internal class NotesDatabase
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
