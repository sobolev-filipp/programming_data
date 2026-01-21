using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

using SQLite;

namespace To_Do_App_DB.Models
{
    public class TodoItem
    {
        [PrimaryKey, AutoIncrement]
        // Уникальный идентификатор задачи
        public int Id { get; set; }

        // Текст задачи
        public string Text { get; set; }

        // Статус выполнения задачи
        public bool IsDone { get; set; }
    }
}