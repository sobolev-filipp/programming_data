# Урок 4.6. Pipeline — резюме

---

## Глоссарий новых терминов

| Термин | Что это |
|--------|---------|
| **Pipeline** | Цепочка шагов «препроцессинг → модель» в одном объекте |
| **Шаг (step)** | Один этап конвейера (scaler, encoder, модель) |
| **ColumnTransformer** | Разная обработка для разных столбцов |
| **SimpleImputer** | Заполнение пропусков внутри Pipeline |
| **OneHotEncoder** | One-hot кодирование (как шаг Pipeline) |
| **Утечка (leakage)** | Информация из теста попала в обучение |
| **joblib** | Сохранение/загрузка готовой модели |

---

## Главные мысли

1. **Pipeline = сборочный конвейер:** сырые данные → шаги обработки → предсказание.
2. Pipeline ведёт себя **как модель**: `fit`, `predict`, работает в `cross_val_score`/`GridSearch`.
3. **ColumnTransformer** применяет разную обработку: числа → scale, категории → one-hot.
4. Pipeline **защищает от утечек** — препроцессинг учится только на train внутри каждого фолда.
5. Весь Pipeline можно **сохранить** (`joblib`) и использовать на сырых данных позже.
6. Pipeline не повышает точность — он делает код **чистым, надёжным, готовым к продакшену**.

---

## Шаблон полного конвейера

```python
from sklearn.pipeline import Pipeline
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.impute import SimpleImputer

# Обработка числовых
num_tf = Pipeline([
    ('imputer', SimpleImputer(strategy='median')),
    ('scaler', StandardScaler())
])
# Обработка категориальных
cat_tf = Pipeline([
    ('imputer', SimpleImputer(strategy='most_frequent')),
    ('onehot', OneHotEncoder(handle_unknown='ignore'))
])
# Кому что
preprocessor = ColumnTransformer([
    ('num', num_tf, numeric_cols),
    ('cat', cat_tf, categorical_cols)
])
# Полный конвейер
pipe = Pipeline([
    ('preprocessor', preprocessor),
    ('model', RandomForestClassifier())
])
pipe.fit(X_train, y_train)        # одна команда на всё!
```

---

## Пути параметров (для GridSearch)

```python
{
    'model__n_estimators': [100, 200],            # параметр модели
    'preprocessor__num__imputer__strategy': ['mean', 'median']  # параметр препроцессинга
}
```
Читать как адрес: `шаг__подшаг__параметр` (двойное подчёркивание).

---

## Сохранение модели

```python
import joblib
joblib.dump(pipe, 'model.joblib')      # сохранить
loaded = joblib.load('model.joblib')   # загрузить
loaded.predict(X_new)                   # работает с СЫРЫМИ данными
```

---

## Главные ошибки

| Ошибка | Что не так | Как исправить |
|--------|-----------|---------------|
| Препроцессинг вне Pipeline | Утечка в CV | Всё в Pipeline |
| Одинарное `_` в пути | Синтаксис | Двойное `__` |
| Ручное кодирование до Pipeline | Теряется повторяемость | Импьют/кодирование в Pipeline |
| Нет `handle_unknown='ignore'` | Падает на новой категории | Добавить параметр |
| Сохранили только модель | Надо повторять препроцессинг | Сохранять весь Pipeline |

---

## Что должно остаться в голове после урока

1. Я понимаю Pipeline как **конвейер** препроцессинг + модель.
2. Я умею собрать Pipeline и ColumnTransformer.
3. Я знаю, что Pipeline **защищает от утечек** в CV.
4. Я читаю пути `шаг__параметр` для GridSearch.
5. Я могу **сохранить** модель через joblib.

---

## К следующему уроку

**Урок 4.7. Учебное соревнование на Kaggle.** Будем:
- Участвовать в **настоящем** соревновании Kaggle (Titanic — классика для новичков).
- Применять **всё** из Модуля 4: признаки, Pipeline, GridSearch, разные модели.
- Отправлять решение и видеть свою позицию в **лидерборде**.

> Пришло время проверить себя на **реальной** площадке, где соревнуются дата-сайентисты со всего мира. Весь наш конвейер — признаки + Pipeline + подбор — теперь сработает на полную. Это самый азартный урок модуля!
