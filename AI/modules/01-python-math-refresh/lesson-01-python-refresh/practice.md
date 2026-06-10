# Урок 1.1. Практика на занятии

> Все задания делаем в **одной тетрадке Jupyter** (или Colab). В конце урока — расшарим тетрадку всем.

Файл тетрадки назвать: `lesson-1-1-python-refresh.ipynb`.

---

## Разогрев: «кто как напишет» (10 минут)

**Задача на доске:**
> Дано число N. Посчитать сумму квадратов всех чисел от 1 до N, **которые делятся на 3 без остатка**.

Дайте 3 минуты подумать. Потом 2–3 ученика записывают свои решения на доске.

### Варианты решений

**Самый длинный:**
```python
N = 20
total = 0
for x in range(1, N + 1):
    if x % 3 == 0:
        total += x ** 2
print(total)   # 9 + 36 + 81 + 144 + 225 + 324 = 819
```

**Короче:**
```python
total = sum(x ** 2 for x in range(1, N + 1) if x % 3 == 0)
```

**Самый короткий (генератор):**
```python
total = sum(x ** 2 for x in range(3, N + 1, 3))
```

Обсудите: первый понятнее новичку, третий короче и быстрее. **В ML предпочитаем второй стиль** — компактный, но читаемый.

---

## Задание 1. Переписать через comprehensions (15 минут)

Дан кусок кода. Перепиши **каждый цикл в одну строку** через comprehension.

### 1.1.

```python
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

# Возведение в куб всех чисел
result = []
for n in numbers:
    result.append(n ** 3)
print(result)
```

**Решение:**
```python
result = [n ** 3 for n in numbers]
```

### 1.2.

```python
words = ["мама", "мыла", "раму", "и", "пол"]

# Длина каждого слова, если оно длиннее 2 символов
result = []
for w in words:
    if len(w) > 2:
        result.append(len(w))
print(result)
```

**Решение:**
```python
result = [len(w) for w in words if len(w) > 2]
```

### 1.3.

```python
students = ["Иван", "Мария", "Пётр", "Ольга"]
ages = [15, 14, 16, 15]

# Словарь «имя → возраст»
result = {}
for i in range(len(students)):
    result[students[i]] = ages[i]
print(result)
```

**Решение:**
```python
result = {name: age for name, age in zip(students, ages)}
```

### 1.4. (со звёздочкой)

```python
matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

# Развернуть матрицу в один длинный список
result = []
for row in matrix:
    for x in row:
        result.append(x)
print(result)
```

**Решение:**
```python
result = [x for row in matrix for x in row]
```

> Это **вложенный comprehension**. Порядок такой же, как во вложенном цикле: сначала внешний `for row`, потом внутренний `for x`.

---

## Задание 2. Чтение CSV без pandas (10 минут)

Создаём файл `students.csv` в Colab:

```python
csv_content = """name,age,grade
Иван,15,4
Мария,14,5
Пётр,16,3
Ольга,15,4
"""

with open("students.csv", "w", encoding="utf-8") as f:
    f.write(csv_content)
```

Теперь читаем:

```python
data = []
with open("students.csv", "r", encoding="utf-8") as f:
    header = f.readline().strip().split(",")
    for line in f:
        values = line.strip().split(",")
        record = dict(zip(header, values))
        data.append(record)

print(data)
```

**Что должно вывестись:**
```python
[{'name': 'Иван', 'age': '15', 'grade': '4'},
 {'name': 'Мария', 'age': '14', 'grade': '5'},
 {'name': 'Пётр', 'age': '16', 'grade': '3'},
 {'name': 'Ольга', 'age': '15', 'grade': '4'}]
```

### Обсудить с классом:
- Почему `age` — это строка `"15"`, а не число? (потому что мы читаем текст, и Python не догадывается, что это число).
- Как сделать `age` числом? Через comprehension:

```python
for record in data:
    record["age"] = int(record["age"])
    record["grade"] = int(record["grade"])
```

Или сразу при чтении:
```python
data = []
with open("students.csv", "r", encoding="utf-8") as f:
    header = f.readline().strip().split(",")
    for line in f:
        values = line.strip().split(",")
        record = {
            "name": values[0],
            "age": int(values[1]),
            "grade": int(values[2]),
        }
        data.append(record)
```

> С Модуля 2 (Pandas) это будет одна строка: `pd.read_csv("students.csv")`. Но понимать, как оно «под капотом» — полезно.

---

## Задание 3. Простой класс `Student` (15 минут)

Реализуем класс `Student`:

```python
class Student:
    def __init__(self, name: str, age: int):
        self.name = name
        self.age = age
        self.grades: list[int] = []

    def add_grade(self, grade: int) -> None:
        if 2 <= grade <= 5:
            self.grades.append(grade)
        else:
            print(f"Оценка {grade} некорректна, не добавлена")

    def average(self) -> float:
        if not self.grades:
            return 0.0
        return sum(self.grades) / len(self.grades)

    def __repr__(self) -> str:
        return f"Student(name={self.name!r}, age={self.age}, avg={self.average():.2f})"
```

**Используем:**
```python
ivan = Student("Иван", 15)
ivan.add_grade(5)
ivan.add_grade(4)
ivan.add_grade(5)
ivan.add_grade(10)        # некорректная — не добавится
print(ivan)               # сработает __repr__
print(ivan.average())     # 4.67
```

### Объясните на уроке:
- Что такое `__init__` — конструктор.
- Что такое `self` — «текущий объект».
- Что такое `__repr__` — как объект показывается при `print` или в Jupyter.
- Зачем type hints — попросите учеников навести курсор в VS Code/Colab на функцию `add_grade` — увидите подсказку.

### Усложнение (если есть время):

Сделать класс `Class` (то есть «школьный класс»), который хранит **список студентов** и умеет считать средний балл всего класса.

```python
class SchoolClass:
    def __init__(self, name: str):
        self.name = name
        self.students: list[Student] = []

    def add_student(self, student: Student) -> None:
        self.students.append(student)

    def average(self) -> float:
        if not self.students:
            return 0.0
        return sum(s.average() for s in self.students) / len(self.students)


class_9a = SchoolClass("9А")
class_9a.add_student(ivan)
class_9a.add_student(Student("Мария", 14))
class_9a.students[1].add_grade(5)
class_9a.students[1].add_grade(5)
print(class_9a.average())
```

Обратите внимание: внутри `SchoolClass.average()` мы используем **comprehension с генератором** `sum(s.average() for s in self.students)`. Это эффективно — не создаёт промежуточный список.

---

## Тайминг урока (90 минут)

| Время | Блок |
|------:|------|
| 0–5 | Введение |
| 5–15 | Разогрев |
| 15–25 | Списки и словари — теория с примерами |
| 25–40 | Задание 1 (comprehensions) |
| 40–50 | Функции, lambda, args/kwargs — теория |
| 50–60 | Задание 2 (CSV) |
| 60–75 | Задание 3 (класс Student) |
| 75–85 | Type hints — теория + демо в IDE |
| 85–90 | ДЗ, вопросы |

> Если задание 1 идёт быстро — добавьте задачу 1.5 (со звёздочкой). Если медленно — пропустите 1.4.
