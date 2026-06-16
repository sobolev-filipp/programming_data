# Урок 3.1. Самостоятельная работа на уроке

> Решаешь **на уроке**, в оставшиеся ~12 минут.
> Тетрадка: продолжай `lesson-3-1-first-ml.ipynb`. Раздели заголовком: `## Самостоятельная работа`.

---

## Уровень 1. База

### 1.1. «Назови тип задачи»

Для каждой задачи запиши в Markdown-ячейке: это **регрессия**, **классификация** или **кластеризация**?

1. Предсказать цену дома по характеристикам.
2. Определить, болен ли человек гриппом, по симптомам.
3. Разбить покупателей магазина на 5 групп без заранее заданных меток.
4. Предсказать, сколько прохожих будет на улице завтра.
5. Распознать рукописную цифру (0-9) на картинке.
6. Найти **группы похожих фильмов** среди 10000.

### 1.2. Повторить классификацию Iris

Самостоятельно (без подсматривания) напиши 6 строк ML-кода:
1. Загрузить Iris.
2. Разделить на train/test (test_size=0.3, random_state=0).
3. Создать `LogisticRegression(max_iter=200)`.
4. Обучить.
5. Предсказать.
6. Посчитать точность.

### 1.3. Поэкспериментируй с `random_state`

Запусти **то же самое** с **тремя разными** `random_state` (0, 42, 100). Будет ли точность одинаковой?

**Запиши в комментарии**, что заметил.

---

## Уровень 2. Своими руками

### 2.1. Свой train/test без `train_test_split`

Попробуй разделить данные **сам**, без scikit-learn:

```python
# Перемешать индексы
np.random.seed(42)
indices = np.random.permutation(len(X))

# Первые 80% — train, остальные — test
split = int(0.8 * len(X))
train_idx = indices[:split]
test_idx = indices[split:]

X_train_manual = X[train_idx]
X_test_manual = X[test_idx]
y_train_manual = y[train_idx]
y_test_manual = y[test_idx]

# Обучаем и проверяем
model = LogisticRegression(max_iter=200)
model.fit(X_train_manual, y_train_manual)
print("Точность (ручное разделение):", model.score(X_test_manual, y_test_manual))
```

**Это поможет понять**, что `train_test_split` делает внутри.

### 2.2. Сравни 3 модели

Для одного и того же разделения данных обучи **три модели** и сравни точность:
- `LogisticRegression(max_iter=200)`
- `KNeighborsClassifier(n_neighbors=5)`
- `DecisionTreeClassifier(random_state=42)` (импортировать из `sklearn.tree`)

Какая работает лучше?

---

## Уровень 3. Со звёздочкой

### 3.1. Попробуй сделать классификацию **на своём** датасете

Возьми датасет с Titanic. Очисти его (как в 2.2). Из числовых столбцов сделай `X`, целевой `y = df['Survived']`.

```python
import pandas as pd
url = "https://raw.githubusercontent.com/datasciencedojo/datasets/master/titanic.csv"
df = pd.read_csv(url)

# Простая очистка
df['Age'] = df['Age'].fillna(df['Age'].median())
df = df.dropna(subset=['Embarked'])

# Числовые признаки + закодировать пол
df['Sex_num'] = (df['Sex'] == 'female').astype(int)
features = ['Pclass', 'Sex_num', 'Age', 'SibSp', 'Parch', 'Fare']
X = df[features]
y = df['Survived']

# Разделение
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Модель
model = LogisticRegression(max_iter=1000)
model.fit(X_train, y_train)
print("Точность на Titanic:", model.score(X_test, y_test))
```

Какую точность получил?

### 3.2. Регрессия (другой тип задачи)

Возьми California Housing — предскажи **цену** (это регрессия).

```python
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error

url = "https://raw.githubusercontent.com/ageron/handson-ml2/master/datasets/housing/housing.csv"
df = pd.read_csv(url)

# Очистка
df['total_bedrooms'] = df['total_bedrooms'].fillna(df['total_bedrooms'].median())
df = df.drop(columns=['ocean_proximity'])    # пока не работаем с категориями

X = df.drop(columns=['median_house_value'])
y = df['median_house_value']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

model = LinearRegression()
model.fit(X_train, y_train)
predictions = model.predict(X_test)

# Метрика регрессии — RMSE
rmse = np.sqrt(mean_squared_error(y_test, predictions))
print(f"RMSE: {rmse:.0f}")
```

**RMSE** — среднеквадратичная ошибка. У нас цены до 500000, ошибка ~70000 — то есть модель ошибается **в среднем** на 70 тысяч долларов. Не идеально, но это **простая** модель без feature engineering.

---

## Что преподаватель проверит

| Что | Зачёт ✅ |
|-----|----------|
| Правильно отвечает на 4+ из 6 типов задач (1.1) | |
| Повторил классификацию Iris сам (1.2) | |
| Заметил, что random_state влияет на разделение (1.3) | |
| Если есть Уровень 2 — сравнил модели | |
| Если есть Уровень 3 — обучил модель на Titanic / Housing | |

**Минимум:** все 3 задачи Уровня 1.
