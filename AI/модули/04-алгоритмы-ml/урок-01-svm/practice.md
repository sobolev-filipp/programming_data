# Урок 4.1. Практика (вместе с преподавателем)

> ### 💻 Как работать с кодом урока
> Весь код пишем в **одном ноутбуке** (`.ipynb`, в Google Colab или Jupyter), разбивая на **ячейки**: один логический шаг — одна ячейка, запускаем сверху вниз. Переменные сохраняются между ячейками, поэтому импорты, данные, модель и обучение держим в **разных** ячейках. Домашку продолжаем в **том же** ноутбуке (раздел `## Самостоятельная работа`), а ответы на 🤔-вопросы пишем в **Markdown-ячейках**. Отдельные `.py`-файлы не нужны — они пригодятся только для большого проекта (Модуль 9). Перед сдачей запусти ноутбук целиком («Перезапустить и выполнить всё»), чтобы проверить, что всё работает по порядку.


> Тетрадка: `lesson-4-1-svm.ipynb`.

---

## Что мы будем делать на уроке

**Сегодня — три задачи:**

1. **Задание 1:** обучим **SVM** различать виды ирисов и **увидим границу решений** — ту самую «улицу» между классами.

2. **Задание 2:** сравним **линейное и RBF ядро** и поиграем с **C и gamma** — увидим, как меняется граница (от простой к извилистой).

3. **Задание 3:** **честно сравним SVM** со всеми моделями Модуля 3 по кросс-валидации.

> **Почему Iris?** Маленький, наглядный, легко рисовать границы на 2 признаках. А ещё мы уже знаем его по KNN (3.5) и дереву (3.6) — удобно сравнивать.

---

## Импорты

```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
sns.set_theme()

from sklearn.svm import SVC
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import accuracy_score
```

**Что мы импортируем и зачем:**

- `SVC` — **наша новая модель** (Support Vector Classifier).
- `train_test_split, cross_val_score` — деление данных и честная оценка (из Модуля 3).
- `StandardScaler` — стандартизация (для SVM **обязательна**!).
- `accuracy_score` — метрика.

---

## Задание 1. Первый SVM на Iris (16 минут)

### Что мы хотим сделать

Обучить SVM различать виды ирисов и **нарисовать границу** между классами на двух признаках.

**Что мы сделаем:**
1. Загрузим Iris, возьмём 2 признака (чтобы рисовать на плоскости).
2. Стандартизуем (SVM этого требует).
3. Обучим `SVC`.
4. Нарисуем границу решений.

### 1.1. Загрузка и подготовка

```python
url = "https://raw.githubusercontent.com/mwaskom/seaborn-data/master/iris.csv"
df = pd.read_csv(url)

# Берём 2 признака — чтобы граница рисовалась на плоскости
X = df[['petal_length', 'petal_width']].values
y = df['species'].values

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y)
```

**Почему 2 признака:** граница решений в 2D — это линия/кривая, её легко нарисовать. На 4 признаках границу не показать на плоскости. Берём `petal_length` и `petal_width` — по ним виды разделяются лучше всего (помним из 3.5–3.6).

### 1.2. Стандартизация (обязательно для SVM!)

```python
scaler = StandardScaler()
X_train_s = scaler.fit_transform(X_train)   # учим scaler + применяем к train
X_test_s = scaler.transform(X_test)          # к test — только transform!
```

**Что произошло:** привели оба признака к среднему 0 и std 1. **Без этого SVM работал бы плохо** — он считает расстояния, и признак с большей шкалой «забивал» бы другой. Это правило из Урока 3.5 (для KNN), и для SVM оно тоже действует.

### 1.3. Обучаем SVM

```python
model = SVC(kernel='rbf', C=1.0, gamma='scale')
model.fit(X_train_s, y_train)

acc = model.score(X_test_s, y_test)
print(f"Accuracy: {acc:.3f}")        # ~0.967

print("Число опорных векторов:", model.n_support_)   # например [3 8 7]
```

#### Что произошло

- **`SVC(kernel='rbf', ...)`** — создали SVM с RBF-ядром (гибкие границы).
- **`n_support_`** — сколько **опорных векторов** в каждом классе. Видишь: их **немного** (по 3–8 на класс из ~40). Только эти точки определяют границу — остальные ~100 не влияют! Это и есть «компактность» из теории.

### 1.4. ⭐ Рисуем границу решений

```python
from matplotlib.colors import ListedColormap

# Превращаем виды в числа для раскраски
from sklearn.preprocessing import LabelEncoder
y_num = LabelEncoder().fit_transform(y_train)

# Сетка точек по всей плоскости
x_min, x_max = X_train_s[:, 0].min() - 1, X_train_s[:, 0].max() + 1
y_min, y_max = X_train_s[:, 1].min() - 1, X_train_s[:, 1].max() + 1
xx, yy = np.meshgrid(np.linspace(x_min, x_max, 300),
                     np.linspace(y_min, y_max, 300))

# Предсказываем класс для каждой точки сетки
Z = model.predict(np.c_[xx.ravel(), yy.ravel()])
Z = LabelEncoder().fit(y_train).transform(Z).reshape(xx.shape)

plt.figure(figsize=(9, 6))
plt.contourf(xx, yy, Z, alpha=0.3, cmap='viridis')        # закрашенные зоны классов
plt.scatter(X_train_s[:, 0], X_train_s[:, 1], c=y_num, cmap='viridis', edgecolor='k')
plt.xlabel("petal_length (станд.)")
plt.ylabel("petal_width (станд.)")
plt.title("Граница решений SVM (RBF)")
plt.show()
```

#### Что мы делаем по шагам

- Создаём **густую сетку** точек по всей плоскости (`meshgrid`).
- Просим SVM **предсказать класс** для каждой точки сетки.
- `contourf` **закрашивает** зоны разными цветами — это и есть «территории» классов.
- Поверх рисуем настоящие точки.

**Что увидим:** плоскость разбита на **3 цветные зоны** (по видам), границы между ними — **плавные кривые** (заслуга RBF-ядра). Точки лежат каждая в своей зоне.

### Итог Задания 1

**Что мы сделали:**
1. Обучили SVM на ирисах (acc ≈ 0.97).
2. Увидели, что **опорных векторов мало** — граница держится на нескольких точках.
3. Нарисовали **границу решений** — кривые зоны классов.

---

## Задание 2. Ядра и гиперпараметры (12 минут)

### Что мы хотим показать

Как **ядро** и параметры **C, gamma** меняют границу — от прямой до сильно извилистой.

### 2.1. Линейное ядро vs RBF

```python
for kernel in ['linear', 'rbf']:
    model = SVC(kernel=kernel, C=1.0, gamma='scale')
    model.fit(X_train_s, y_train)
    acc = model.score(X_test_s, y_test)
    print(f"kernel={kernel:7}: accuracy = {acc:.3f}")
```

**Что увидим (примерно):**
```
kernel=linear : accuracy = 0.933
kernel=rbf    : accuracy = 0.967
```

**Что это значит:** `linear` проводит **прямые** границы — чуть хуже, потому что виды ирисов разделяются не идеально прямыми. `rbf` рисует **кривые** — гибче и точнее. Для большинства задач **RBF — хороший выбор по умолчанию**.

### 2.2. Влияние C (строгость)

```python
for C in [0.01, 0.1, 1, 100]:
    model = SVC(kernel='rbf', C=C, gamma='scale').fit(X_train_s, y_train)
    tr = model.score(X_train_s, y_train)
    te = model.score(X_test_s, y_test)
    print(f"C={C:6}: train={tr:.3f}, test={te:.3f}")
```

**Что увидим (примерно):**
```
C=  0.01: train=0.692, test=0.700   ← слишком мягко (недообучение)
C=   0.1: train=0.942, test=0.933
C=     1: train=0.958, test=0.967   ← хорошо
C=   100: train=0.983, test=0.933   ← слишком строго (переобучение)
```

#### Что это значит

- **Маленький C (0.01)** — граница слишком «мягкая», терпит много нарушителей → **недообучение** (низко и на train, и на test).
- **Большой C (100)** — граница «впритык» под train → train растёт, но test проседает → **переобучение**.
- **C ≈ 1** — баланс.

> Это **знакомая дилемма**: как `max_depth` у дерева и `k` у KNN. У C тоже есть «золотая середина», и её подбирают.

### 2.3. Влияние gamma (извилистость RBF)

```python
for gamma in [0.01, 0.1, 1, 10]:
    model = SVC(kernel='rbf', C=1, gamma=gamma).fit(X_train_s, y_train)
    tr = model.score(X_train_s, y_train)
    te = model.score(X_test_s, y_test)
    print(f"gamma={gamma:5}: train={tr:.3f}, test={te:.3f}")
```

**Что увидим (примерно):**
```
gamma= 0.01: train=0.917, test=0.933   ← гладкая граница
gamma=  0.1: train=0.950, test=0.967
gamma=    1: train=0.967, test=0.967   ← хорошо
gamma=   10: train=1.000, test=0.900   ← граница "облизала" каждую точку (переобучение)
```

#### Что это значит

- **Маленькая gamma** — гладкая, простая граница.
- **Большая gamma (10)** — граница «обнимает» каждую точку: train=1.0 (идеально зазубрил!), но test падает → **переобучение**.

> **Вывод:** C и gamma вместе управляют сложностью SVM. Большие значения → сложнее граница → риск переобучения. Подбирать их вручную утомительно — в **Уроке 4.4** научимся делать это автоматически (`GridSearch`).

### Итог Задания 2

**Что мы поняли:**
1. **RBF** даёт кривые границы и обычно точнее `linear`.
2. **C** — строгость: большой → переобучение, маленький → недообучение.
3. **gamma** — извилистость: большая → граница зубрит точки.

---

## Задание 3. SVM против Модуля 3 (8 минут)

### Что мы хотим сделать

Честно сравнить SVM с моделями Модуля 3 по кросс-валидации — на полном Iris (4 признака).

### 3.1. Турнир моделей

```python
from sklearn.linear_model import LogisticRegression
from sklearn.neighbors import KNeighborsClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.pipeline import make_pipeline

# Полный Iris (4 признака)
X_full = df[['sepal_length','sepal_width','petal_length','petal_width']].values
y_full = df['species'].values

models = {
    'LogReg': make_pipeline(StandardScaler(), LogisticRegression(max_iter=1000)),
    'KNN-5':  make_pipeline(StandardScaler(), KNeighborsClassifier(n_neighbors=5)),
    'Лес':    RandomForestClassifier(n_estimators=100, random_state=42),
    'SVM':    make_pipeline(StandardScaler(), SVC(kernel='rbf')),
}

for name, model in models.items():
    scores = cross_val_score(model, X_full, y_full, cv=5)
    print(f"{name:8}: {scores.mean():.3f} ± {scores.std():.3f}")
```

> **Обрати внимание на `make_pipeline`:** для SVM, KNN и логрег мы кладём `StandardScaler` **в пайплайн** — тогда стандартизация происходит честно внутри каждого фолда (вспомни Урок 3.7). Лесу scaler не нужен.

**Что увидим (примерно):**
```
LogReg  : 0.967 ± 0.021
KNN-5   : 0.967 ± 0.021
Лес     : 0.960 ± 0.025
SVM     : 0.967 ± 0.021
```

#### Что это значит

На Iris все модели дают ~0.96–0.97 — датасет «лёгкий», разница в пределах шума (снова **No Free Lunch** из Модуля 3). SVM **не хуже** лучших — а на более сложных данных (много признаков, хитрые границы) часто **вырывается вперёд**.

### Итог Задания 3

**Что мы поняли:**
1. SVM — **достойный конкурент** моделям Модуля 3.
2. Сравнивать честно — только по **кросс-валидации** (привычка из 3.7).
3. `make_pipeline` со `StandardScaler` — правильный способ для SVM/KNN.

---

## Тайминг (90 минут)

| Время | Блок |
|------:|------|
| 0–10 | Повторение (`review.md`) |
| 10–24 | Идея SVM, отступ, опорные векторы (теория) |
| 24–36 | Мягкий отступ и C (теория) |
| 36–50 | Kernel trick (теория) |
| 50–66 | Задание 1 (первый SVM + граница) |
| 66–78 | Задание 2 (ядра, C, gamma) |
| 78–84 | Задание 3 (турнир моделей) |
| 84–88 | Самостоятельная (`homework.md`) |
| 88–90 | Итоги (`summary.md`) |
