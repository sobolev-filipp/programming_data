using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

using SQLite;
using To_Do_App_DB.Models;

namespace To_Do_App_DB.Data
{
    public class TodoDatabase
    {
        SQLiteConnection db;

        public TodoDatabase(string path)
        {
            // Создаем подключение к базе данных
            db = new SQLiteConnection(path);
            db.CreateTable<TodoItem>();
        }

        public List<TodoItem> GetAll()
        {
            // Получаем все элементы задачи
            return db.Table<TodoItem>().ToList();
        }

        public List<TodoItem> GetDone()
        {
            // Получаем выполненные элементы задачи
            return db.Table<TodoItem>().Where(t => t.IsDone).ToList();
        }

        public List<TodoItem> GetNotDone()
        {
            // Получаем невыполненные элементы задачи
            return db.Table<TodoItem>().Where(t => !t.IsDone).ToList();
        }

        public void Add(string text)
        {
            // Добавляем новый элемент задачи
            db.Insert(new TodoItem
            {
                Text = text,
                IsDone = false
            });
        }

        public void Update(TodoItem item)
        {
            // Обновляем элемент задачи
            db.Update(item);
        }

        public void Delete(TodoItem item)
        {
            // Удаляем элемент задачи
            db.Delete(item);
        }
    }
}