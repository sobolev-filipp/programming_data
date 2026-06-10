# Урок 1.3. Утилитные функции Python для ML — резюме

> Открой этот файл, чтобы быстро вспомнить, что было на уроке.

---

## Главные мысли

1. Эти функции — твой **рабочий инструмент** до конца курса. С ними каждый кусок ML-кода читается легко.
2. `zip`/`enumerate` — два «брата» цикла. Используй их вместо `range(len(...))`.
3. `sorted` ≠ `sort`. Первая возвращает новый список, вторая меняет на месте.
4. `all([])` = `True`, `any([])` = `False`. Помни про этот подвох.

---

## Функции-друзья цикла

```python
range(start, stop, step)      # последовательность чисел
zip(a, b, c, ...)             # параллельный обход
enumerate(coll, start=0)      # индекс + значение
```

**Шаблоны использования:**
```python
for i in range(10):
    ...

for x, y in zip(xs, ys):
    ...

for i, x in enumerate(items, start=1):
    ...

# Комбо: индекс + пара
for i, (x, y) in enumerate(zip(xs, ys)):
    ...
```

---

## Сортировка

```python
sorted(coll)                              # новый список
coll.sort()                               # на месте

sorted(coll, reverse=True)                # по убыванию
sorted(coll, key=len)                     # по ключу-функции
sorted(coll, key=lambda x: x.field)       # по полю объекта
sorted(coll, key=lambda x: (x.a, x.b))    # по нескольким полям
```

`reversed(coll)` — просто перевернуть (не сортирует).

---

## Агрегации

```python
sum(coll, start=0)            # сумма
min(coll, key=...)            # минимум, можно с ключом
max(coll, key=...)            # максимум, можно с ключом
len(coll)                     # длина
abs(x)                        # модуль
round(x, n)                   # округление до n знаков

all(условие for x in coll)    # все ли True
any(условие for x in coll)    # хоть один True
```

**Идиома: «найти элемент с минимальным/максимальным полем»**
```python
best = max(students, key=lambda s: s.score)
worst = min(books, key=lambda b: b.pages)
```

---

## Методы строк (мини-шпаргалка)

```python
# Разбить / склеить
"a,b,c".split(",")            # ['a', 'b', 'c']
",".join(["a", "b", "c"])     # 'a,b,c'
"привет мир".split()          # по пробелам

# Чистка
"  привет  ".strip()
"   привет".lstrip()
"привет   ".rstrip()

# Регистр
"Hello".lower()               # 'hello'
"Hello".upper()               # 'HELLO'
"hello".title()               # 'Hello'

# Замена / поиск
"hello".replace("l", "L")     # 'heLLo'
"hello.py".endswith(".py")    # True
"image.jpg".startswith("img") # False
"hello".find("ll")            # 2 (или -1)
"hello".count("l")            # 2

# Проверки
"123".isdigit()               # True
"abc".isalpha()               # True
"a1".isalnum()                # True
```

---

## f-строки (форматирование)

```python
name = "Иван"
val = 3.14159

f"{name}"                     # 'Иван'
f"{val:.2f}"                  # '3.14'
f"{val:.4f}"                  # '3.1416'
f"{val * 100:.1f}%"           # '314.2%'
f"{name:<10}"                 # выровнять влево, ширина 10
f"{name:>10}"                 # вправо
f"{name:^10}"                 # по центру
```

---

## Главные ошибки

| Ошибка | Что не так | Как исправить |
|--------|-----------|---------------|
| `for i in range(len(lst)): ... lst[i]` | Громоздко | `for x in lst:` или `for i, x in enumerate(lst):` |
| `nums.sort()` и потом `if nums.sort() == ...` | `sort()` возвращает `None`! | Использовать `sorted(nums)` |
| `dict[unknown_key]` | KeyError | `dict.get(key, default)` |
| `print(map(str, nums))` | Выведет `<map object>` | `print(list(map(str, nums)))` или генератор |
| Открыть файл без `with` | Может не закрыться | Всегда `with open(...) as f:` |

---

## Что должно остаться в голове после урока

1. Я уверенно использую `zip`, `enumerate`, `sorted`, `sum`/`min`/`max`, `all`/`any`.
2. Я знаю разницу между `sort` и `sorted`.
3. Я могу разобрать CSV-строку через `split` и собрать обратно через `join`.
4. Я форматирую число до 2 знаков через f-строку `f"{x:.2f}"`.
5. Я никогда не открываю файл без `with`.

---

## К следующему уроку

Следующий урок — **Урок 1.4. NumPy**. Первая «настоящая» ML-библиотека. Готовься: вместо списков мы начнём работать с **массивами** (`ndarray`), которые быстрее в десятки раз. И будем активно использовать всё, что прошли в Уроках 1.1–1.3.

Можно перед уроком пробежаться по [официальному NumPy quickstart](https://numpy.org/doc/stable/user/quickstart.html) (через переводчик).
