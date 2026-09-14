# Урок 1.3. Практика на занятии: функции и строки

> ### 💻 Как работать с кодом урока
> Весь код пишем в **одном ноутбуке** (`.ipynb`, в Google Colab или Jupyter), разбивая на **ячейки**: один логический шаг — одна ячейка, запускаем сверху вниз. Переменные сохраняются между ячейками, поэтому импорты, данные, модель и обучение держим в **разных** ячейках. Домашку продолжаем в **том же** ноутбуке (раздел `## Самостоятельная работа`), а ответы на 🤔-вопросы пишем в **Markdown-ячейках**. Отдельные `.py`-файлы не нужны — они пригодятся только для большого проекта (Модуль 9). Перед сдачей запусти ноутбук целиком («Перезапустить и выполнить всё»), чтобы проверить, что всё работает по порядку.


> Тетрадка: `lesson-1-3-functions-strings.ipynb`. Все задания пишем вместе на проекторе, ученики повторяют.

---

## Задание 1. `lambda` в `sort` и `max` (15 минут)

Сначала знакомимся с `lambda`, а потом сразу подаём её ключом в `sort`/`max` — там она и нужна.

### 1.1. `lambda` сама по себе

```python
square = lambda x: x ** 2
print(square(5))     # 25

add = lambda a, b: a + b
print(add(3, 4))     # 7
```

> Это обычная функция, просто в одну строку и без имени. Дальше почти всегда будем передавать её **внутрь** другой функции.

### 1.2. Сортировка списка кортежей

Список фильмов: `(название, рейтинг, год)`.

```python
movies = [
    ("Матрица", 8.7, 1999),
    ("Интерстеллар", 8.6, 2014),
    ("Зелёная миля", 9.0, 1999),
    ("Один дома", 7.7, 1990),
]
```

**Сортировка по рейтингу (по возрастанию):**
```python
movies.sort(key=lambda m: m[1])
```

**Сортировка по году (по убыванию):**
```python
movies.sort(key=lambda m: m[2], reverse=True)
```

> `key=lambda m: m[1]` читается как «сравнивай фильмы по второму элементу (рейтингу)».

### 1.3. Поиск максимума по ключу

**Найти фильм с самым высоким рейтингом:**
```python
best = max(movies, key=lambda m: m[1])
print(best)    # ('Зелёная миля', 9.0, 1999)
```

### 1.4. `sorted` vs `sort`

```python
movies.sort(key=lambda m: m[1])   # меняет сам movies, возвращает None
sorted_movies = sorted(movies, key=lambda m: m[1])   # создаёт новый список
```

### 1.5. Сортировка списка словарей (главный ML-случай)

```python
students = [
    {"name": "Иван",  "score": 82},
    {"name": "Мария", "score": 95},
    {"name": "Пётр",  "score": 74},
]

by_score = sorted(students, key=lambda s: s["score"], reverse=True)
for s in by_score:
    print(s["name"], s["score"])
```

### 1.6. Со звёздочкой: цепочка сортировок

Отсортировать сначала по году, потом по рейтингу:

```python
movies.sort(key=lambda m: (m[2], m[1]))
```

> Если ключ — кортеж, Python сортирует «по первому полю; при равенстве — по второму».

---

## Задание 2. Агрегации: `sorted`, `sum`, `min`, `max`, `all`, `any` (15 минут)

### 2.1. Дан список оценок

```python
grades = [4, 5, 3, 5, 4, 4, 5, 2, 3, 4]

print("Кол-во оценок:", len(grades))
print("Сумма:", sum(grades))
print("Средняя:", sum(grades) / len(grades))
print("Минимум:", min(grades))
print("Максимум:", max(grades))
print("Двойки есть?", 2 in grades)
print("Сколько пятёрок:", grades.count(5))
```

### 2.2. `sorted` с ключом

```python
books = [
    {"title": "Война и мир",        "pages": 1225, "year": 1869},
    {"title": "Гарри Поттер",       "pages": 332,  "year": 1997},
    {"title": "1984",               "pages": 328,  "year": 1949},
    {"title": "Мастер и Маргарита", "pages": 480,  "year": 1967},
]

# По годам, от старых к новым
by_year = sorted(books, key=lambda b: b["year"])
for b in by_year:
    print(b["year"], b["title"])
```

### 2.3. `max` / `min` с ключом

```python
longest = max(books, key=lambda b: b["pages"])
print("Самая толстая:", longest["title"])

oldest = min(books, key=lambda b: b["year"])
print("Самая старая:", oldest["title"])
```

### 2.4. `all` и `any` — проверки коллекции

```python
nums = [5, 8, 12, 3, 7]

print("Все положительные?", all(x > 0 for x in nums))     # True
print("Есть чётные?", any(x % 2 == 0 for x in nums))      # True
print("Все больше 10?", all(x > 10 for x in nums))        # False
print("Есть отрицательные?", any(x < 0 for x in nums))    # False
```

**Реальный пример: проверка валидности оценок.**
```python
def is_valid(grades):
    return all(2 <= g <= 5 for g in grades)

print(is_valid([4, 5, 3, 4]))      # True
print(is_valid([4, 5, 10, 4]))     # False
```

### 2.5. Подвох: `all([])` = `True`

```python
print(all([]))    # True   (!!)
print(any([]))    # False

print(is_valid([]))   # True — но оценок-то нет!
```

**Как защититься:**
```python
def is_valid(grades):
    return bool(grades) and all(2 <= g <= 5 for g in grades)
```

---

## Задание 3. `*args` и `**kwargs` (15 минут)

### 3.1. `*args`: сумма любого числа аргументов

```python
def sum_all(*args):
    total = 0
    for x in args:
        total += x
    return total

print(sum_all(1, 2))          # 3
print(sum_all(1, 2, 3, 4))    # 10
print(sum_all())              # 0
```

**Усложнение: среднее любого числа аргументов.**
```python
def average(*args):
    if not args:
        return 0
    return sum(args) / len(args)
```

### 3.2. `**kwargs`: «карточка профиля»

```python
def print_profile(**kwargs):
    print("--- Профиль ---")
    for key, value in kwargs.items():
        print(f"{key}: {value}")

print_profile(name="Иван", age=15, school="Школа 42", hobby="музыка")
```

### 3.3. Комбинация всего

```python
def order(table_number, *dishes, **options):
    print(f"Столик: {table_number}")
    print(f"Блюда: {', '.join(dishes)}")
    print(f"Опции: {options}")

order(7, "пицца", "салат", "сок", delivery=True, payment="карта")
# Столик: 7
# Блюда: пицца, салат, сок
# Опции: {'delivery': True, 'payment': 'карта'}
```

### 3.4. Распаковка при вызове

```python
def greet(name, age, city):
    print(f"Привет, {name}, тебе {age} лет, ты из {city}")

# Список:
data_list = ["Иван", 15, "Москва"]
greet(*data_list)

# Словарь:
data_dict = {"name": "Иван", "age": 15, "city": "Москва"}
greet(**data_dict)
```

**Подсветите для класса:**
- В `def f(*args):` звёздочка означает «собрать».
- В `f(*list)` звёздочка означает «распаковать».
- Один и тот же символ, два разных действия. Это смущает поначалу — это норма.

---

## Задание 4. Методы строк (12 минут)

### 4.1. Парсинг строки с CSV-данными

```python
line = "Иван,15,Москва,Python,5.0"

parts = line.split(",")
print(parts)
# ['Иван', '15', 'Москва', 'Python', '5.0']

name, age, city, lang, rating = parts
print(name, int(age), city, lang, float(rating))
```

### 4.2. Чистка пользовательского ввода

```python
user_input = "   Привет, Мир!   \n"

cleaned = user_input.strip()
print(repr(cleaned))   # 'Привет, Мир!'
print(cleaned.lower())   # 'привет, мир!'
```

### 4.3. Сборка из частей

```python
parts = ["2026", "06", "10"]
date = "-".join(parts)
print(date)             # '2026-06-10'

words = ["я", "учу", "Python"]
sentence = " ".join(words)
print(sentence)         # 'я учу Python'
```

### 4.4. Замена и проверки

```python
text = "Я люблю Python. Python — это здорово!"
print(text.replace("Python", "ML"))       # заменить все
print(text.replace("Python", "ML", 1))    # только первое

filenames = ["model.pkl", "data.csv", "notebook.ipynb", "image.jpg"]
csvs = [f for f in filenames if f.endswith(".csv")]
print(csvs)
```

> Обратите внимание — тут сразу всё в куче: генератор списка (с прошлого урока), метод строки `endswith`. Это и есть «реальный код».

### 4.5. f-строки с форматом числа

```python
average = 4.3576
print(f"Средний балл: {average:.2f}")     # 4.36

ratio = 0.857
print(f"Точность: {ratio * 100:.1f}%")    # 85.7%

for name, grade in [("Иван", 5), ("Мария", 4), ("Пётр", 3)]:
    print(f"{name:<10} | {grade}")
# Иван       | 5
# Мария      | 4
# Пётр       | 3
```

---

## Финальная задача: всё вместе (10 минут)

Дан список словарей:

```python
students = [
    {"name": "Иван",  "grades": [4, 5, 5, 3, 4]},
    {"name": "Мария", "grades": [5, 5, 5, 4, 5]},
    {"name": "Пётр",  "grades": [3, 3, 4, 3, 4]},
    {"name": "Ольга", "grades": [4, 4, 5, 5, 4]},
]
```

**Задача:**
> Найди топ-2 учеников по среднему баллу.

### Решение по шагам

**Шаг 1.** Добавляем средний балл в каждый словарь:
```python
for s in students:
    s["avg"] = sum(s["grades"]) / len(s["grades"])
```

**Шаг 2.** Сортируем по среднему по убыванию:
```python
students.sort(key=lambda s: s["avg"], reverse=True)
```

**Шаг 3.** Берём первые 2 и печатаем аккуратно через f-строку:
```python
for s in students[:2]:
    print(f"{s['name']}: средний {s['avg']:.2f}")
```

**В одну цепочку:**
```python
top_2 = sorted(students, key=lambda s: sum(s["grades"]) / len(s["grades"]), reverse=True)[:2]
```

> Вот эта последняя строка — типичный «короткий ML-стиль». Включает в себя `sorted`, `lambda`, `sum` от генератора. Каждая мелочь из урока — здесь.

---

## Тайминг урока (90 минут)

| Время | Блок |
|------:|------|
| 0–12 | Повторение 1.2 (см. `review.md`) |
| 12–17 | Введение «зачем» |
| 17–32 | `lambda` (Задание 1) |
| 32–47 | Агрегации (Задание 2) |
| 47–62 | `*args`/`**kwargs` (Задание 3) |
| 62–74 | Методы строк (Задание 4) |
| 74–90 | Самостоятельная работа (`homework.md`) |
</content>
