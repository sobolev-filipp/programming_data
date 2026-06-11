# Урок 2.2. Практика на занятии: очистка данных (вместе с преподавателем)

> Тетрадка: `lesson-2-2-cleaning.ipynb`. Все задания пишем вместе.

В первой ячейке:
```python
import pandas as pd
import numpy as np

url = "https://raw.githubusercontent.com/datasciencedojo/datasets/master/titanic.csv"
df = pd.read_csv(url)
df.info()
```

> **Загрузили реальный «грязный» датасет Titanic.** На него и работаем.

---

## Задание 1. Работа с пропусками (17 минут)

### 1.1. Найти пропуски

```python
# Сколько пропусков в КАЖДОМ столбце?
df.isna().sum()
```

**Разбор:**
- `df.isna()` — таблица True/False того же размера.
- `.sum()` — суммирует по каждому столбцу, `True` = 1.
- Видим: Age 177, Cabin 687, Embarked 2.

```python
# В процентах
(df.isna().sum() / len(df) * 100).round(2)
```

**Что увидим:** Cabin = 77.10% — почти 3/4. Age = 19.87%. Embarked = 0.22%.

### 1.2. Стратегии для каждого столбца

**Cabin (77% пропусков)** → удалим столбец, толку мало.
```python
df = df.drop(columns=['Cabin'])
print(df.columns)              # Cabin исчез
```

**Age (20% пропусков)** → заполним медианой.
```python
median_age = df['Age'].median()    # ≈ 28
print("Медиана возраста:", median_age)

df['Age'] = df['Age'].fillna(median_age)
print("Пропусков теперь:", df['Age'].isna().sum())   # 0
```

**Embarked (2 пропуска)** → заполним самым частым значением.
```python
most_common = df['Embarked'].mode()[0]
print("Самый частый порт:", most_common)             # 'S' (Southampton)

df['Embarked'] = df['Embarked'].fillna(most_common)
```

### 1.3. Проверка

```python
df.isna().sum()
```

Должно быть всё по нулям. Чисто!

### 1.4. Что мы могли сделать иначе?

> **Обсудить с классом:** что было бы, если бы мы:
> - Удалили все строки с NaN? (потеряли бы 708 из 891 — большую часть данных).
> - Заполнили возраст средним вместо медианы? (среднее ≈ 30, медиана ≈ 28, разница небольшая, но если бы был выброс — могло бы быть критично).
> - Заполнили Cabin одним значением 'неизвестно'? (тогда у 77% будет одна и та же «каюта», что бессмысленно — лучше удалить столбец).

---

## Задание 2. Дубликаты и переименование (13 минут)

### 2.1. Поиск дубликатов

```python
df.duplicated().sum()              # сколько полных дубликатов
```

В Titanic полных дубликатов нет (0).

**Создадим искусственно** для демо:
```python
df_with_dupes = pd.concat([df, df.head(3)], ignore_index=True)
# к df прицепили первые 3 строки = 3 дубликата

print("Дубликатов:", df_with_dupes.duplicated().sum())   # 3
```

### 2.2. Удалить дубликаты

```python
df_clean = df_with_dupes.drop_duplicates()
print(df_clean.shape)              # вернулось как было
```

### 2.3. Дубликаты по столбцу

«Сколько пассажиров с одним и тем же именем?» — на удивление в Titanic нет.

```python
df['Name'].duplicated().sum()      # 0
```

> В реальных данных по имени часто бывают дубликаты — например, два «Иванов Иван Иванович».

### 2.4. Переименование столбцов

Переименуем по одному:
```python
df = df.rename(columns={
    'PassengerId': 'id',
    'Survived': 'survived',
    'Pclass': 'pclass'
})
print(df.columns)
```

Или все в нижний регистр:
```python
df.columns = df.columns.str.lower()
print(df.columns)
# Index(['id', 'survived', 'pclass', 'name', 'sex', 'age', ...])
```

---

## Задание 3. Типы данных (13 минут)

### 3.1. Узнать типы

```python
df.dtypes
```

**Что видим:**
- `id`, `survived`, `pclass` — `int64`.
- `age`, `fare` — `float64`.
- `name`, `sex`, `ticket`, `embarked` — `object` (строки).

### 3.2. Превратить float в int

`age` сейчас `float64` (потому что был NaN). Заполнили — можем сделать целым:

```python
df['age'] = df['age'].astype(int)
print(df.dtypes)
```

### 3.3. Категориальный тип (бонус для понимания)

В Pandas есть **категориальный** тип для столбцов с **ограниченным набором значений** — он быстрее и эффективнее по памяти.

```python
df['embarked'] = df['embarked'].astype('category')
print(df.dtypes)               # embarked category
```

> Это пригодится в Модуле 3 (ML) — многие модели любят категориальные данные.

### 3.4. Демо: число в виде строки

Создадим маленький пример:
```python
example = pd.DataFrame({
    'price_str': ['100', '200', '300', '400'],
    'price_num': [100, 200, 300, 400]
})
print(example.dtypes)
# price_str    object
# price_num    int64

# Попробуем посчитать среднее
print(example['price_num'].mean())   # 250 — работает
print(example['price_str'].mean())   # ОШИБКА: not supported for object dtype
```

Превращаем строку в число:
```python
example['price_str'] = example['price_str'].astype(int)
print(example['price_str'].mean())   # 250 — теперь работает
```

> **В реальных CSV это частая проблема.** Числа могут «приехать» как строки из-за пробелов, запятых, рублёвых знаков.

---

## Задание 4. `.apply()` (17 минут)

### 4.1. Простой пример — возрастные группы

Функция для одного значения:
```python
def age_category(age):
    if age < 18:
        return 'ребёнок'
    elif age <= 65:
        return 'взрослый'
    else:
        return 'пожилой'
```

Применяем:
```python
df['age_group'] = df['age'].apply(age_category)
df[['age', 'age_group']].head(10)
```

**Разбор:**
- `df['age'].apply(age_category)` — для каждого числа из `age` вызывается функция и возвращается категория.
- Получившийся столбец из 891 категорий записываем в `age_group`.

```python
df['age_group'].value_counts()
```

Увидим, сколько детей, взрослых, пожилых среди пассажиров.

### 4.2. С lambda

Простую функцию можно через lambda:
```python
df['fare_round'] = df['fare'].apply(lambda x: round(x, 1))
df['expensive_ticket'] = df['fare'].apply(lambda x: x > 50)
```

Проверим:
```python
df[['fare', 'fare_round', 'expensive_ticket']].head()
```

### 4.3. `apply` на всей строке

«Есть ли семья на борту?» = `SibSp + Parch > 0`:

```python
def has_family(row):
    return row['sibsp'] + row['parch'] > 0

df['has_family'] = df.apply(has_family, axis=1)
df[['name', 'sibsp', 'parch', 'has_family']].head()
```

**Разбор:**
- `df.apply(has_family, axis=1)` — для **каждой строки** (`axis=1`) вызывается функция.
- Функции передаётся **вся строка** (как Series). Можно достать любой столбец через `row['name']`.

### 4.4. Извлечение титула

В Titanic у каждого имени есть титул (Mr., Mrs., Miss., Master.). Извлечём:

```python
def get_title(name):
    # Пример имени: "Braund, Mr. Owen Harris"
    parts = name.split(', ')              # ['Braund', 'Mr. Owen Harris']
    if len(parts) < 2:
        return 'Unknown'
    title = parts[1].split('. ')[0]       # 'Mr'
    return title + '.'

df['title'] = df['name'].apply(get_title)
df['title'].value_counts()
```

**Что увидим:**
```
Mr.        517
Miss.      182
Mrs.       125
Master.     40
Dr.          7
Rev.         6
Mlle.        2
Major.       2
Col.         2
Don.         1
Mme.         1
Sir.         1
...
```

> Это новый **признак** для ML-модели. Титул многое говорит: `Master.` — мальчик, `Mrs.` — замужняя женщина и т.д.

### 4.5. Через `.str` (для строк короче)

```python
# Длина имени
df['name_length'] = df['name'].str.len()

# Есть ли 'Mrs.' в имени
df['is_mrs'] = df['name'].str.contains('Mrs.')
```

Это **короче и быстрее**, чем `.apply` с lambda. Используем `.str` всегда, когда работаем со строками.

---

## Тайминг (90 минут)

| Время | Блок |
|------:|------|
| 0–10 | Повторение |
| 10–20 | Введение, загрузка Titanic |
| 20–37 | Задание 1 (NaN) |
| 37–50 | Задание 2 (дубликаты, переименование) |
| 50–63 | Задание 3 (типы) |
| 63–80 | Задание 4 (apply) |
| 80–87 | Самостоятельная |
| 87–90 | Итоги |
