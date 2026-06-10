# Урок 1.3. Практика на занятии (вместе с преподавателем)

> Тетрадка: `lesson-1-3-utilities.ipynb`. Все задания пишем вместе на проекторе, ученики повторяют.

---

## Задание 1. `zip` и `enumerate` (13 минут)

### 1.1. Простой `zip`

```python
students = ["Иван", "Мария", "Пётр", "Ольга"]
grades = [4, 5, 3, 5]

for name, grade in zip(students, grades):
    print(f"{name}: {grade}")
```

### 1.2. `zip` с тремя списками

```python
students = ["Иван", "Мария", "Пётр"]
grades = [4, 5, 3]
subjects = ["алгебра", "информатика", "химия"]

for name, grade, subj in zip(students, grades, subjects):
    print(f"{name} получил {grade} по {subj}")
```

### 1.3. Построить словарь через `zip`

```python
keys = ["name", "age", "grade"]
values = ["Иван", 15, 5]

profile = dict(zip(keys, values))
# {'name': 'Иван', 'age': 15, 'grade': 5}
```

### 1.4. `enumerate` — индекс + значение

```python
languages = ["Python", "JavaScript", "Rust", "Go"]

for i, lang in enumerate(languages):
    print(f"{i}: {lang}")
```

**А с другого индекса?**
```python
for i, lang in enumerate(languages, start=1):
    print(f"{i}. {lang}")
# 1. Python
# 2. JavaScript
# 3. Rust
# 4. Go
```

### 1.5. Комбинация `enumerate` + `zip`

```python
students = ["Иван", "Мария", "Пётр"]
grades = [4, 5, 3]

for i, (name, grade) in enumerate(zip(students, grades), start=1):
    print(f"{i}. {name} — {grade}")
```

**Подсветить:** скобки `(name, grade)` обязательны, потому что `enumerate` отдаёт пары `(индекс, элемент)`, а элемент здесь — уже пара.

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

## Задание 3. Методы строк (15 минут)

### 3.1. Парсинг строки с CSV-данными

```python
line = "Иван,15,Москва,Python,5.0"

parts = line.split(",")
print(parts)
# ['Иван', '15', 'Москва', 'Python', '5.0']

name, age, city, lang, rating = parts
print(name, int(age), city, lang, float(rating))
```

### 3.2. Чистка пользовательского ввода

```python
user_input = "   Привет, Мир!   \n"

cleaned = user_input.strip()
print(repr(cleaned))   # 'Привет, Мир!'

# В нижний регистр
print(cleaned.lower())   # 'привет, мир!'
```

### 3.3. Сборка из частей

```python
parts = ["2026", "06", "10"]
date = "-".join(parts)
print(date)             # '2026-06-10'

words = ["я", "учу", "Python"]
sentence = " ".join(words)
print(sentence)         # 'я учу Python'
```

### 3.4. Замена

```python
text = "Я люблю Python. Python — это здорово!"

# Заменить все вхождения
print(text.replace("Python", "ML"))

# Заменить только первое
print(text.replace("Python", "ML", 1))
```

### 3.5. Проверки и фильтры

```python
filenames = ["model.pkl", "data.csv", "notebook.ipynb", "image.jpg", "log.txt"]

# Все CSV-файлы
csvs = [f for f in filenames if f.endswith(".csv")]
print(csvs)

# Все «модельные» файлы (.pkl, .pth, .h5, .onnx)
model_exts = [".pkl", ".pth", ".h5", ".onnx"]
models = [f for f in filenames if any(f.endswith(ext) for ext in model_exts)]
print(models)
```

> Обратите внимание — здесь сразу всё в куче: генератор списка, методы строк, `any`, `endswith`. Это и есть «реальный код».

### 3.6. f-строки с форматом числа

```python
average = 4.3576
print(f"Средний балл: {average:.2f}")     # 4.36

# Процент
ratio = 0.857
print(f"Точность: {ratio * 100:.1f}%")    # 85.7%

# Выравнивание (для таблицы)
for name, grade in [("Иван", 5), ("Мария", 4), ("Пётр", 3)]:
    print(f"{name:<10} | {grade}")
# Иван       | 5
# Мария      | 4
# Пётр       | 3
```

---

## Тайминг (90 минут, без самостоятельной части)

| Время | Блок |
|------:|------|
| 0–12 | Повторение (см. `review.md`) |
| 12–22 | Быстрая база (`theory.md` §1) |
| 22–35 | Задание 1 (`zip`, `enumerate`) |
| 35–50 | Задание 2 (агрегации) |
| 50–65 | Задание 3 (методы строк) |
| 65–85 | Самостоятельная работа (см. `homework.md`) |
| 85–90 | Подведение итогов |
