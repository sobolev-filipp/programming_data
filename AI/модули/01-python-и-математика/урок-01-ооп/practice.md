# Урок 1.1. Практика на занятии: ООП

> ### 💻 Как работать с кодом урока
> Весь код пишем в **одном ноутбуке** (`.ipynb`, в Google Colab или Jupyter), разбивая на **ячейки**: один логический шаг — одна ячейка, запускаем сверху вниз. Переменные сохраняются между ячейками, поэтому импорты, данные, модель и обучение держим в **разных** ячейках. Домашку продолжаем в **том же** ноутбуке (раздел `## Самостоятельная работа`), а ответы на 🤔-вопросы пишем в **Markdown-ячейках**. Отдельные `.py`-файлы не нужны — они пригодятся только для большого проекта (Модуль 9). Перед сдачей запусти ноутбук целиком («Перезапустить и выполнить всё»), чтобы проверить, что всё работает по порядку.


> Всё пишем в одной тетрадке `lesson-1-1-oop.ipynb`.

---

## Задание 1. Собака — вместе с классом (15 минут)

Пишем класс `Dog` **на глазах у учеников**, объясняя каждый шаг.

### Шаг 1. Пустой класс

```python
class Dog:
    pass

buddy = Dog()
print(buddy)
print(type(buddy))
```

Обсуждаем: `type(buddy)` показывает, что это объект класса `Dog`.

### Шаг 2. Конструктор `__init__`

```python
class Dog:
    def __init__(self, name, age):
        self.name = name
        self.age = age

buddy = Dog("Бадди", 3)
print(buddy.name)   # Бадди
print(buddy.age)    # 3
```

### Шаг 3. Метод `bark`

```python
class Dog:
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def bark(self):
        print(f"{self.name} говорит: Гав!")

buddy = Dog("Бадди", 3)
buddy.bark()
```

**Спрашиваем класс:**
> Что произойдёт, если в `bark` забыть `self`?

Демонстрируем:
```python
class Dog:
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def bark():     # без self
        print("Гав!")

buddy = Dog("Бадди", 3)
buddy.bark()    # TypeError!
```

Объясняем сообщение об ошибке: «`bark()` не ожидает аргументов, но получил 1». Этот 1 — сам объект `buddy`, который Python хочет вложить в первый параметр.

### Шаг 4. Метод, который меняет состояние

```python
class Dog:
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def bark(self):
        print(f"{self.name} говорит: Гав!")

    def have_birthday(self):
        self.age += 1
        print(f"С днём рождения, {self.name}! Теперь тебе {self.age}.")

buddy = Dog("Бадди", 3)
buddy.have_birthday()    # С днём рождения, Бадди! Теперь тебе 4.
buddy.have_birthday()    # С днём рождения, Бадди! Теперь тебе 5.
print(buddy.age)         # 5
```

Подсветите: **состояние объекта сохраняется между вызовами методов**. Атрибут `age` живёт в объекте, и каждый вызов `have_birthday` его увеличивает.

---

## Задание 2. Класс `Book` (15 минут)

Ученики пишут **сами**. Преподаватель ходит, подсказывает.

### Условие

Реализовать класс `Book` со следующим:

1. В конструкторе принимает: `title` (название, строка), `author` (автор, строка), `pages` (количество страниц, число).
2. Хранит атрибут `current_page` — текущая страница. Изначально 1.
3. Метод `read(n)` — «прочитать n страниц». Увеличивает `current_page` на n. Если результат больше `pages` — выводит «Книга прочитана!» и ставит `current_page = pages`.
4. Метод `progress()` — возвращает строку вида `«35 / 200 страниц (17%)»`.

### Эталон

```python
class Book:
    def __init__(self, title, author, pages):
        self.title = title
        self.author = author
        self.pages = pages
        self.current_page = 1

    def read(self, n):
        self.current_page += n
        if self.current_page >= self.pages:
            self.current_page = self.pages
            print(f"Книга «{self.title}» прочитана!")

    def progress(self):
        percent = int(self.current_page / self.pages * 100)
        return f"{self.current_page} / {self.pages} страниц ({percent}%)"


book = Book("Война и мир", "Лев Толстой", 1225)
print(book.progress())    # 1 / 1225 страниц (0%)
book.read(100)
print(book.progress())    # 101 / 1225 страниц (8%)
book.read(2000)           # Книга «Война и мир» прочитана!
print(book.progress())    # 1225 / 1225 страниц (100%)
```

### Доработка: `__repr__`

После того как класс готов, добавляем:

```python
def __repr__(self):
    return f"Book(title={self.title!r}, author={self.author!r}, pages={self.pages})"
```

И показываем, как теперь работает `print(book)`.

---

## Задание 3. Каталог книг (10 минут)

Создаём 4–5 книг, помещаем в список, обрабатываем циклом.

```python
books = [
    Book("Война и мир", "Лев Толстой", 1225),
    Book("Преступление и наказание", "Фёдор Достоевский", 671),
    Book("Мастер и Маргарита", "Михаил Булгаков", 480),
    Book("Гарри Поттер и философский камень", "Дж. Роулинг", 332),
]

# 1. Прочитать у каждой книги первые 50 страниц
for book in books:
    book.read(50)

# 2. Показать прогресс каждой
for book in books:
    print(f"{book.title}: {book.progress()}")
```

**Спросить класс:**
> Как найти **самую длинную** книгу?

Обсуждение → ответ:
```python
longest = books[0]
for book in books:
    if book.pages > longest.pages:
        longest = book
print(f"Самая длинная: {longest.title} — {longest.pages} страниц")
```

**Альтернатива (для самых быстрых):**
```python
longest = max(books, key=lambda b: b.pages)
```

> Не пугайтесь `lambda` — это «функция в одну строку», подробнее разберём в **следующем уроке (1.2)**.

---

## Задание 4. Наследование — `EBook` (20 минут)

Электронная книга — это «частный случай» книги. У неё есть **всё то же**, плюс:
- атрибут `file_size_mb` — размер файла в МБ;
- атрибут `format` — формат файла («PDF», «EPUB», «FB2»);
- свой `__repr__`, который добавляет формат.

### Эталон

```python
class EBook(Book):
    def __init__(self, title, author, pages, file_size_mb, format):
        super().__init__(title, author, pages)
        self.file_size_mb = file_size_mb
        self.format = format

    def __repr__(self):
        return (
            f"EBook(title={self.title!r}, author={self.author!r}, "
            f"pages={self.pages}, format={self.format!r}, "
            f"size={self.file_size_mb}MB)"
        )


ebook = EBook("1984", "Джордж Оруэлл", 328, 1.2, "EPUB")
print(ebook)
ebook.read(50)
print(ebook.progress())   # это унаследовали от Book — работает!
```

### Обсудить с классом

- Что наследуется автоматически? **Все методы и атрибуты родителя.**
- Зачем `super().__init__(title, author, pages)`? **Чтобы не дублировать код, который уже есть в `Book`.**
- Что переопределили? **`__repr__`.**
- Что добавили нового? **`file_size_mb`, `format`.**

### Усложнение (если время осталось)

Добавить класс `AudioBook(Book)`:
- атрибут `duration_hours` — длительность в часах;
- атрибут `narrator` — имя чтеца;
- переопределить метод `progress()` так, чтобы он показывал не страницы, а часы прослушано из общей длительности.

---

## Тайминг урока (90 минут)

| Время | Блок |
|------:|------|
| 0–10 | Введение «зачем классы» |
| 10–25 | Задание 1 (`Dog` вместе с классом) |
| 25–40 | Задание 2 (`Book` самостоятельно) |
| 40–50 | `__repr__`, доработка `Book` |
| 50–60 | Задание 3 (каталог книг) |
| 60–80 | Задание 4 (наследование `EBook`) |
| 80–88 | Итоги, где ООП в ML |
| 88–90 | ДЗ, вопросы |
