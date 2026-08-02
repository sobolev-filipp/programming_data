using System;
using System.Collections.Generic;
using System.Text;
using SQLite;
namespace ContactApp.Models
{
    internal class Contact
    {
        [PrimaryKey, AutoIncrement]
        public int Id { get; set; }

        public string Name { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }
    }
}
