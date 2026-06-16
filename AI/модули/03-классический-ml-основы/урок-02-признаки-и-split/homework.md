# Урок 3.2. Самостоятельная работа на уроке

> **Не пугайся!** Это закрепление того, что мы только что разобрали. Все подсказки — внутри.
> Тетрадка: продолжай `lesson-3-2-features.ipynb`. Раздели заголовком: `## Самостоятельная работа`.

---

## Уровень 1. Закрепление

### 1.1. Найди категориальные признаки в датасете (5 минут)

> **Что от тебя требуется:** в датасете Wine (вино) определить, какие признаки **числовые**, а какие **категориальные**.

**Загрузить:**
```python
from sklearn.datasets import load_wine

wine = load_wine(as_frame=True)
df_wine = wine.frame
df_wine.head()
```

**Шаги:**
1. Распечатай `df_wine.dtypes`.
2. Найди столбцы с типом `object` — это потенциальные категориальные.
3. Найди столбцы с числами, но **малым** количеством уникальных значений (используй `df_wine[col].nunique()`).

**Запиши в Markdown:**
```markdown
Числовые признаки: [список]
Категориальные признаки (object): [список]
Числа-категории (мало уникальных): [список]
```

> **Подсказка:** Wine — простой датасет, все признаки уже числовые. Это нормально! Главное — научиться **проверять**.

---

### 1.2. One-hot encoding для маленького примера (5 минут)

> **Что от тебя требуется:** создать DataFrame с категориальными столбцами и применить one-hot.

**Шаги:**

1. **Создай DataFrame:**
```python
df_demo = pd.DataFrame({
    'name':  ['Иван', 'Мария', 'Пётр', 'Ольга', 'Алексей'],
    'class': ['9А', '9Б', '10А', '9А', '10Б'],
    'fav_color': ['синий', 'красный', 'синий', 'зелёный', 'красный']
})
df_demo
```

2. **Сделай one-hot** для `class` и `fav_color`:
```python
encoded = pd.get_dummies(df_demo, columns=['class', 'fav_color'])
encoded
```

**Что должно получиться:** таблица, где появились столбцы `class_9А`, `class_9Б`, `class_10А`, `class_10Б`, `fav_color_синий`, `fav_color_красный`, `fav_color_зелёный`. В каждой строке — ровно по **одной 1** в столбцах `class_*` и ровно по **одной 1** в `fav_color_*`.

**Запиши в Markdown:**
```markdown
Сколько новых столбцов появилось? [число]
Сколько единичек в каждой строке для class_*? [число]
```

---

### 1.3. Stratified split — проверка долей (5 минут)

> **Что от тебя требуется:** на Titanic сделать **два** разделения — обычное и со `stratify=y` — и сравнить, насколько доли классов **сохраняются**.

**Дано (загрузка и базовая очистка):**
```python
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split

url = "https://raw.githubusercontent.com/datasciencedojo/datasets/master/titanic.csv"
df = pd.read_csv(url)
df['Age'] = df['Age'].fillna(df['Age'].median())
df['Embarked'] = df['Embarked'].fillna(df['Embarked'].mode()[0])

df['Sex_num'] = (df['Sex'] == 'female').astype(int)
features = ['Pclass', 'Sex_num', 'Age', 'SibSp', 'Parch', 'Fare']
X = df[features]
y = df['Survived']
```

**Шаги:**

1. **Обычный split:**
```python
X_train1, X_test1, y_train1, y_test1 = train_test_split(X, y, test_size=0.2, random_state=1)
print(f"Без stratify, test: {y_test1.mean():.4f}")
```

2. **Со stratify:**
```python
X_train2, X_test2, y_train2, y_test2 = train_test_split(X, y, test_size=0.2, random_state=1, stratify=y)
print(f"Со stratify, test:  {y_test2.mean():.4f}")
print(f"В исходных:         {y.mean():.4f}")
```

**Что увидишь:** со stratify доля выживших в test почти совпадает с исходной.

**Запиши в Markdown:**
```markdown
В исходных данных выживших: [процент]
Без stratify в test: [процент]
Со stratify в test: [процент]
Вывод: со stratify доли сохраняются лучше.
```

---

## Уровень 2. Применение

### 2.1. Полный workflow Titanic «как у профессионала» (10 минут)

> **Что от тебя требуется:** обучить модель на Titanic **со всеми лучшими практиками**.

**Чек-лист (что должно быть):**
- ✅ Заполнены NaN.
- ✅ Категориальные признаки one-hot encoded.
- ✅ Split со `stratify`.
- ✅ Лог-регрессия с `max_iter=1000`.
- ✅ Метрика accuracy.

**Шаги:**

1. **Загрузка и очистка** (можно скопировать из урока).

2. **One-hot encoding для Sex, Embarked, Pclass:**
```python
df_encoded = pd.get_dummies(df, columns=['Sex', 'Embarked', 'Pclass'])
```
> Заметь: даже `Pclass`, хотя там числа 1/2/3, мы делаем one-hot. Это **категория** (см. урок).

3. **Выбери X и y:**
```python
y = df_encoded['Survived']

# Берём все числовые и one-hot, исключаем явно ненужное
exclude = ['Survived', 'PassengerId', 'Name', 'Ticket', 'Cabin']
features = [col for col in df_encoded.columns if col not in exclude]
X = df_encoded[features]
print("Признаки:", features)
print("X shape:", X.shape)
```

4. **Split со stratify:**
```python
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)
```

5. **Модель и оценка:**
```python
model = LogisticRegression(max_iter=1000)
model.fit(X_train, y_train)
acc = model.score(X_test, y_test)
print(f"Точность: {acc:.4f}")
```

**Что должно получиться:** точность **0.81 или выше**.

---

### 2.2. Сравнение Pclass: «как число» vs «как категория» (7 минут)

> **Что от тебя требуется:** показать, что **one-hot для Pclass** даёт ту же или лучшую точность, чем оставить его как число 1/2/3.

**Две версии — одинаковая модель, разное представление Pclass:**

**Версия 1: Pclass как число**
```python
df_v1 = df.copy()
df_v1['Sex_num'] = (df_v1['Sex'] == 'female').astype(int)
df_v1 = pd.get_dummies(df_v1, columns=['Embarked'])
features_v1 = ['Pclass', 'Sex_num', 'Age', 'SibSp', 'Parch', 'Fare', 'Embarked_S', 'Embarked_C', 'Embarked_Q']
X_v1 = df_v1[features_v1]
y_v1 = df_v1['Survived']

X_train, X_test, y_train, y_test = train_test_split(X_v1, y_v1, test_size=0.2, random_state=42, stratify=y_v1)
model = LogisticRegression(max_iter=1000)
model.fit(X_train, y_train)
print(f"Pclass как число: {model.score(X_test, y_test):.4f}")
```

**Версия 2: Pclass как категория (one-hot)**
```python
df_v2 = df.copy()
df_v2['Sex_num'] = (df_v2['Sex'] == 'female').astype(int)
df_v2 = pd.get_dummies(df_v2, columns=['Embarked', 'Pclass'])
features_v2 = ['Sex_num', 'Age', 'SibSp', 'Parch', 'Fare',
               'Embarked_S', 'Embarked_C', 'Embarked_Q',
               'Pclass_1', 'Pclass_2', 'Pclass_3']
X_v2 = df_v2[features_v2]

X_train, X_test, y_train, y_test = train_test_split(X_v2, y_v1, test_size=0.2, random_state=42, stratify=y_v1)
model = LogisticRegression(max_iter=1000)
model.fit(X_train, y_train)
print(f"Pclass как категория: {model.score(X_test, y_test):.4f}")
```

**Что увидишь:** разница небольшая, но **в правильную сторону**.

**Запиши вывод:**
```markdown
Pclass как число: [процент]
Pclass как one-hot: [процент]
Вывод: для категорий one-hot обычно работает лучше.
```

---

## Уровень 3. Со звёздочкой

### 3.1. Три выборки и сравнение моделей (10 минут)

> **Что от тебя требуется:** правильно разделить на 3 части и сравнить **4 модели**.

**Шаги:**

1. **Раздели в 2 шага:**
```python
X_train_val, X_test, y_train_val, y_test = train_test_split(X, y, test_size=0.2, random_state=42, stratify=y)
X_train, X_val, y_train, y_val = train_test_split(X_train_val, y_train_val, test_size=0.25, random_state=42, stratify=y_train_val)
```

2. **Сравни 4 модели на val:**
```python
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.neighbors import KNeighborsClassifier

models = {
    'LogReg': LogisticRegression(max_iter=1000),
    'KNN-5': KNeighborsClassifier(n_neighbors=5),
    'DecTree': DecisionTreeClassifier(random_state=42),
    'RandomForest': RandomForestClassifier(n_estimators=100, random_state=42)
}

print("Сравнение на val:")
val_scores = {}
for name, model in models.items():
    model.fit(X_train, y_train)
    s = model.score(X_val, y_val)
    val_scores[name] = s
    print(f"  {name}: {s:.4f}")
```

3. **Найди лучшую:**
```python
best_name = max(val_scores, key=val_scores.get)
print(f"\nЛучшая на val: {best_name}")
```

4. **Оцени лучшую на test:**
```python
best = models[best_name]
print(f"Финальная точность на test: {best.score(X_test, y_test):.4f}")
```

---

### 3.2. Применить тот же workflow к Wine (классификация вина) (8 минут)

> **Что от тебя требуется:** провести **тот же** workflow на другом датасете.

**Шаги:**
1. Загрузи `load_wine`.
2. Поскольку Wine простой, можно сразу сделать train/test (без val).
3. Со `stratify=y`.
4. Обучи LogisticRegression + ещё одну модель.

```python
from sklearn.datasets import load_wine

X, y = load_wine(return_X_y=True)
print(f"Форма: X={X.shape}, y={y.shape}")
print(f"Классы: {np.bincount(y)}")  # сколько каждого класса

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42, stratify=y)

model = LogisticRegression(max_iter=10000)
model.fit(X_train, y_train)
print(f"Точность: {model.score(X_test, y_test):.4f}")
```

**Что должно получиться:** точность **0.95+**.

---

## Что преподаватель проверит

| Что | Зачёт ✅ |
|-----|----------|
| Понимает, что такое категориальный признак | |
| Делает one-hot через `pd.get_dummies` | |
| Использует `stratify` в split | |
| **Если есть Уровень 2** — workflow Titanic > 0.80 точность | |
| **Если есть Уровень 3** — корректно разделил на 3 части | |

**Минимум:** Уровень 1 целиком.
