# Урок 2.2. Самостоятельная работа на уроке

> **Не пугайся!** Сегодня учились чистить данные. У каждой задачи будут **подсказки**.
>
> Тетрадка: продолжай `lesson-2-2-cleaning.ipynb`. Раздели: `## Самостоятельная работа`.

> **Главное правило:** после `fillna` или `drop_duplicates` — **присвой результат обратно**! `df = df.dropna()`, иначе изменения не сохранятся.

---

## Шпаргалка для быстрого старта

```python
# Найти пропуски
df.isna()                       # True/False по каждой клетке
df.isna().sum()                 # число пропусков по столбцам
df.isna().sum() / len(df) * 100 # в процентах

# Удалить пропуски
df = df.dropna()                              # все строки с любым NaN
df = df.dropna(subset=['col'])                # только если NaN в col
df = df.drop(columns=['col'])                 # конкретный столбец

# Заполнить пропуски
df['col'] = df['col'].fillna(0)
df['col'] = df['col'].fillna(df['col'].mean())
df['col'] = df['col'].fillna(df['col'].median())
df['col'] = df['col'].fillna(df['col'].mode()[0])

# Дубликаты
df.duplicated().sum()
df = df.drop_duplicates()

# Apply
df['new'] = df['col'].apply(func)              # к каждому элементу
df['new'] = df.apply(lambda row: ..., axis=1)  # к каждой строке
```

---

## Уровень 1. Обязательная база

### 1.1. Анализ пропусков

> **Что от тебя требуется:** загрузить **свежий** Titanic (не наш очищенный) и посчитать пропуски.

**Шаг 1: загрузка**
```python
import pandas as pd
url = "https://raw.githubusercontent.com/datasciencedojo/datasets/master/titanic.csv"
df_raw = pd.read_csv(url)
```

> **Подсказка:** называй переменную `df_raw` (или другую), чтобы **не путать** с `df` с урока, который мы уже почистили.

**Шаг 2: что внутри**
```python
print("Форма:", df_raw.shape)
print()
print(df_raw.info())
```

**Шаг 3: число пропусков по столбцам**
```python
print(df_raw.isna().sum())
```

> **Подсказка:** `df.isna()` даёт таблицу True/False. `.sum()` суммирует — True считается как 1.

**Шаг 4: в процентах**
```python
print((df_raw.isna().sum() / len(df_raw) * 100).round(2))
```

**Что должно получиться:**
```
Age:        177 (19.87%)
Cabin:      687 (77.10%)
Embarked:   2 (0.22%)
```

---

### 1.2. Очистка

> **Что от тебя требуется:** примени 3 разные стратегии для 3 разных столбцов.

**Стратегия для каждого столбца:**

- **Cabin** (77% пропусков) → **удалить столбец** (слишком много дыр).
- **Age** (20%) → **заполнить медианой**.
- **Embarked** (2 шт) → **заполнить самым частым значением (модой)**.

**Шаги:**

```python
# Удалить Cabin
df_raw = df_raw.drop(columns=['Cabin'])

# Заполнить Age медианой
median_age = df_raw['Age'].median()       # ≈ 28
df_raw['Age'] = df_raw['Age'].fillna(median_age)

# Заполнить Embarked модой
most_common_emb = df_raw['Embarked'].mode()[0]   # 'S'
df_raw['Embarked'] = df_raw['Embarked'].fillna(most_common_emb)
```

> **Подсказка:** `.mode()` возвращает Series (может быть несколько мод). `.mode()[0]` — берём первую.

**Проверка:**
```python
print(df_raw.isna().sum())     # везде нули!
```

> **Важно:** **не забудь** присвоить результат обратно. `df_raw['Age'].fillna(...)` без `df_raw['Age'] =` — **не сохранит** изменения!

---

### 1.3. Новый признак

> **Что от тебя требуется:** добавить столбец `family_size` (размер семьи на борту).

**Формула:** `family_size = SibSp + Parch + 1` (+1 — сам пассажир).

```python
df_raw['family_size'] = df_raw['SibSp'] + df_raw['Parch'] + 1
```

**Распечатай:**

```python
print("Среднее:", df_raw['family_size'].mean())     # ~1.90
print("Максимум:", df_raw['family_size'].max())     # 11

print("\nЧисло пассажиров в каждой группе:")
print(df_raw['family_size'].value_counts().sort_index())
```

> **Подсказка:** `.sort_index()` упорядочит по размеру семьи (1, 2, 3, ...), а не по числу пассажиров.

**Ожидаемое:**
```
1     537   ← одиночки (большинство!)
2     161
3     102
4      29
5      15
6      22
7      12
8       6
11      7
```

---

## Уровень 2. `.apply()` и категории

### 2.1. Группы цен

> **Что от тебя требуется:** превратить **число** (цена билета) в **категорию** через `.apply()`.

**Шаг 1: напиши функцию**
```python
def fare_category(fare):
    if fare < 10:
        return 'cheap'
    elif fare < 50:
        return 'medium'
    else:
        return 'expensive'
```

> **Подсказка:** функция принимает **одно число** (цену одного билета) и возвращает **строку**.

**Шаг 2: примени `.apply()` к столбцу**
```python
df_raw['fare_category'] = df_raw['Fare'].apply(fare_category)
```

> **Подсказка:** `apply(func)` означает «применить `func` к каждому элементу столбца».

**Шаг 3: посчитай**
```python
print(df_raw['fare_category'].value_counts())
```

**Ожидаемое (примерно):**
```
medium       ~400
cheap        ~340
expensive    ~150
```

---

### 2.2. «Семейный» индикатор

> **Что от тебя требуется:** создать столбец `is_alone` и посчитать доли выживших.

**Шаг 1: создай столбец**
```python
df_raw['is_alone'] = df_raw['family_size'] == 1
```

> **Подсказка:** результат сравнения = **столбец True/False**.

**Шаг 2: доли выживших среди одиночек vs семейных**
```python
alone_survived = df_raw[df_raw['is_alone'] == True]['Survived'].mean()
family_survived = df_raw[df_raw['is_alone'] == False]['Survived'].mean()

print(f"Один: {alone_survived:.2%}")
print(f"С семьёй: {family_survived:.2%}")
```

> **Подсказка про `.mean()` на 0/1:** среднее столбца из 0 и 1 = **доля единиц**! Это «доля выживших».

**Ожидаемое:**
```
Один: 30.4%
С семьёй: 50.6%
```

> **Открытие:** **с семьёй выживаемость почти в 2 раза выше!** Это пригодится в Модуле 3 как сильный **признак** для ML-модели.

---

### 2.3. Титул

> **Что от тебя требуется:** извлечь титул (Mr., Mrs., Miss., Master.) из имени пассажира.

**Пример имени:** `"Braund, Mr. Owen Harris"` → титул `"Mr."`.

**Шаг 1: напиши функцию-парсер**
```python
def get_title(name):
    # Шаг А: разбиваем по ', '
    parts = name.split(', ')              # ['Braund', 'Mr. Owen Harris']
    if len(parts) < 2:
        return 'Unknown'
    # Шаг Б: берём вторую часть, разбиваем по '. '
    title = parts[1].split('. ')[0]       # 'Mr'
    return title + '.'
```

**Шаг 2: примени к столбцу `Name`**
```python
df_raw['title'] = df_raw['Name'].apply(get_title)
```

**Шаг 3: подсчёт**
```python
print(df_raw['title'].value_counts())
```

**Ожидаемое:**
```
Mr.        517
Miss.      182
Mrs.       125
Master.     40
Dr.          7
Rev.         6
...
```

**Какие 3 самых редких?** Те, что встречаются по 1-2 раза (Capt., Mme., Sir., Don., Countess. и др.).

---

## Уровень 3. Со звёздочкой

### 3.1. Возрастная пирамида

> **Что от тебя требуется:** разбить возраст на **десятилетия** (0, 10, 20, 30, ...).

**Подсказка:**
- `age // 10` — целочисленное деление. 28 // 10 = 2.
- `× 10` — округление до 10-летий. 2 × 10 = 20.

**Шаги:**
```python
df_raw['age_decade'] = (df_raw['Age'] // 10) * 10
df_raw['age_decade'] = df_raw['age_decade'].astype(int)

print(df_raw['age_decade'].value_counts().sort_index())
```

**Ожидаемое:**
```
0     62      ← дети до 10 лет
10    102
20    220
30    167
40    89
50    48
60    19
70    6
80    1
```

> **Типовая ошибка:** пишут `Age / 10` (обычное деление) → получают `2.8, 2.5`. Правильно — `Age // 10` (две слэша).

---

### 3.2. Заполнить возраст по группам

> **Что от тебя требуется:** **умнее** заполнить пропуски в Age — медианой **по полу**.

**Идея:** мужчины и женщины разного возраста в среднем. Лучше заполнить **каждым своим средним**.

**Шаг 1: загрузи свежий Titanic** (без заполнения)
```python
df_raw = pd.read_csv(url)
```

**Шаг 2: посчитай медиану по полу**
```python
median_age_by_sex = df_raw.groupby('Sex')['Age'].median()
print(median_age_by_sex)
```

**Ожидаемое:**
```
Sex
female    27.0
male      29.0
```

**Шаг 3: заполни по группам (через `.apply` или `groupby + transform`)**

**Способ 1 (через apply):**
```python
def fill_age(row):
    if pd.isna(row['Age']):
        return median_age_by_sex[row['Sex']]
    return row['Age']

df_raw['Age'] = df_raw.apply(fill_age, axis=1)
```

> **Подсказка:** `axis=1` — функция применяется **к каждой строке**, не к столбцу.

> **Важно:** `pd.isna(value)` — **правильный способ** проверки на NaN. **НЕ** пиши `value == NaN` — это не работает!

**Способ 2 (продвинутый, через `transform`):**
```python
df_raw['Age'] = df_raw.groupby('Sex')['Age'].transform(
    lambda x: x.fillna(x.median())
)
```

**Проверка:**
```python
print(df_raw['Age'].isna().sum())     # 0
```

---

### 3.3. Найти «странные» цены

> **Что от тебя требуется:** найти пассажиров с **`Fare == 0`** и посмотреть, кто они.

```python
df_raw = pd.read_csv(url)
zero_fare = df_raw[df_raw['Fare'] == 0]
print(f"Пассажиров с Fare=0: {len(zero_fare)}")     # ~15

print("Их классы:")
print(zero_fare['Pclass'].value_counts())
```

> **Подсказка:** возможно — это **служащие компании** или **их семьи**. В реальных данных всегда есть «странные» значения, надо разбираться.

---

## Что преподаватель проверит

| Что | Зачёт ✅ |
|-----|----------|
| Работает с `isna().sum()` правильно | |
| Заполняет NaN осмысленно (медиана/мода) | |
| Использует `.apply()` хотя бы один раз | |
| Создаёт новый столбец из существующих | |
| **Уровень 3:** `groupby` или специфика NaN (`pd.isna()`) | |

**Минимум:** все 3 задачи Уровня 1.
