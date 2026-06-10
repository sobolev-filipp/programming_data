# Урок 1.1. Повторение Python для ML — резюме

> Открой этот файл, чтобы быстро вспомнить, что было на уроке.

---

## Главные мысли

1. В ML много данных → надо писать **компактно**.
2. Главный инструмент компактности — **comprehensions**.
3. Списки и словари — это **ссылки**. Копировать через `.copy()`.
4. Файлы открываем **только через `with`**.
5. Классы будем больше **читать**, чем писать самим.

---

## Comprehensions — шпаргалка

```python
# List
[выражение for элемент in коллекция if условие]

# Dict
{ключ: значение for ... in ... if ...}

# Set
{выражение for ... in ... if ...}

# Генератор (как list, но в скобках)
(выражение for ... in ...)
```

**Примеры:**
```python
[x ** 2 for x in range(10)]                  # квадраты
[x for x in nums if x > 0]                   # фильтр
{i: i ** 2 for i in range(5)}                # словарь
sum(x for x in nums)                         # генератор внутри sum
```

---

## Списки — частые операции

```python
nums.append(x)        # в конец
nums.insert(0, x)     # на позицию
nums.remove(x)        # удалить первое вхождение x
last = nums.pop()     # вытащить с конца
nums.sort()           # сортировка на месте
sorted(nums)          # новый отсортированный список
nums[1:4]             # срез
nums[::-1]            # перевернуть (копия)
nums.copy()           # КОПИЯ, не ссылка
```

---

## Словари — частые операции

```python
d["key"]                    # KeyError, если ключа нет
d.get("key", "default")     # безопасно
d["new"] = value            # добавить/изменить
"key" in d                  # есть ли ключ
del d["key"]
for k, v in d.items(): ...
```

---

## Функции — продвинутое

```python
# Аргументы по умолчанию
def f(x, y=10): ...

# Переменное число
def f(*args, **kwargs):
    print(args)       # кортеж позиционных
    print(kwargs)     # словарь именованных

# lambda
double = lambda x: x * 2

# Type hints
def avg(nums: list[float]) -> float: ...
```

---

## ООП — минимум

```python
class Student:
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def greet(self):
        print(f"Привет, я {self.name}")

# Наследование
class Pupil(Student):
    def __init__(self, name, age, school):
        super().__init__(name, age)
        self.school = school
```

**Запомни:**
- `__init__` — конструктор.
- `self` — текущий объект.
- `super()` — родительский класс.
- `__repr__` — как объект выглядит при печати.

---

## Файлы

```python
# Чтение
with open("file.txt", "r", encoding="utf-8") as f:
    content = f.read()           # весь файл строкой
    # или:
    for line in f:               # построчно
        print(line.strip())

# Запись
with open("out.txt", "w", encoding="utf-8") as f:
    f.write("hello\n")
```

---

## Что должно остаться в голове после урока

1. Я могу переписать любой простой цикл через comprehension.
2. Я знаю про разницу `list` vs ссылка и могу скопировать список.
3. Я понимаю, что такое `*args` и `**kwargs`.
4. Я могу прочитать чужой класс из туториала.
5. Я никогда не открываю файл без `with`.

---

## Что обязательно полистать перед след. уроком

Следующий урок — **NumPy**. Главная библиотека для работы с числами в ML. Если хочешь подготовиться — пробегись по [официальному quickstart](https://numpy.org/doc/stable/user/quickstart.html) (можно через переводчик).

Базовая идея: вместо обычных списков мы будем использовать **массивы NumPy** — это в 100 раз быстрее и удобнее для математики.
