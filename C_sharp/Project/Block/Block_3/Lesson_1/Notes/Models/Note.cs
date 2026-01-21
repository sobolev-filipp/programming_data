using System;
using System.Collections.Generic;
using System.Text;
using SQLite;

namespace Notes.Models
{
    internal class Note
    {
        [PrimaryKey, AutoIncrement]
        public int Id { get; set; }

        public string Text { get; set; }
    }
}
