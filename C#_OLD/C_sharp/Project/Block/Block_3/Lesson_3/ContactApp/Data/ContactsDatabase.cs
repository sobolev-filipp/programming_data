using SQLite;
using ContactApp.Models;

namespace ContactApp.Data
{
    internal class ContactsDatabase
    {
        SQLiteConnection db;

        public ContactsDatabase(string path)
        {
            db = new SQLiteConnection(path);
            db.CreateTable<Contact>();
        }

        public List<Contact> GetContacts()
        {
            return db.Table<Contact>().ToList();
        }

        public void SaveContact(Contact contact)
        {
            if (contact.Id == 0)
                db.Insert(contact);
            else
                db.Update(contact);
        }

        public void DeleteContact(Contact contact)
        {
            db.Delete(contact);
        }
    }
}
