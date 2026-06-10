# Урок 1.4. Практика на занятии: NumPy (вместе с преподавателем)

> Тетрадка: `lesson-1-4-numpy.ipynb`. Все задания пишем вместе на проекторе.

В первой ячейке тетрадки:
```python
import numpy as np
print(np.__version__)
```

---

## Демо-разогрев: скорость NumPy vs Python (3 минуты)

```python
import time
import numpy as np

# Python — через цикл
data = list(range(10_000_000))
start = time.time()
result = [x ** 2 for x in data]
print(f"Python: {time.time() - start:.3f} сек")

# NumPy
arr = np.arange(10_000_000)
start = time.time()
result_np = arr ** 2
print(f"NumPy:  {time.time() - start:.3f} сек")
```

**Спросить класс:** во сколько раз быстрее? Обычно 30–60×. Это объяснение мотивации.

---

## Задание 1. Создание массивов и их свойства (13 минут)

### 1.1. Из списка

```python
a = np.array([1, 2, 3, 4, 5])
print(a)
print("Shape:", a.shape)
print("Dtype:", a.dtype)
print("Ndim:", a.ndim)
print("Size:", a.size)
```

### 1.2. Из вложенного списка — матрица

```python
m = np.array([
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
])
print(m)
print("Shape:", m.shape)
print("Ndim:", m.ndim)
```

### 1.3. Готовые массивы

```python
print(np.zeros(5))
print(np.ones(5))
print(np.full(5, 7))

print(np.zeros((3, 4)))     # матрица 3×4
print(np.ones((2, 3)))
```

### 1.4. `arange` и `linspace`

```python
print(np.arange(10))           # [0 1 ... 9]
print(np.arange(0, 20, 2))     # [0 2 4 ... 18]
print(np.arange(0, 1, 0.1))    # дробный шаг
print(np.linspace(0, 1, 5))    # 5 равноудалённых от 0 до 1
print(np.linspace(0, 1, 11))   # 11 точек — каждые 0.1
```

### 1.5. Случайные

```python
np.random.seed(42)             # фиксируем для воспроизводимости

print(np.random.rand(5))        # 5 случайных [0, 1]
print(np.random.rand(3, 4))     # матрица 3×4
print(np.random.randint(1, 7, 10))  # 10 «бросков кубика»
```

### 1.6. Тип данных

```python
a = np.array([1, 2, 3])
print(a.dtype)             # int64

b = np.array([1.0, 2.0, 3.0])
print(b.dtype)             # float64

c = np.array([1, 2, 3], dtype=np.float32)
print(c.dtype)             # float32

# Преобразование
print(c.astype(int))       # [1 2 3]
```

---

## Задание 2. Индексация и срезы (13 минут)

### 2.1. Одномерный массив

```python
a = np.array([10, 20, 30, 40, 50])

print(a[0])         # 10
print(a[-1])        # 50
print(a[1:4])       # [20 30 40]
print(a[::-1])      # [50 40 30 20 10]
print(a[::2])       # [10 30 50] — каждый второй
```

### 2.2. Двумерный массив

```python
m = np.array([
    [1, 2, 3, 4],
    [5, 6, 7, 8],
    [9, 10, 11, 12],
])

# Конкретный элемент
print(m[0, 0])      # 1
print(m[2, 3])      # 12
print(m[-1, -1])    # 12

# Целая строка
print(m[0])         # [1 2 3 4]
print(m[1])         # [5 6 7 8]

# Целый столбец
print(m[:, 0])      # [1 5 9]
print(m[:, -1])     # [4 8 12]

# Подматрица
print(m[0:2, 1:3])  # верхние 2 строки, 2-й и 3-й столбцы
# [[2 3]
#  [6 7]]
```

### 2.3. Изменение элементов

```python
a = np.array([10, 20, 30, 40, 50])

a[0] = 100
print(a)              # [100 20 30 40 50]

a[1:4] = 0            # сразу несколько
print(a)              # [100 0 0 0 50]
```

### 2.4. Булева индексация (главное!)

```python
a = np.array([3, -7, 5, 0, -1, 8, 2])

# Маска
mask = a > 0
print(mask)           # [True False True False False True True]

# Фильтр
print(a[a > 0])       # [3 5 8 2]
print(a[a < 0])       # [-7 -1]
print(a[a == 0])      # [0]

# Изменить только удовлетворяющие условию
a[a < 0] = 0          # все отрицательные → 0
print(a)              # [3 0 5 0 0 8 2]
```

### 2.5. Комбинация условий

```python
a = np.arange(10)     # [0 1 2 ... 9]

# Чётные и больше 3
print(a[(a > 3) & (a % 2 == 0)])     # [4 6 8]
```

> **Важно:** в NumPy для логических операций используем `&` (а не `and`), `|` (а не `or`), `~` (а не `not`). И условия в скобках!

---

## Задание 3. Векторизация (10 минут)

### 3.1. Скаляр и массив

```python
a = np.array([1, 2, 3, 4, 5])

print(a + 10)         # [11 12 13 14 15]
print(a * 2)          # [2 4 6 8 10]
print(a ** 2)         # [1 4 9 16 25]
print(a / 2)          # [0.5 1.0 1.5 2.0 2.5]
```

### 3.2. Массив и массив

```python
a = np.array([1, 2, 3])
b = np.array([10, 20, 30])

print(a + b)          # [11 22 33]
print(a * b)          # [10 40 90]
print(b / a)          # [10. 10. 10.]
```

### 3.3. Универсальные функции

```python
a = np.array([1, 4, 9, 16, 25])

print(np.sqrt(a))     # [1 2 3 4 5]
print(np.log(a))      # натуральный логарифм
print(np.exp([0, 1, 2]))   # [1 e e²]
```

### 3.4. Реальный пример: преобразование температур

```python
celsius = np.array([0, 10, 20, 30, 40])

fahrenheit = celsius * 9 / 5 + 32
print(fahrenheit)     # [32. 50. 68. 86. 104.]
```

Никаких циклов! За одну строку преобразовали все значения.

---

## Задание 4. Broadcasting (10 минут)

### 4.1. Скаляр + массив (уже знаем)

```python
a = np.array([1, 2, 3])
print(a + 10)         # [11 12 13]
```

### 4.2. Матрица + вектор-строка

```python
m = np.array([
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
])

row = np.array([10, 20, 30])

print(m + row)
# [[11 22 33]
#  [14 25 36]
#  [17 28 39]]
```

Вектор «копируется» вниз и складывается с каждой строкой.

### 4.3. Матрица + вектор-столбец

```python
col = np.array([[100], [200], [300]])   # форма (3, 1)
print(col.shape)

print(m + col)
# [[101 102 103]
#  [204 205 206]
#  [307 308 309]]
```

Вектор «копируется» вправо.

### 4.4. Нормализация — реальный пример

```python
# Каждой строке вычтем её среднее
m = np.array([
    [1, 2, 3, 4],
    [10, 20, 30, 40],
    [100, 200, 300, 400],
], dtype=float)

row_means = m.mean(axis=1).reshape(-1, 1)   # (3, 1)
print("Средние по строкам:")
print(row_means)

m_centered = m - row_means
print("Centered:")
print(m_centered)
```

> Этот паттерн — «центрирование данных» — встречается в каждой ML-задаче.

---

## Задание 5. Агрегации с `axis` (10 минут)

### 5.1. На весь массив

```python
a = np.array([1, 2, 3, 4, 5])

print("Sum:", a.sum())
print("Mean:", a.mean())
print("Min:", a.min())
print("Max:", a.max())
print("Std:", a.std())
print("Argmax (индекс):", a.argmax())
print("Argmin (индекс):", a.argmin())
```

### 5.2. По `axis` — главная фишка

```python
m = np.array([
    [1, 2, 3],
    [4, 5, 6],
])

print("Sum всего:", m.sum())            # 21
print("Sum по столбцам (axis=0):", m.sum(axis=0))   # [5 7 9]
print("Sum по строкам  (axis=1):", m.sum(axis=1))   # [6 15]
```

**Объяснить на доске:**
- `axis=0` — «схлопываем по 0-му измерению (строки)» → остаются столбцы.
- `axis=1` — «схлопываем по 1-му измерению (столбцы)» → остаются строки.

### 5.3. Реальный пример — таблица оценок

```python
grades = np.array([
    [5, 4, 5, 3],     # Иван
    [4, 5, 5, 4],     # Мария
    [3, 3, 4, 4],     # Пётр
    [4, 4, 5, 5],     # Ольга
])

students = ["Иван", "Мария", "Пётр", "Ольга"]
subjects = ["алгебра", "информатика", "химия", "физика"]

# Средняя оценка каждого ученика
print("\nСредние ученикам:")
for student, avg in zip(students, grades.mean(axis=1)):
    print(f"  {student}: {avg:.2f}")

# Средняя по каждому предмету
print("\nСредние по предметам:")
for subj, avg in zip(subjects, grades.mean(axis=0)):
    print(f"  {subj}: {avg:.2f}")

# Лучший ученик
best_idx = grades.mean(axis=1).argmax()
print(f"\nЛучший ученик: {students[best_idx]}")

# Самый трудный предмет
worst_idx = grades.mean(axis=0).argmin()
print(f"Самый трудный предмет: {subjects[worst_idx]}")
```

---

## Тайминг (90 минут, без самостоятельной части)

| Время | Блок |
|------:|------|
| 0–12 | Повторение (см. `review.md`) |
| 12–15 | Демо скорости |
| 15–28 | Задание 1 (создание массивов) |
| 28–41 | Задание 2 (индексация и срезы) |
| 41–51 | Задание 3 (векторизация) |
| 51–61 | Задание 4 (broadcasting) |
| 61–71 | Задание 5 (агрегации с axis) |
| 71–87 | Самостоятельная работа (см. `homework.md`) |
| 87–90 | Подведение итогов |
