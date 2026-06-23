# Урок 2.3. Практика на занятии: графики (вместе с преподавателем)

> ### 💻 Как работать с кодом урока
> Весь код пишем в **одном ноутбуке** (`.ipynb`, в Google Colab или Jupyter), разбивая на **ячейки**: один логический шаг — одна ячейка, запускаем сверху вниз. Переменные сохраняются между ячейками, поэтому импорты, данные, модель и обучение держим в **разных** ячейках. Домашку продолжаем в **том же** ноутбуке (раздел `## Самостоятельная работа`), а ответы на 🤔-вопросы пишем в **Markdown-ячейках**. Отдельные `.py`-файлы не нужны — они пригодятся только для большого проекта (Модуль 9). Перед сдачей запусти ноутбук целиком («Перезапустить и выполнить всё»), чтобы проверить, что всё работает по порядку.


> Тетрадка: `lesson-2-3-graphics.ipynb`.

В первой ячейке:
```python
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns
sns.set_theme()                          # красивая тема

# Загрузим Titanic для практики
url = "https://raw.githubusercontent.com/datasciencedojo/datasets/master/titanic.csv"
df = pd.read_csv(url)

# Минимальная очистка
df = df.dropna(subset=['Age', 'Embarked'])
df.head()
```

---

## Задание 1. Четыре базовых графика (15 минут)

### 1.1. Линейный график — синус

```python
x = np.linspace(0, 10, 100)
y = np.sin(x)

plt.plot(x, y)
plt.show()
```

**Что увидим:** красивая волна синуса.

### 1.2. Точечный график — Age vs Fare

```python
plt.scatter(df['Age'], df['Fare'])
plt.show()
```

**Разбор:**
- На оси X — возраст.
- На оси Y — цена билета.
- Каждая точка — один пассажир.

**Что увидим:** облако точек. Можно ли увидеть связь? Слабую — у молодых обычно билеты дешевле.

### 1.3. Столбчатая — сколько в каждом классе

```python
class_counts = df['Pclass'].value_counts().sort_index()
print(class_counts)

plt.bar(class_counts.index, class_counts.values)
plt.show()
```

**Разбор:**
- `value_counts()` — считает уникальные значения.
- `.sort_index()` — упорядочивает по индексу (1, 2, 3 — классы).
- `class_counts.index` — это [1, 2, 3].
- `class_counts.values` — числа: сколько в каждом классе.

**Что увидим:** 3 столбика — пассажиров 3-го класса больше всего, потом 1-го, потом 2-го.

### 1.4. Гистограмма — распределение возраста

```python
plt.hist(df['Age'], bins=30)
plt.show()
```

**Что увидим:** **распределение возраста пассажиров**. Большинство 20-40 лет.

---

## Задание 2. Настройка графика (15 минут)

### 2.1. Добавим всё, что нужно

```python
plt.figure(figsize=(10, 5))
plt.hist(df['Age'], bins=30, color='steelblue', edgecolor='black')
plt.title("Распределение возраста пассажиров Titanic")
plt.xlabel("Возраст (лет)")
plt.ylabel("Число пассажиров")
plt.grid(alpha=0.3)
plt.show()
```

**Что добавилось:**
- `figsize=(10, 5)` — широкая фигура.
- `color='steelblue'` — спокойный синий цвет.
- `edgecolor='black'` — чёрный контур столбиков.
- Заголовок, подписи, сетка.

### 2.2. Две линии на одном графике + легенда

```python
x = np.linspace(0, 10, 100)

plt.figure(figsize=(10, 5))
plt.plot(x, np.sin(x), label='sin(x)', color='red', linewidth=2)
plt.plot(x, np.cos(x), label='cos(x)', color='blue', linestyle='--', linewidth=2)
plt.title("Синус и косинус")
plt.xlabel("x")
plt.ylabel("значение")
plt.legend()
plt.grid()
plt.show()
```

**Разбор:**
- `label='sin(x)'` — что показывать в легенде.
- `plt.legend()` — нарисовать легенду.
- `linestyle='--'` — штриховая.

### 2.3. Гистограммы двух групп

Сравним возраст выживших и не выживших:

```python
plt.figure(figsize=(10, 5))

survived = df[df['Survived'] == 1]['Age']
died = df[df['Survived'] == 0]['Age']

plt.hist(survived, bins=30, alpha=0.6, label='Выжил', color='green')
plt.hist(died, bins=30, alpha=0.6, label='Не выжил', color='red')
plt.title("Возраст: выжившие vs не выжившие")
plt.xlabel("Возраст")
plt.ylabel("Число пассажиров")
plt.legend()
plt.show()
```

**Разбор:**
- Отфильтровали пассажиров в две группы.
- Нарисовали **две гистограммы** на одной фигуре.
- `alpha=0.6` — **прозрачность** 60%, чтобы было видно перекрытия.

**Что увидим:** дети до 10 лет — почти все выжили (зелёный столбик высокий, красный низкий). А вот среди взрослых пропорция хуже.

### 2.4. Сохранить график

```python
plt.figure(figsize=(8, 5))
plt.hist(df['Age'], bins=30)
plt.title("Возраст пассажиров")
plt.savefig('age_distribution.png', dpi=150, bbox_inches='tight')
plt.show()
```

`bbox_inches='tight'` — обрезает лишние поля. Полезно для отчётов.

---

## Задание 3. Subplots (13 минут)

### 3.1. Простой subplot

```python
plt.figure(figsize=(12, 4))

plt.subplot(1, 3, 1)
plt.hist(df['Age'], bins=30)
plt.title("Возраст")

plt.subplot(1, 3, 2)
plt.hist(df['Fare'], bins=30)
plt.title("Цена билета")

plt.subplot(1, 3, 3)
plt.bar(df['Pclass'].value_counts().sort_index().index, df['Pclass'].value_counts().sort_index().values)
plt.title("Классы")

plt.tight_layout()
plt.show()
```

**Разбор:**
- `plt.subplot(1, 3, 1)` — сетка 1 строка × 3 столбца, мы на первом.
- Один за другим переключаемся: 1, 2, 3.
- `plt.tight_layout()` — выравнивает промежутки.

**Что увидим:** 3 графика рядом.

### 3.2. Современный способ — `plt.subplots`

```python
fig, axes = plt.subplots(2, 2, figsize=(12, 8))

axes[0, 0].hist(df['Age'], bins=30)
axes[0, 0].set_title("Возраст")

axes[0, 1].hist(df['Fare'], bins=30)
axes[0, 1].set_title("Цена билета")

axes[1, 0].bar(df['Pclass'].value_counts().sort_index().index,
               df['Pclass'].value_counts().sort_index().values)
axes[1, 0].set_title("Классы")

axes[1, 1].scatter(df['Age'], df['Fare'], alpha=0.5)
axes[1, 1].set_title("Age vs Fare")
axes[1, 1].set_xlabel("Возраст")
axes[1, 1].set_ylabel("Цена")

plt.tight_layout()
plt.show()
```

**Разбор:**
- `plt.subplots(2, 2, ...)` — сетка 2×2.
- Возвращает `fig` (фигура) и `axes` (массив графиков).
- К **каждому графику** обращаемся через `axes[i, j]`.
- У них **свои методы** с `set_`: `.set_title()`, `.set_xlabel()`, `.set_ylabel()`.

---

## Задание 4. Seaborn (15 минут)

### 4.1. Heatmap корреляций

```python
numeric_df = df[['Survived', 'Pclass', 'Age', 'SibSp', 'Parch', 'Fare']]
corr = numeric_df.corr()
print(corr)
```

Это **таблица 6×6** корреляций. Числа от -1 до 1.

Рисуем как **heatmap**:

```python
plt.figure(figsize=(8, 6))
sns.heatmap(corr, annot=True, cmap='coolwarm', center=0)
plt.title("Корреляции в Titanic")
plt.show()
```

**Разбор:**
- `annot=True` — подписать каждое число.
- `cmap='coolwarm'` — палитра «холодный → тёплый».
- `center=0` — серединой палитры считать 0.

**Что увидим:**
- `Survived` ↔ `Pclass` ≈ **-0.34** (тёмный синий) — чем выше число класса (=хуже класс), тем меньше шанс.
- `Survived` ↔ `Fare` ≈ **+0.26** (светлый красный) — дороже билет → выше шанс.
- `Pclass` ↔ `Fare` ≈ **-0.55** — обратная связь (богатый класс — дорого).
- Диагональ — всегда **1.0** (сам с собой).

**Это ML-открытие:** для предсказания `Survived` важны `Pclass` и `Fare`.

### 4.2. Scatter с раскраской

```python
plt.figure(figsize=(10, 6))
sns.scatterplot(data=df, x='Age', y='Fare', hue='Survived', alpha=0.6)
plt.title("Возраст vs Цена, цвет — выжил/нет")
plt.show()
```

**Разбор:**
- `hue='Survived'` — **раскрасить** по этому столбцу.

**Что увидим:** видно, что **большинство выживших — с дорогими билетами**.

### 4.3. Гистограмма с разделением по группам

```python
plt.figure(figsize=(10, 5))
sns.histplot(data=df, x='Age', hue='Survived', bins=30, kde=True, multiple='dodge')
plt.title("Возраст выживших и погибших")
plt.show()
```

**Параметры:**
- `kde=True` — добавить **гладкую кривую** оценки распределения.
- `multiple='dodge'` — рисовать столбики рядом (а не друг на друге).

### 4.4. `countplot` — гистограмма категорий

```python
plt.figure(figsize=(8, 4))
sns.countplot(data=df, x='Pclass', hue='Survived')
plt.title("Выживание по классам")
plt.show()
```

**Что увидим:** в каждом классе показан **счётчик выживших vs нет**. Видно: в 1 классе соотношение лучше, в 3 — хуже.

### 4.5. Pairplot — все пары признаков (бонус)

```python
sns.pairplot(df[['Survived', 'Pclass', 'Age', 'Fare']], hue='Survived')
plt.show()
```

**Что увидим:** **сетка графиков** — для каждой пары признаков точечный график. По диагонали — гистограмма одного признака.

Это **очень полезный график** — за 5 секунд видишь весь датасет.

---

## Тайминг (90 минут)

| Время | Блок |
|------:|------|
| 0–10 | Повторение |
| 10–20 | Введение, Anscombe |
| 20–35 | Задание 1 (4 типа графиков) |
| 35–50 | Задание 2 (настройка) |
| 50–63 | Задание 3 (subplots) |
| 63–78 | Задание 4 (Seaborn) |
| 78–87 | Самостоятельная |
| 87–90 | Итоги |
