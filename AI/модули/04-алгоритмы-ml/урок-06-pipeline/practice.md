# Урок 4.6. Практика (вместе с преподавателем)

> ### 💻 Как работать с кодом урока
> Весь код пишем в **одном ноутбуке** (`.ipynb`, в Google Colab или Jupyter), разбивая на **ячейки**: один логический шаг — одна ячейка, запускаем сверху вниз. Переменные сохраняются между ячейками, поэтому импорты, данные, модель и обучение держим в **разных** ячейках. Домашку продолжаем в **том же** ноутбуке (раздел `## Самостоятельная работа`), а ответы на 🤔-вопросы пишем в **Markdown-ячейках**. Отдельные `.py`-файлы не нужны — они пригодятся только для большого проекта (Модуль 9). Перед сдачей запусти ноутбук целиком («Перезапустить и выполнить всё»), чтобы проверить, что всё работает по порядку.


> Тетрадка: `lesson-4-6-pipeline.ipynb`.

---

## Что мы будем делать на уроке

**Сегодня — собираем профессиональный конвейер обработки Titanic:**

1. **Задание 1:** соберём **простой Pipeline** (scaler + модель) и убедимся, что он работает «как модель».

2. **Задание 2:** добавим **ColumnTransformer** — числовые масштабируем, категориальные кодируем, всё автоматически.

3. **Задание 3:** соединим **весь конвейер с GridSearch** — подбор параметров всей цепочки разом.

4. **Задание 4:** **сохраним** готовую модель в файл и загрузим обратно — как в продакшене.

> **Главная мысль:** мы не гонимся за точностью. Цель — **чистый, надёжный код** без утечек, готовый к реальному применению.

---

## Импорты

```python
import numpy as np
import pandas as pd

from sklearn.pipeline import Pipeline
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.impute import SimpleImputer
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split, cross_val_score, GridSearchCV
import joblib
```

**Что нового:**
- `Pipeline`, `ColumnTransformer` — **герои урока**.
- `SimpleImputer` — заполнение пропусков **внутри** Pipeline (вместо ручного `fillna`).
- `joblib` — сохранение модели.

---

## Задание 1. Первый Pipeline (10 минут)

### Что мы хотим сделать

Собрать простую цепочку «масштабирование → модель» и убедиться, что Pipeline работает как обычная модель.

### 1.1. Данные

```python
url = "https://raw.githubusercontent.com/datasciencedojo/datasets/master/titanic.csv"
df = pd.read_csv(url)

# Пока возьмём только числовые признаки (без пропусков для простоты)
df['Sex'] = df['Sex'].map({'male': 0, 'female': 1})
df['Age'] = df['Age'].fillna(df['Age'].median())
X = df[['Pclass', 'Sex', 'Age', 'Fare']]
y = df['Survived']

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y)
```

### 1.2. Собираем Pipeline

```python
pipe = Pipeline([
    ('scaler', StandardScaler()),               # шаг 1: масштабирование
    ('model', LogisticRegression(max_iter=1000))# шаг 2: модель
])

pipe.fit(X_train, y_train)                       # обучаем ВСЮ цепочку
print(f"Точность: {pipe.score(X_test, y_test):.3f}")
```

#### Что произошло

- При `pipe.fit`: scaler обучился на train и отмасштабировал его → модель обучилась на масштабированных данных.
- При `pipe.score(X_test, ...)`: X_test **сам** прошёл scaler (через `transform`) → модель предсказала.

> **Мы подали сырые `X_test`** — а Pipeline сам всё отмасштабировал правильно. Не нужно вручную вызывать `scaler.transform(X_test)` и не перепутаешь `fit`/`transform`. Это и есть удобство.

### 1.3. Pipeline работает в кросс-валидации

```python
scores = cross_val_score(pipe, X, y, cv=5)
print(f"CV-точность: {scores.mean():.3f} ± {scores.std():.3f}")
```

**Что важно:** мы передали **весь Pipeline** в `cross_val_score`. Внутри каждого фолда scaler обучается **только на train-части** — **без утечки** (вспомни теорию). Если бы мы стандартизовали X заранее, была бы утечка.

### Итог Задания 1

**Что мы поняли:**
1. Pipeline связывает scaler и модель в одну цепочку.
2. Работает как обычная модель (`fit`, `predict`, `score`, `cross_val_score`).
3. Подаём сырые данные — обработка происходит сама.

---

## Задание 2. ColumnTransformer (14 минут)

### Что мы хотим сделать

Обрабатывать **числовые и категориальные** столбцы **по-разному**: числа масштабировать, категории кодировать — автоматически, через `ColumnTransformer`.

### 2.1. Берём «сырые» данные с категориями

```python
df = pd.read_csv(url)    # перезагружаем — теперь не будем кодировать вручную!

X = df[['Pclass', 'Sex', 'Age', 'Fare', 'Embarked']]   # Sex и Embarked — СТРОКИ
y = df['Survived']

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y)

print(X.dtypes)
# Pclass: int, Sex: object(строка!), Age: float, Fare: float, Embarked: object(строка!)
```

**Что важно:** `Sex` и `Embarked` — **строки**, `Age` имеет **пропуски**. Раньше мы чистили это вручную. Теперь — внутри Pipeline.

### 2.2. Описываем обработку для каждого типа столбцов

```python
# Числовые: заполнить пропуски медианой + масштабировать
numeric_features = ['Pclass', 'Age', 'Fare']
numeric_transformer = Pipeline([
    ('imputer', SimpleImputer(strategy='median')),    # пропуски → медиана
    ('scaler', StandardScaler())                       # масштабирование
])

# Категориальные: заполнить пропуски + one-hot
categorical_features = ['Sex', 'Embarked']
categorical_transformer = Pipeline([
    ('imputer', SimpleImputer(strategy='most_frequent')),       # пропуски → частое значение
    ('onehot', OneHotEncoder(handle_unknown='ignore'))          # one-hot
])
```

#### Что мы делаем по шагам

- **Числовые** проходят **свой** мини-Pipeline: заполнить пропуски медианой → масштабировать.
- **Категориальные** — свой: заполнить частым значением → one-hot.
- `SimpleImputer(strategy='median')` — заполняет пропуски медианой **внутри** конвейера (без ручного `fillna` → без утечки!).
- `handle_unknown='ignore'` — если в test встретится категория, которой не было в train, не упасть с ошибкой.

### 2.3. Собираем ColumnTransformer

```python
preprocessor = ColumnTransformer([
    ('num', numeric_transformer, numeric_features),         # к числовым — числовой transformer
    ('cat', categorical_transformer, categorical_features)  # к категориям — категориальный
])
```

**Что произошло:** `ColumnTransformer` знает, какие столбцы числовые, какие категориальные, и применит к каждым **свою** обработку, потом склеит.

### 2.4. Полный Pipeline: препроцессинг + модель

```python
full_pipe = Pipeline([
    ('preprocessor', preprocessor),                          # вся подготовка
    ('model', RandomForestClassifier(n_estimators=100, random_state=42))
])

full_pipe.fit(X_train, y_train)                              # ОДНА команда на всё!
print(f"Точность: {full_pipe.score(X_test, y_test):.3f}")
```

#### Что произошло — и почему это круто

Одной командой `.fit()`:
1. Числовые: пропуски → медиана, масштабирование.
2. Категориальные: пропуски → частое, one-hot.
3. Всё склеилось, модель обучилась.

> **Мы подали абсолютно сырые данные** (со строками и пропусками!) — и Pipeline всё обработал сам. Никакого ручного `fillna`, `map`, `get_dummies`. Это профессиональный, чистый код.

### Итог Задания 2

**Что мы поняли:**
1. `ColumnTransformer` применяет **разную** обработку к разным столбцам.
2. Числа → impute + scale, категории → impute + one-hot.
3. Весь препроцессинг + модель = **один** Pipeline, одна команда `.fit`.

---

## Задание 3. Полный Pipeline + GridSearch (16 минут)

### Что мы хотим сделать

Подобрать гиперпараметры модели **внутри** полного Pipeline — GridSearch настроит всю цепочку.

### 3.1. GridSearch по Pipeline

```python
param_grid = {
    'model__n_estimators': [50, 100, 200],
    'model__max_depth': [3, 5, 10, None]
}

grid = GridSearchCV(full_pipe, param_grid, cv=5)
grid.fit(X_train, y_train)

print("Лучшие параметры:", grid.best_params_)
print(f"CV-точность: {grid.best_score_:.3f}")
print(f"Тест: {grid.score(X_test, y_test):.3f}")
```

#### Что мы делаем по шагам

- **`'model__n_estimators'`** — двойное подчёркивание: параметр `n_estimators` шага `model` (вспомни Урок 4.4).
- GridSearch перебирает параметры модели, **прогоняя весь Pipeline** в кросс-валидации.
- В **каждом** фолде препроцессинг (impute, scale, one-hot) обучается **только на train-части** → честно, без утечки.

> **Вот сила связки:** GridSearch + Pipeline = подбор параметров с **гарантированно** правильным препроцессингом внутри каждого фолда. Это «золотой стандарт» правильного ML-кода.

### 3.2. Можно подбирать и параметры препроцессинга!

```python
param_grid = {
    'preprocessor__num__imputer__strategy': ['median', 'mean'],   # как заполнять пропуски
    'model__n_estimators': [100, 200]
}

grid = GridSearchCV(full_pipe, param_grid, cv=5)
grid.fit(X_train, y_train)
print("Лучшие:", grid.best_params_)
```

**Что произошло:** мы подбираем даже **стратегию заполнения пропусков** (`median` vs `mean`)! Путь `preprocessor__num__imputer__strategy` читается так: шаг `preprocessor` → его часть `num` → её шаг `imputer` → параметр `strategy`. GridSearch может настроить **любой** винтик конвейера.

### Итог Задания 3

**Что мы поняли:**
1. GridSearch работает с полным Pipeline — настраивает всю цепочку.
2. Препроцессинг честно обучается внутри каждого фолда (без утечки).
3. Можно подбирать даже параметры препроцессинга (как заполнять пропуски).

---

## Задание 4. Сохраняем модель (6 минут)

### Что мы хотим сделать

Сохранить готовый Pipeline в файл и загрузить обратно — как при реальном «деплое».

### 4.1. Сохранение и загрузка

```python
# Берём лучшую модель из GridSearch
best_model = grid.best_estimator_

# Сохраняем ВСЮ цепочку в файл
joblib.dump(best_model, 'titanic_model.joblib')
print("Модель сохранена!")

# ... представь, что это другая программа ...
loaded_model = joblib.load('titanic_model.joblib')

# Сразу предсказываем на СЫРЫХ данных — препроцессинг внутри!
sample = X_test.iloc[:3]
print("Предсказания загруженной модели:", loaded_model.predict(sample))
```

#### Что произошло

- `joblib.dump(best_model, ...)` — сохранил **весь Pipeline** (препроцессинг + модель) в один файл.
- `joblib.load(...)` — загрузил его в другом месте.
- Загруженная модель сразу принимает **сырые** данные — потому что препроцессинг сохранён **внутри** Pipeline.

> **Это и есть «деплой» в простейшем виде:** обучил → сохранил файл → в приложении загрузил → предсказываешь. Если бы ты сохранил только модель (без Pipeline), пришлось бы вручную повторять весь препроцессинг — и легко ошибиться.

### Итог Задания 4

**Что мы поняли:**
1. `joblib.dump/load` сохраняет и загружает весь Pipeline.
2. Загруженная модель работает с **сырыми** данными — препроцессинг внутри.
3. Это основа «деплоя» модели в реальное приложение.

---

## Тайминг (90 минут)

| Время | Блок |
|------:|------|
| 0–10 | Повторение (`review.md`) |
| 10–22 | Зачем Pipeline (теория) |
| 22–34 | Pipeline-конвейер (теория) |
| 34–48 | ColumnTransformer (теория) |
| 48–58 | Задание 1 (первый Pipeline) |
| 58–72 | Задание 2 (ColumnTransformer) |
| 72–84 | Задание 3 (Pipeline + GridSearch) |
| 84–88 | Задание 4 (сохранение) + самостоятельная |
| 88–90 | Итоги (`summary.md`) |
