# Урок 3.1. Что такое ML — резюме

> **Сегодня мы впервые обучили модель.** Этот файл — на память.

---

## Глоссарий новых терминов

| Термин | Что это |
|--------|---------|
| **ML (машинное обучение)** | Программа учится на примерах, не по жёстким правилам |
| **Модель** | Алгоритм + параметры, выученные на данных |
| **Признаки (X)** | Характеристики объектов (таблица, строки = объекты) |
| **Целевая переменная (y)** | То, что предсказываем (один столбец) |
| **Supervised learning** | Есть размеченные данные (X и y) |
| **Регрессия** | y — число (цена, температура) |
| **Классификация** | y — категория (вид, класс) |
| **Unsupervised learning** | Только X — ищем структуру (кластеризация, PCA) |
| **Reinforcement learning** | Агент учится через награды и штрафы |
| **Train / Test** | Учебная и проверочная выборки |
| **`fit`** | Обучить модель |
| **`predict`** | Сделать предсказание |
| **Accuracy** | Доля правильных ответов (для классификации) |
| **random_state** | «Зерно» случайности для воспроизводимости |
| **scikit-learn** | Главная Python-библиотека ML |

---

## Главные мысли

1. **ML = обучение по примерам.** Никаких «if-else» — модель сама находит правила.
2. **3 типа задач:** classification (категория), regression (число), unsupervised (структура).
3. **Workflow:** данные → split → модель → fit → predict → метрика. Запомнить намертво.
4. **Главное правило:** **никогда не оценивай модель на тех же данных, на которых обучал.**
5. **scikit-learn:** одинаковый API для **любой** модели — `fit(X, y)` и `predict(X)`.

---

## Шаблон ML-кода

```python
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score

# 1. Данные
X, y = load_iris(return_X_y=True)

# 2. Разделение
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# 3. Модель
model = LogisticRegression(max_iter=200)

# 4. Обучение
model.fit(X_train, y_train)

# 5. Предсказание
y_pred = model.predict(X_test)

# 6. Оценка
print(accuracy_score(y_test, y_pred))
```

**Запомни этот шаблон.** Дальше будут вариации, но **скелет** одинаковый.

---

## Импорты по случаям

```python
# Данные из библиотеки
from sklearn.datasets import load_iris, load_wine, fetch_california_housing

# Разделение
from sklearn.model_selection import train_test_split

# Модели классификации
from sklearn.linear_model import LogisticRegression
from sklearn.neighbors import KNeighborsClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier

# Модели регрессии
from sklearn.linear_model import LinearRegression
from sklearn.tree import DecisionTreeRegressor

# Метрики классификации
from sklearn.metrics import accuracy_score, classification_report

# Метрики регрессии
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score
```

---

## Главные ошибки

| Ошибка | Что не так | Как исправить |
|--------|-----------|---------------|
| Обучить и оценить на одних данных | Не покажет, как работает на новых | Используй `train_test_split` |
| Забыли `random_state` | У всех разные результаты | Везде ставь `random_state=42` |
| `model.fit(X, y)` — забыли разделить | Зубришь | Сначала split |
| `accuracy_score(X_test, y_pred)` | Перепутал аргументы | `accuracy_score(y_test, y_pred)` |
| `model.predict(X_train)` для оценки | Это train, не test! | `model.predict(X_test)` |

---

## Что должно остаться в голове после урока

1. Я могу написать ML-код **из 6 строк** для классификации Iris.
2. Я знаю **разницу** между регрессией и классификацией.
3. Я понимаю, **зачем** нужно разделение на train/test.
4. Я знаю, что **`fit`** обучает, **`predict`** предсказывает.
5. Я знаю, что **accuracy** — простейшая метрика классификации.

---

## К следующему уроку

Следующий урок — **Урок 3.2. Признаки и целевая переменная. Train/Test split подробно.**

- Как **выбирать** признаки.
- Что такое **категориальные** признаки и как их обрабатывать (one-hot encoding).
- **Стратифицированное** разделение.
- Кросс-валидация — кратко.

Будет много практики на Titanic.

---

## Тебе следует гордиться

**Сегодня ты обучил настоящую ML-модель.** Это не симулятор, не игра — это **тот же код**, который используют в Яндексе, Сбере, Google, OpenAI. Просто на маленьком датасете.

Через 6 уроков Модуля 3 ты будешь обучать **серьёзные** модели и **сравнивать** их. А через 6 модулей — **строить нейросети**.

Поехали дальше.
