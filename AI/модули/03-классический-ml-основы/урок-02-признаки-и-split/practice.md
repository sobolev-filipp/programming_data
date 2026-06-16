# Урок 3.2. Практика (вместе с преподавателем)

> Тетрадка: `lesson-3-2-features.ipynb`.

---

## Что мы будем делать на уроке

**Задача:** улучшить нашу Titanic-модель из Урока 3.1.

На прошлом уроке мы получили **точность 80%** простой моделью. Сегодня — **правильно подготовим признаки** и попробуем подняться выше.

**План:**
1. **Сравним** прошлый подход (где мы вручную закодировали только Sex) с **полным one-hot encoding** всех категорий.
2. Применим **стратифицированное разделение**.
3. Введём **валидационную выборку**.

> **Цель:** к концу урока поднять точность с 80% до 82-83%.

---

## Импорты

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
sns.set_theme()

from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score

# Загружаем Titanic
url = "https://raw.githubusercontent.com/datasciencedojo/datasets/master/titanic.csv"
df = pd.read_csv(url)

# Базовая очистка
df['Age'] = df['Age'].fillna(df['Age'].median())
df['Embarked'] = df['Embarked'].fillna(df['Embarked'].mode()[0])
df = df.drop(columns=['Cabin'])

print(df.shape)         # (891, 11)
print(df.dtypes)
```

> Базовую очистку взяли из Урока 2.2.

---

## Задание 1. Одна Titanic — с разными признаками (18 минут)

**Задача:** сравнить три подхода к признакам.

### 1.1. Версия А — только числовые признаки

**Что хотим:** обучить модель только на «простых» числовых столбцах, без преобразования категорий.

**Какие признаки берём:**
- `Pclass` — класс билета.
- `Age` — возраст.
- `SibSp` — число братьев/сестёр.
- `Parch` — число родителей/детей.
- `Fare` — цена билета.

**Какие НЕ берём:** `Sex`, `Embarked` (это строки, модель не поймёт).

```python
features_A = ['Pclass', 'Age', 'SibSp', 'Parch', 'Fare']
X_A = df[features_A]
y = df['Survived']

X_train, X_test, y_train, y_test = train_test_split(X_A, y, test_size=0.2, random_state=42)

model_A = LogisticRegression(max_iter=1000)
model_A.fit(X_train, y_train)
acc_A = model_A.score(X_test, y_test)
print(f"Версия А (без Sex): точность {acc_A:.4f}")
```

**Ожидаемое:** ~0.66 (66%). Низковато.

**Что это значит:** без `Sex` (одного из самых важных признаков) модель работает плохо.

### 1.2. Версия Б — добавляем Sex через label encoding

**Что хотим:** добавить пол как простое 0/1 (как мы делали в Уроке 3.1).

```python
df['Sex_num'] = (df['Sex'] == 'female').astype(int)

features_B = ['Pclass', 'Sex_num', 'Age', 'SibSp', 'Parch', 'Fare']
X_B = df[features_B]

X_train, X_test, y_train, y_test = train_test_split(X_B, y, test_size=0.2, random_state=42)

model_B = LogisticRegression(max_iter=1000)
model_B.fit(X_train, y_train)
acc_B = model_B.score(X_test, y_test)
print(f"Версия Б (с Sex): точность {acc_B:.4f}")
```

**Ожидаемое:** ~0.80 (80%). Скачок на 14%!

**Что это значит:** `Sex` — **очень важный** признак. Без него модель «слепая».

### 1.3. Версия В — one-hot для Sex И Embarked

**Что хотим:** ещё добавить порт посадки правильным способом — через one-hot.

```python
# Создадим копию для версии В
df_C = df.copy()

# One-hot для Sex и Embarked
df_C = pd.get_dummies(df_C, columns=['Sex', 'Embarked'])

print("Новые столбцы:")
print(df_C.columns.tolist())
```

**Что увидим:** появятся столбцы `Sex_female`, `Sex_male`, `Embarked_C`, `Embarked_Q`, `Embarked_S`.

```python
features_C = ['Pclass', 'Age', 'SibSp', 'Parch', 'Fare',
              'Sex_female', 'Sex_male',
              'Embarked_C', 'Embarked_Q', 'Embarked_S']
X_C = df_C[features_C]

X_train, X_test, y_train, y_test = train_test_split(X_C, y, test_size=0.2, random_state=42)

model_C = LogisticRegression(max_iter=1000)
model_C.fit(X_train, y_train)
acc_C = model_C.score(X_test, y_test)
print(f"Версия В (one-hot): точность {acc_C:.4f}")
```

**Ожидаемое:** ~0.81 (81%). Прирост ещё **+1%**.

**Сравним все три:**
```python
print(f"Версия А (без Sex):           {acc_A:.4f}")
print(f"Версия Б (Sex как 0/1):       {acc_B:.4f}")
print(f"Версия В (one-hot Sex+Embarked): {acc_C:.4f}")
```

**Что это значит:**
- Добавление **важного признака** (Sex) дало **+14%**.
- One-hot всех категорий — **+1%**.
- **Итог:** правильно подготовленные признаки **сильно** влияют на качество.

> На последующих уроках мы добавим ещё **новые признаки** (FamilySize, Title) и доберёмся до **83-85%**.

---

## Задание 2. Стратифицированный split (15 минут)

**Что хотим:** показать, что без стратификации доли классов могут «съехать», и это снижает точность.

### 2.1. Проверим без stratify

```python
# Берём наши лучшие признаки (версия В)
X = X_C
y = df['Survived']

# Обычный split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

print("Доля выживших в исходных данных:", y.mean())
print("Доля выживших в train:", y_train.mean())
print("Доля выживших в test:", y_test.mean())
```

**Ожидаемое:**
```
Доля выживших в исходных данных: 0.3838
Доля выживших в train: 0.3792
Доля выживших в test: 0.4022
```

**Что это значит:** доли разные. В test попало **немного больше** выживших.

### 2.2. С stratify=y

```python
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

print("Доля выживших в train:", y_train.mean())
print("Доля выживших в test:", y_test.mean())
```

**Ожидаемое:**
```
Доля выживших в train: 0.3834
Доля выживших в test: 0.3855
```

**Что это значит:** доли почти совпадают с исходными. **Идеально**.

### 2.3. Сравним точности

```python
# Без stratify
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
model = LogisticRegression(max_iter=1000)
model.fit(X_train, y_train)
print(f"Без stratify: {model.score(X_test, y_test):.4f}")

# Со stratify
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42, stratify=y)
model = LogisticRegression(max_iter=1000)
model.fit(X_train, y_train)
print(f"Со stratify: {model.score(X_test, y_test):.4f}")
```

**Что увидим:** точность **немного** меняется (на 1-2%). На Titanic эффект небольшой, но на **сильно несбалансированных** данных (например, 95% / 5%) — критический.

> **Правило:** при классификации **всегда** добавляйте `stratify=y`. Это привычка.

---

## Задание 3. Три выборки: train + val + test (17 минут)

**Что хотим:** разделить данные на **три** части и сравнить **несколько моделей** на val, выбрать лучшую, проверить на test.

### 3.1. Разделение в 2 шага

```python
# Шаг 1: 80% в train_val, 20% в test
X_train_val, X_test, y_train_val, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

# Шаг 2: из train_val — 75% в train, 25% в val (это 60% и 20% от всех)
X_train, X_val, y_train, y_val = train_test_split(
    X_train_val, y_train_val, test_size=0.25, random_state=42, stratify=y_train_val
)

print(f"Всего: {len(y)}")
print(f"Train: {len(y_train)} ({len(y_train)/len(y):.1%})")
print(f"Val:   {len(y_val)} ({len(y_val)/len(y):.1%})")
print(f"Test:  {len(y_test)} ({len(y_test)/len(y):.1%})")
```

**Ожидаемое:**
```
Всего: 891
Train: 534 (59.9%)
Val:   178 (20.0%)
Test:  179 (20.1%)
```

### 3.2. Сравним три модели на val

```python
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier

models = {
    'LogisticRegression': LogisticRegression(max_iter=1000),
    'DecisionTree': DecisionTreeClassifier(random_state=42),
    'RandomForest': RandomForestClassifier(n_estimators=100, random_state=42),
}

print("Сравнение на val:")
for name, model in models.items():
    model.fit(X_train, y_train)
    val_acc = model.score(X_val, y_val)
    print(f"  {name}: {val_acc:.4f}")
```

**Ожидаемое:**
```
Сравнение на val:
  LogisticRegression: 0.7978
  DecisionTree:       0.7472
  RandomForest:       0.8146
```

**Какая лучше?** RandomForest — 81.5%.

### 3.3. Финальная оценка лучшей модели на test

```python
best_model = RandomForestClassifier(n_estimators=100, random_state=42)
best_model.fit(X_train, y_train)
test_acc = best_model.score(X_test, y_test)
print(f"\nФинальная точность на test: {test_acc:.4f}")
```

**Ожидаемое:** что-то близкое к 81-83%.

**Что мы только что сделали:**
1. **Train** — обучили 3 модели.
2. **Val** — сравнили, выбрали RandomForest.
3. **Test** — **один раз** оценили лучшую модель.

> **Это профессиональный workflow.** На test мы ничего не выбирали — это честная оценка.

---

## Итог урока

1. **One-hot encoding** превращает категории в столбцы 0/1. Используем `pd.get_dummies`.
2. **`Sex` и `Embarked`** — категориальные. Без них модель «слепая» или ошибается.
3. **`stratify=y`** при `train_test_split` — обязательная привычка для классификации.
4. **Val выборка** нужна для **сравнения** моделей. Test — для **финальной** проверки.

---

## Тайминг

| Время | Блок |
|------:|------|
| 0–10 | Повторение |
| 10–22 | Типы признаков (теория) |
| 22–40 | One-hot (теория + Задание 1) |
| 40–55 | Стратификация (Задание 2) |
| 55–72 | Val (Задание 3) |
| 72–85 | Самостоятельная |
| 85–90 | Итоги |
