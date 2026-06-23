# Урок 4.7. Практика (вместе с преподавателем)

> ### 💻 Как работать с кодом урока
> Весь код пишем в **одном ноутбуке** (`.ipynb`, в Google Colab или Jupyter), разбивая на **ячейки**: один логический шаг — одна ячейка, запускаем сверху вниз. Переменные сохраняются между ячейками, поэтому импорты, данные, модель и обучение держим в **разных** ячейках. Домашку продолжаем в **том же** ноутбуке (раздел `## Самостоятельная работа`), а ответы на 🤔-вопросы пишем в **Markdown-ячейках**. Отдельные `.py`-файлы не нужны — они пригодятся только для большого проекта (Модуль 9). Перед сдачей запусти ноутбук целиком («Перезапустить и выполнить всё»), чтобы проверить, что всё работает по порядку.


> Тетрадка: `lesson-4-7-kaggle.ipynb`.

---

## Что мы будем делать на уроке

**Сегодня — собираем настоящее соревновательное решение Titanic от начала до конца:**

1. **Задание 1:** загрузим **реальные** train/test соревнования и изучим их (заметим: у test **нет** `Survived`!).

2. **Задание 2:** соберём **полное решение** — признаки (4.5) + Pipeline (4.6) + модель, оценим по кросс-валидации.

3. **Задание 3:** предскажем судьбу 418 тестовых пассажиров и сформируем **`submission.csv`**.

4. **Задание 4:** отправим на Kaggle (или симулируем) и попробуем **улучшить** результат.

> **Это итог Модуля 4.** Здесь сходится всё, что мы учили. Получится — значит, ты умеешь делать ML.

---

## Данные соревнования

```python
# Реальные файлы соревнования Kaggle Titanic (зеркало на GitHub).
# Если у тебя есть аккаунт Kaggle — лучше скачай train.csv/test.csv оттуда (они идентичны).
TRAIN_URL = "https://raw.githubusercontent.com/agconti/kaggle-titanic/master/data/train.csv"
TEST_URL  = "https://raw.githubusercontent.com/agconti/kaggle-titanic/master/data/test.csv"
```

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
from sklearn.model_selection import cross_val_score, GridSearchCV
```

> Знакомый арсенал из Модуля 4. Никаких новых библиотек — только применение.

---

## Задание 1. Знакомимся с данными соревнования (10 минут)

### Что мы хотим сделать

Загрузить **train** и **test** соревнования и **увидеть** ключевое отличие: у test нет ответов.

### 1.1. Загрузка

```python
train = pd.read_csv(TRAIN_URL)
test = pd.read_csv(TEST_URL)

print("Train:", train.shape)     # (891, 12) — есть Survived
print("Test: ", test.shape)      # (418, 11) — на 1 колонку МЕНЬШE!
```

### 1.2. Находим главное отличие

```python
print("Колонки train:", set(train.columns))
print("Колонки test: ", set(test.columns))
print("\nЧего нет в test:", set(train.columns) - set(test.columns))
# {'Survived'}  ← вот оно!
```

#### Что это значит

В `test` **нет колонки `Survived`** — её-то нам и предстоит **предсказать** для 418 пассажиров. Мы не можем посчитать accuracy на test локально: **не с чем сравнивать**. (Помнишь главную идею из теории?)

```python
test.head(3)
# PassengerId, Pclass, Name, Sex, ... — но НЕТ Survived
```

### 1.3. Сохраним то, что понадобится для submission

```python
test_ids = test['PassengerId']      # понадобятся для файла submission
y = train['Survived']                # наши ответы для обучения
print("Тестовых пассажиров для предсказания:", len(test_ids))   # 418
```

### Итог Задания 1

**Что мы поняли:**
1. `train` — с ответами (891), `test` — без ответов (418).
2. Наша задача — предсказать `Survived` для test.
3. Локально проверить себя на test **нельзя** — только через Kaggle (или через CV на train).

---

## Задание 2. Собираем полное решение (16 минут)

### Что мы хотим сделать

Применить всё из Модуля 4: создать признаки, собрать Pipeline, оценить кросс-валидацией.

### 2.1. Создаём признаки (feature engineering из 4.5)

```python
def add_features(df):
    df = df.copy()
    # Размер семьи и флаг "один"
    df['FamilySize'] = df['SibSp'] + df['Parch'] + 1
    df['IsAlone'] = (df['FamilySize'] == 1).astype(int)
    # Титул из имени
    df['Title'] = df['Name'].str.extract(r' ([A-Za-z]+)\.')
    df['Title'] = df['Title'].replace(
        ['Dr','Rev','Col','Major','Capt','Sir','Lady','Don','Countess','Jonkheer','Dona'], 'Rare')
    df['Title'] = df['Title'].replace(['Mlle','Ms'], 'Miss').replace('Mme', 'Mrs')
    return df

train_fe = add_features(train)
test_fe = add_features(test)        # ТЕ ЖЕ признаки для test — обязательно!
```

> **Важно:** одни и те же признаки создаём **и для train, и для test**. Если признак есть в train, но не в test — модель не сможет предсказать. Признаки должны быть **симметричны**.

### 2.2. Описываем признаки и собираем Pipeline (из 4.6)

```python
features_num = ['Age', 'Fare', 'FamilySize', 'SibSp', 'Parch']
features_cat = ['Pclass', 'Sex', 'Embarked', 'Title', 'IsAlone']

num_tf = Pipeline([('imp', SimpleImputer(strategy='median')),
                   ('sc', StandardScaler())])
cat_tf = Pipeline([('imp', SimpleImputer(strategy='most_frequent')),
                   ('oh', OneHotEncoder(handle_unknown='ignore'))])

preprocessor = ColumnTransformer([
    ('num', num_tf, features_num),
    ('cat', cat_tf, features_cat)
])

model = Pipeline([
    ('pre', preprocessor),
    ('clf', RandomForestClassifier(n_estimators=200, random_state=42))
])
```

**Что произошло:** собрали полный конвейер — пропуски, масштабирование, one-hot, модель. Всё из Урока 4.6. `handle_unknown='ignore'` спасёт, если в test встретится новая категория.

### 2.3. Готовим X и оцениваем СЕБЯ кросс-валидацией

```python
X = train_fe[features_num + features_cat]
X_test = test_fe[features_num + features_cat]

cv_score = cross_val_score(model, X, y, cv=5).mean()
print(f"Наша ожидаемая точность (CV): {cv_score:.4f}")   # ~0.82
```

#### Что это значит — наш «личный лидерборд»

Раз на test нет ответов, **кросс-валидация — наш честный счёт ДО отправки**. CV говорит ~0.82 — значит, на Kaggle ждём примерно столько же. Это наш **компас** (из теории): доверяем CV, а не гадаем.

### Итог Задания 2

**Что мы сделали:**
1. Создали признаки (Title, FamilySize, IsAlone) — для train **и** test.
2. Собрали полный Pipeline.
3. Оценили себя по CV (~0.82) — это наш ожидаемый score.

---

## Задание 3. Делаем submission.csv (14 минут)

### Что мы хотим сделать

Обучить модель на **всём** train, предсказать `Survived` для test, сохранить в формате Kaggle.

### 3.1. Обучаем на всём train и предсказываем test

```python
# Обучаем на ВСЕХ обучающих данных (теперь не делим — используем всё для силы)
model.fit(X, y)

# Предсказываем для 418 тестовых пассажиров
test_predictions = model.predict(X_test)
print("Предсказаний сделано:", len(test_predictions))   # 418
print("Первые 10:", test_predictions[:10])
```

#### Что произошло

- Обучили Pipeline на **всех** 891 пассажирах train (чем больше данных — тем лучше модель).
- Предсказали `Survived` (0/1) для каждого из 418 тестовых.
- Эти предсказания мы **не можем проверить** локально — отправим на Kaggle.

### 3.2. Формируем submission.csv в нужном формате

```python
submission = pd.DataFrame({
    'PassengerId': test_ids,
    'Survived': test_predictions
})

print(submission.head())
#    PassengerId  Survived
# 0          892         0
# 1          893         1
# ...

submission.to_csv('submission.csv', index=False)    # index=False — ОБЯЗАТЕЛЬНО!
print("Файл submission.csv готов!")
```

#### Что важно

- Формат **строго** такой: 2 колонки — `PassengerId` и `Survived`. Kaggle ждёт именно их.
- **`index=False`** — без этого pandas добавит лишнюю колонку с номерами строк, и Kaggle отвергнет файл.
- Должно быть ровно **418 строк** (+ заголовок).

```python
# Проверка формата
print("Строк:", len(submission))                    # 418
print("Колонки:", submission.columns.tolist())       # ['PassengerId', 'Survived']
```

### Итог Задания 3

**Что мы сделали:**
1. Обучили модель на всём train.
2. Предсказали судьбу 418 тестовых пассажиров.
3. Сохранили **`submission.csv`** в формате Kaggle — готов к отправке!

---

## Задание 4. Отправка и улучшение (8 минут)

### 4.1. Отправка на Kaggle

> Если у тебя есть аккаунт Kaggle:
> 1. Открой соревнование **«Titanic - Machine Learning from Disaster»**.
> 2. **Submit Predictions** → загрузи `submission.csv`.
> 3. Через пару секунд увидишь свой **score** и **место**!

В Colab скачать файл можно так:
```python
from google.colab import files
files.download('submission.csv')        # скачается на компьютер
```

### 4.2. Если Kaggle недоступен — «симуляция»

Чтобы прикинуть результат без отправки, доверься своей **CV** (~0.82) — на Titanic public score обычно близок к CV (±0.02).

### 4.3. Как улучшить score — идеи

```python
# Идея 1: подобрать модель через GridSearch (Урок 4.4)
param_grid = {'clf__n_estimators': [100, 200, 300],
              'clf__max_depth': [5, 7, 10, None]}
grid = GridSearchCV(model, param_grid, cv=5)
grid.fit(X, y)
print("Лучшая CV:", grid.best_score_)
# Переделать submission с grid.best_estimator_
```

**Другие идеи для улучшения (по убыванию пользы):**
- **Больше признаков** (4.5): `FarePerPerson`, бины возраста, есть ли каюта (`HasCabin`), размер группы по билету.
- **Другая модель**: градиентный бустинг (часто чуть лучше леса).
- **Подбор гиперпараметров** (GridSearch).

> **Помни главное правило:** проверяй улучшения по **кросс-валидации**, а не угадывай. Вырос CV → вырастет и score. И не гонись за public лидербордом — верь своей CV.

### Итог Задания 4

**Что мы поняли:**
1. `submission.csv` отправляется на Kaggle → score и место.
2. Улучшать — через признаки и подбор, проверяя по CV.
3. CV — наш честный ориентир улучшений.

---

## Тайминг (90 минут)

| Время | Блок |
|------:|------|
| 0–10 | Повторение (`review.md`) |
| 10–34 | Как устроены соревнования (теория) |
| 34–44 | Лидерборд и CV (теория) |
| 44–54 | Задание 1 (данные) |
| 54–70 | Задание 2 (решение) |
| 70–84 | Задание 3 (submission.csv) |
| 84–88 | Задание 4 (отправка) + самостоятельная |
| 88–90 | Итоги (`summary.md`) |
