# Урок 3.1. Практика: первая ML-модель (вместе с преподавателем)

> Тетрадка: `lesson-3-1-first-ml.ipynb`.

В первой ячейке:
```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
sns.set_theme()

from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, classification_report
```

> **Каждый импорт объясните!** `model_selection` — разделение данных. `linear_model` — модели типа линейных. `metrics` — оценка качества.

---

## Задание 1. Классификация Iris в 5 строк (15 минут)

Покажем сначала **результат**, потом разберём.

```python
# (1) Данные
X, y = load_iris(return_X_y=True)

# (2) Разделить на train/test
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# (3) Создать модель
model = LogisticRegression(max_iter=200)

# (4) Обучить
model.fit(X_train, y_train)

# (5) Предсказать на тесте
y_pred = model.predict(X_test)

# (6) Оценить
print("Точность:", accuracy_score(y_test, y_pred))
```

**Ожидаемый вывод:** `Точность: 1.0` (или 0.97 — почти всё угадали).

**Сразу спросить класс:** «Что мы только что сделали?»

---

## Задание 2. Разбираем workflow пошагово (20 минут)

Теперь разберём **каждый шаг** в деталях.

### 2.1. Загрузка данных

```python
from sklearn.datasets import load_iris

# Загрузим в развёрнутом виде
iris = load_iris()
print(type(iris))
print(iris.keys())
# dict_keys(['data', 'target', 'frame', 'target_names', 'feature_names', ...])
```

**Разбор:**
- `load_iris()` возвращает объект-словарь со встроенным датасетом.
- `iris.data` — таблица признаков (массив NumPy).
- `iris.target` — целевая переменная (массив).
- `iris.feature_names` — имена признаков.
- `iris.target_names` — имена классов.

```python
print("Признаки:", iris.feature_names)
# ['sepal length (cm)', 'sepal width (cm)', 'petal length (cm)', 'petal width (cm)']

print("Классы:", iris.target_names)
# ['setosa', 'versicolor', 'virginica']

print("Форма X:", iris.data.shape)
# (150, 4) — 150 цветов, 4 признака

print("Форма y:", iris.target.shape)
# (150,) — 150 меток

print("Первые 5 X:")
print(iris.data[:5])

print("Первые 5 y:")
print(iris.target[:5])
# [0 0 0 0 0] — все setosa
```

> **Заметить:** y — это **числа** (0, 1, 2), а не строки! Модели любят числа. Имена классов лежат отдельно в `target_names`.

```python
# Удобно — сразу в X и y
X, y = load_iris(return_X_y=True)
```

### 2.2. Train/Test split

> Зачем разделять? Чтобы проверить, что модель **не зубрила**, а **поняла**. Тест — это «экзамен» с **новыми** данными.

```python
from sklearn.model_selection import train_test_split

X_train, X_test, y_train, y_test = train_test_split(
    X, y,
    test_size=0.2,        # 20% в тест, 80% в трейн
    random_state=42       # фиксация случайности (для воспроизводимости)
)

print("X_train:", X_train.shape)    # (120, 4)
print("X_test:", X_test.shape)      # (30, 4)
print("y_train:", y_train.shape)    # (120,)
print("y_test:", y_test.shape)      # (30,)
```

**Разбор каждого аргумента:**
- `X, y` — наши данные.
- `test_size=0.2` — какая доля данных идёт в тест (20% = 30 цветков).
- `random_state=42` — **«зерно» случайности**. Если у всех `random_state=42`, у всех получится одинаковое разделение. Число можно выбрать любое.

> **`random_state=42`** — это «магическое число» в ML. Используется почти везде. Происхождение — из «Автостопом по галактике».

### 2.3. Выбор модели

```python
from sklearn.linear_model import LogisticRegression

model = LogisticRegression(max_iter=200)
```

**Разбор:**
- `LogisticRegression` — название модели (несмотря на «regression», это модель **классификации**, не регрессии).
- `max_iter=200` — параметр, сколько итераций обучаться. По умолчанию 100, иногда мало — мы подняли до 200.

> На этом уровне **не важно**, как именно работает Logistic Regression. Важно — что у неё есть `.fit()` и `.predict()`.

### 2.4. Обучение

```python
model.fit(X_train, y_train)
```

**Что произошло:**
- Модель «посмотрела» на 120 примеров и подобрала свои внутренние параметры.
- Теперь она **обучена**.

> `fit` ничего не возвращает (или возвращает саму модель). Главное — **изменился сам объект `model`**.

### 2.5. Предсказание

```python
y_pred = model.predict(X_test)
print("Предсказания:")
print(y_pred)
print("\nИстинные значения:")
print(y_test)
```

**Что увидим:**
```
Предсказания:
[1 0 2 1 1 0 1 2 1 1 2 0 0 0 0 1 2 1 1 2 0 2 0 2 2 2 2 2 0 0]

Истинные значения:
[1 0 2 1 1 0 1 2 1 1 2 0 0 0 0 1 2 1 1 2 0 2 0 2 2 2 2 2 0 0]
```

**Сравним глазами:** все совпали! Модель работает идеально.

### 2.6. Оценка через метрику

```python
from sklearn.metrics import accuracy_score

acc = accuracy_score(y_test, y_pred)
print(f"Точность: {acc:.2%}")
# Точность: 100.00%
```

**Разбор:**
- `accuracy_score` принимает 2 массива: истинные и предсказанные.
- Возвращает долю совпадений.
- `:.2%` форматирует число как процент с 2 знаками.

### 2.7. Подробный отчёт

```python
from sklearn.metrics import classification_report

print(classification_report(y_test, y_pred, target_names=iris.target_names))
```

**Что выведет:**
```
              precision    recall  f1-score   support

      setosa       1.00      1.00      1.00        10
  versicolor       1.00      1.00      1.00         9
   virginica       1.00      1.00      1.00        11

    accuracy                           1.00        30
   macro avg       1.00      1.00      1.00        30
weighted avg       1.00      1.00      1.00        30
```

**Разбор столбцов:**
- `precision`, `recall`, `f1-score` — это **другие метрики**. На уроке 3.6 разберём подробно.
- `support` — сколько примеров каждого класса в тесте.
- `accuracy` — общая точность.

> **Идеальная точность на Iris — это нормально.** Этот датасет «слишком простой» для моделей.

---

## Задание 3. А что без train/test split? (Бонус-демо)

Покажем, **почему важно** делить данные.

```python
# ВНИМАНИЕ: так делать НЕЛЬЗЯ! Только для демонстрации
model_cheat = LogisticRegression(max_iter=200)
model_cheat.fit(X, y)           # обучили на ВСЕХ данных
y_pred_cheat = model_cheat.predict(X)    # предсказали на ТЕХ ЖЕ данных
print("Точность 'жульничества':", accuracy_score(y, y_pred_cheat))
```

**Что увидим:** очень высокая точность. Но это **не показывает**, как модель работает на новых данных.

**Аналогия:** ученик готовится по тем же вопросам, что и на экзамене → 100%. Но он ничего не выучил, просто запомнил.

> **Никогда не оценивай модель на тех же данных, на которых обучал.** Это первое правило ML.

---

## Задание 4. Попробуем другую модель (если время есть)

Покажем, что **API одинаковый**:

```python
from sklearn.neighbors import KNeighborsClassifier

# Та же самая структура!
model = KNeighborsClassifier(n_neighbors=5)
model.fit(X_train, y_train)
y_pred = model.predict(X_test)
print("KNN точность:", accuracy_score(y_test, y_pred))
```

**Видим:** код **тот же самый**, только название модели изменилось. Это **главная фишка scikit-learn**.

---

## Тайминг (90 минут)

| Время | Блок |
|------:|------|
| 0–10 | Повторение |
| 10–22 | Что такое ML (теория) |
| 22–40 | Типы задач (теория) |
| 40–55 | Workflow + Задание 1 |
| 55–75 | Задание 2 (детальный разбор) |
| 75–87 | Самостоятельная |
| 87–90 | Итоги |
