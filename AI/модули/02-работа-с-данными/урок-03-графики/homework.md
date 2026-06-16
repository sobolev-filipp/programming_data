# Урок 2.3. Самостоятельная работа на уроке

> **Не пугайся!** Графики — это вообще-то самое весёлое. У каждой задачи будут **подсказки**.
>
> Тетрадка: продолжай `lesson-2-3-graphics.ipynb`. Раздели: `## Самостоятельная работа`.

> **Главное правило:** у **каждого** графика **обязательно** заголовок (`title`) и подписи осей (`xlabel`, `ylabel`). График без подписей — это не график.

---

## Шпаргалка для быстрого старта

```python
import matplotlib.pyplot as plt
import seaborn as sns
sns.set_theme()

# Базовые графики
plt.plot(x, y)                   # линия
plt.scatter(x, y)                # точки
plt.bar(categories, values)      # столбики
plt.hist(data, bins=30)          # гистограмма

# Настройка
plt.figure(figsize=(10, 5))      # размер ДО графика
plt.title("Заголовок")
plt.xlabel("ось X")
plt.ylabel("ось Y")
plt.legend()                      # после label=
plt.grid()
plt.savefig('file.png', dpi=150)  # ДО show()!
plt.show()

# Subplots
fig, axes = plt.subplots(2, 2, figsize=(10, 8))
axes[0, 0].plot(x, y)
axes[0, 0].set_title("...")

# Seaborn
sns.heatmap(df.corr(), annot=True, cmap='coolwarm', center=0)
sns.scatterplot(data=df, x='col1', y='col2', hue='категория')
sns.countplot(data=df, x='col', hue='категория')
sns.histplot(data=df, x='col', kde=True)
```

---

## Уровень 1. Базовые графики

> Используй очищенный Titanic с урока.

### 1.1. Гистограмма цен билетов

> **Что от тебя требуется:** распределение `Fare` с 40 столбиками и подписями.

```python
plt.figure(figsize=(10, 5))
plt.hist(df['Fare'], bins=40, color='steelblue', edgecolor='black')
plt.title("Распределение цен билетов")
plt.xlabel("Цена (фунтов)")
plt.ylabel("Число пассажиров")
plt.show()
```

> **Подсказка:** `edgecolor='black'` рисует **контур** столбиков. Без него — слитый блок.

**Что увидишь:** распределение **сильно скошено** — большинство билетов дешёвые, но есть один длинный хвост к $500. Это типичный случай для цен.

---

### 1.2. Столбики по полу

> **Что от тебя требуется:** показать, сколько мужчин и сколько женщин.

**Способ 1 — через `sns.countplot` (проще):**
```python
plt.figure(figsize=(6, 4))
sns.countplot(data=df, x='Sex')
plt.title("Число пассажиров по полу")
plt.show()
```

> **Подсказка:** `countplot` сам **считает** значения в столбце.

**Способ 2 — через `plt.bar` (если хочется ручками):**
```python
counts = df['Sex'].value_counts()
plt.bar(counts.index, counts.values)
plt.title("Число пассажиров по полу")
plt.show()
```

**Что увидишь:** мужчин ~440, женщин ~250. Соотношение ~2:1.

---

### 1.3. Scatter возраст vs цена

> **Что от тебя требуется:** показать точки `(Age, Fare)`.

```python
plt.figure(figsize=(10, 6))
plt.scatter(df['Age'], df['Fare'], alpha=0.5)
plt.title("Возраст vs Цена билета")
plt.xlabel("Возраст")
plt.ylabel("Цена билета")
plt.show()
```

> **Подсказка:** `alpha=0.5` — **прозрачность 50%**. Когда точек много и они накладываются — без alpha сольются в чёрное пятно.

---

## Уровень 2. Сравнение и Seaborn

### 2.1. Гистограммы цены по полу

> **Что от тебя требуется:** построить **две** гистограммы на одной фигуре — цены билетов мужчин и женщин.

**Шаги:**

1. **Отфильтруй данные по полу:**
   ```python
   male_fare = df[df['Sex'] == 'male']['Fare']
   female_fare = df[df['Sex'] == 'female']['Fare']
   ```

2. **Нарисуй обе гистограммы на одной фигуре:**
   ```python
   plt.figure(figsize=(10, 5))
   plt.hist(male_fare, bins=40, alpha=0.6, label='Мужчины', color='steelblue')
   plt.hist(female_fare, bins=40, alpha=0.6, label='Женщины', color='pink')
   plt.title("Цена билета по полу")
   plt.xlabel("Цена")
   plt.ylabel("Число")
   plt.legend()
   plt.show()
   ```

> **Важно:** `alpha=0.6` — обязательно, иначе один график **накроет** другой.

3. **Сравни средние:**
   ```python
   print(f"Мужчины: {male_fare.mean():.2f}")
   print(f"Женщины: {female_fare.mean():.2f}")
   ```

> **Открытие:** женщины платили **в 1.5-2 раза больше** — потому что среди них больше пассажиров 1-го класса.

---

### 2.2. Subplots — 2×2 разных графика

> **Что от тебя требуется:** сделать фигуру **2×2** с четырьмя разными графиками.

**Шаги:**

```python
fig, axes = plt.subplots(2, 2, figsize=(12, 8))

# График [0, 0]: гистограмма возраста
axes[0, 0].hist(df['Age'], bins=30, color='steelblue', edgecolor='black')
axes[0, 0].set_title("Распределение возраста")
axes[0, 0].set_xlabel("Возраст")

# График [0, 1]: гистограмма цены
axes[0, 1].hist(df['Fare'], bins=40, color='salmon', edgecolor='black')
axes[0, 1].set_title("Распределение цены")
axes[0, 1].set_xlabel("Цена")

# График [1, 0]: bar — число в каждом классе
counts = df['Pclass'].value_counts().sort_index()
axes[1, 0].bar(counts.index, counts.values, color='gold')
axes[1, 0].set_title("Число пассажиров в каждом классе")
axes[1, 0].set_xlabel("Класс")

# График [1, 1]: scatter возраст vs цена
axes[1, 1].scatter(df['Age'], df['Fare'], alpha=0.5)
axes[1, 1].set_title("Age vs Fare")
axes[1, 1].set_xlabel("Возраст")
axes[1, 1].set_ylabel("Цена")

plt.tight_layout()
plt.show()
```

> **Важные моменты:**
> - `axes[i, j]` — обращение к каждому графику.
> - `set_title`, `set_xlabel` — у каждого подграфика **свои** методы с `set_`.
> - **`plt.tight_layout()`** в конце — выравнивает промежутки, иначе подписи перекроются.

---

### 2.3. Heatmap корреляций

> **Что от тебя требуется:** построить тепловую карту корреляций для числовых столбцов.

```python
numeric_df = df[['Survived', 'Pclass', 'Age', 'SibSp', 'Parch', 'Fare']]
corr = numeric_df.corr()

plt.figure(figsize=(8, 6))
sns.heatmap(corr, annot=True, cmap='coolwarm', center=0, fmt='.2f')
plt.title("Корреляции в Titanic")
plt.show()
```

> **Подсказка по аргументам:**
> - `annot=True` — **подписать** числа в клетках.
> - `cmap='coolwarm'` — холодные (синий) для отрицательных, тёплые (красный) для положительных.
> - `center=0` — середина палитры = 0.
> - `fmt='.2f'` — формат чисел (2 знака).

**Что увидишь:**

- Сильные пары — близко к красному (положительная) или синему (отрицательная).
- Диагональ всегда **1.0** (предмет сам с собой).

**Найди самые сильные пары** (по модулю) и **запиши** в комментарии.

---

## Уровень 3. Со звёздочкой

### 3.1. Iris — pairplot

> **Что от тебя требуется:** загрузить Iris и построить **сетку всех пар** через `sns.pairplot`.

```python
iris = pd.read_csv("https://raw.githubusercontent.com/mwaskom/seaborn-data/master/iris.csv")

sns.pairplot(iris, hue='species')
plt.show()
```

> **Что покажет:** **сетка графиков** — для каждой пары признаков точечный график, по диагонали — гистограмма одного признака. Точки разных цветов = разные виды.

**Что заметишь:**

- На графиках с **`petal_length` и `petal_width`** — три вида **отлично разделимы**.
- На `sepal_*` — пересекаются больше.

**В Markdown запиши:** какие 2 столбца лучше всего разделяют виды?

> **Ответ:** **petal_length и petal_width** — три вида образуют чёткие облака без перекрытий.

---

### 3.2. Свой график-отчёт

> **Что от тебя требуется:** сделать **2×2 фигуру** для Titanic, где видно паттерны выживания.

```python
fig, axes = plt.subplots(2, 2, figsize=(12, 10))

# (1) Возраст: выжил vs нет
survived = df[df['Survived'] == 1]['Age']
died = df[df['Survived'] == 0]['Age']
axes[0, 0].hist(survived, bins=30, alpha=0.6, label='Выжил', color='green')
axes[0, 0].hist(died, bins=30, alpha=0.6, label='Не выжил', color='red')
axes[0, 0].set_title("Возраст: выжившие vs нет")
axes[0, 0].set_xlabel("Возраст")
axes[0, 0].legend()

# (2) Цена: выжил vs нет
sfare = df[df['Survived'] == 1]['Fare']
dfare = df[df['Survived'] == 0]['Fare']
axes[0, 1].hist(sfare, bins=40, alpha=0.6, label='Выжил', color='green')
axes[0, 1].hist(dfare, bins=40, alpha=0.6, label='Не выжил', color='red')
axes[0, 1].set_title("Цена билета: выжившие vs нет")
axes[0, 1].set_xlabel("Цена")
axes[0, 1].legend()

# (3) Выживание по классам — countplot
sns.countplot(data=df, x='Pclass', hue='Survived', ax=axes[1, 0])
axes[1, 0].set_title("Выживание по классам")

# (4) Scatter с цветом
sns.scatterplot(data=df, x='Age', y='Fare', hue='Survived', alpha=0.6, ax=axes[1, 1])
axes[1, 1].set_title("Age vs Fare, цвет = выжил/нет")

plt.tight_layout()
plt.savefig('titanic_report.png', dpi=150, bbox_inches='tight')
plt.show()
```

> **Подсказки:**
> - У `sns.countplot` и `sns.scatterplot` есть параметр `ax=axes[i, j]` — передаём сюда **конкретный график**.
> - `plt.savefig('titanic_report.png', dpi=150, bbox_inches='tight')` — **сохраняет в файл**. `dpi=150` для качества, `bbox_inches='tight'` обрезает поля.
> - **`savefig` нужно ДО `show()`!** Иначе сохранит пустую фигуру.

---

### 3.3. Тренд (regplot)

> **Что от тебя требуется:** на Iris построить **точки + линию тренда** для двух пар признаков.

```python
# Sepal_length vs sepal_width
sns.regplot(data=iris, x='sepal_length', y='sepal_width')
plt.title("Sepal: длина vs ширина")
plt.show()
```

> **Что увидишь:** слабая отрицательная связь, линия почти горизонтальная.

```python
# Petal_length vs petal_width
sns.regplot(data=iris, x='petal_length', y='petal_width')
plt.title("Petal: длина vs ширина")
plt.show()
```

> **Что увидишь:** **сильная положительная** связь, линия идёт круто вверх.

**Вывод (запиши в Markdown):** размеры лепестков (petal) сильно связаны между собой; размеры чашелистиков (sepal) — почти нет.

---

## Что преподаватель проверит

| Что | Зачёт ✅ |
|-----|----------|
| Каждый график имеет title и подписи осей | |
| Использует разные типы графиков (hist, bar, scatter, heatmap) | |
| Применил Seaborn хотя бы один раз | |
| **Уровень 3:** pairplot или сохранение в файл | |

**Минимум:** все 3 задачи Уровня 1.

> **Помни:** **график без подписей — это не график**, а просто картинка непонятно про что.
