# Урок 3.3. Практика (вместе с преподавателем)

> Тетрадка: `lesson-3-3-linreg.ipynb`.

---

## Импорты

```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
sns.set_theme()

from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
```

---

## Задание 1. Первая линейная регрессия (15 минут)

**Задача:** обучить модель `y = w·x + b` на 5 точках и увидеть **прямую линию** через них.

### 1.1. Создаём данные

```python
X = np.array([[2], [4], [6], [8], [10]])    # часы учёбы (в виде матрицы!)
y = np.array([3.0, 3.8, 4.2, 4.5, 4.9])     # оценки

print("X shape:", X.shape)        # (5, 1) — обязательно 2D!
print("y shape:", y.shape)        # (5,)
```

> **Важно:** для sklearn `X` должен быть **двумерным**, даже для одного признака. Поэтому `[[2], [4], ...]`, а не `[2, 4, ...]`.

### 1.2. Обучаем

```python
model = LinearRegression()
model.fit(X, y)

print("w (наклон):", model.coef_[0])
print("b (смещение):", model.intercept_)
```

**Ожидаемое:**
- `w ≈ 0.225`
- `b ≈ 2.62`

> **Что это значит:** модель «придумала» формулу `y = 0.225 · часы + 2.62`. Каждый дополнительный час учёбы добавляет 0.225 к оценке.

### 1.3. Рисуем график

```python
plt.scatter(X, y, color='blue', s=100, label='Реальные точки')

# Линия регрессии: рисуем для x от 0 до 12
x_line = np.linspace(0, 12, 100).reshape(-1, 1)
y_line = model.predict(x_line)
plt.plot(x_line, y_line, color='red', label=f'Линия: y = {model.coef_[0]:.2f}·x + {model.intercept_:.2f}')

plt.xlabel("Часы учёбы")
plt.ylabel("Оценка")
plt.title("Линейная регрессия")
plt.legend()
plt.grid()
plt.show()
```

**Что увидим:** **прямая красная линия** проходит **через** синие точки (или близко к ним).

### 1.4. Предсказание для нового значения

```python
# Сколько получит ученик, который учится 5 часов?
prediction = model.predict([[5]])
print(f"Для 5 часов учёбы: оценка {prediction[0]:.2f}")
# Ожидаемое: ~3.75
```

---

## Задание 2. California Housing — полный workflow (18 минут)

**Задача:** обучить регрессию на **20 640 районах** Калифорнии и оценить через **4 метрики**.

### 2.1. Загрузка

```python
url = "https://raw.githubusercontent.com/ageron/handson-ml2/master/datasets/housing/housing.csv"
df = pd.read_csv(url)
print(df.shape)            # (20640, 10)
df.head()
```

### 2.2. Очистка

```python
# Пропуски в total_bedrooms
df['total_bedrooms'] = df['total_bedrooms'].fillna(df['total_bedrooms'].median())

# Удалим категориальный пока (его обработать сложнее)
df = df.drop(columns=['ocean_proximity'])

print("Пропуски:", df.isna().sum().sum())     # 0
```

### 2.3. X и y

```python
X = df.drop(columns=['median_house_value'])
y = df['median_house_value']

print("X shape:", X.shape)
print("y shape:", y.shape)
print("\nПризнаки:", list(X.columns))
```

### 2.4. Train/Test split

```python
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

print(f"Train: {X_train.shape}, Test: {X_test.shape}")
```

### 2.5. Модель

```python
model = LinearRegression()
model.fit(X_train, y_train)
predictions = model.predict(X_test)
```

### 2.6. Все 4 метрики

```python
mae = mean_absolute_error(y_test, predictions)
mse = mean_squared_error(y_test, predictions)
rmse = np.sqrt(mse)
r2 = r2_score(y_test, predictions)

print(f"MAE:  ${mae:.0f}")          # ~$50 000
print(f"MSE:  {mse:.0f}")           # огромное число (квадраты)
print(f"RMSE: ${rmse:.0f}")         # ~$70 000
print(f"R²:   {r2:.4f}")            # ~0.64
```

**Что эти числа значат:**

- **MAE ≈ $50 000** — модель в среднем ошибается на 50 тысяч долларов.
- **RMSE ≈ $70 000** — RMSE больше MAE, потому что **большие ошибки штрафуются сильнее**.
- **R² ≈ 0.64** — модель объясняет **64% разброса** цен. Не идеально, но базовая модель — нормально.

### 2.7. Сравним с «глупым» предсказателем

> Что если модель **просто всегда** предсказывает среднюю цену?

```python
mean_pred = np.full_like(y_test, y_test.mean(), dtype=float)
mae_mean = mean_absolute_error(y_test, mean_pred)
print(f"MAE 'всегда среднее': ${mae_mean:.0f}")
```

**Что увидим:** MAE «глупой» модели **больше**, чем у нашей. Это хорошо — наша модель **лучше глупой**.

### 2.8. Визуализация

```python
plt.figure(figsize=(8, 8))
plt.scatter(y_test, predictions, alpha=0.3)

# Идеальная диагональ
diag = np.linspace(y_test.min(), y_test.max(), 100)
plt.plot(diag, diag, color='red', linestyle='--', label='Идеально')

plt.xlabel("Реальная цена")
plt.ylabel("Предсказанная цена")
plt.title("Реальные vs Предсказанные цены")
plt.legend()
plt.show()
```

**Что увидим:** точки лежат **вдоль** красной линии — это хорошо. Чем ближе к диагонали — тем точнее модель.

---

## Задание 3. Стандартизация (12 минут)

**Задача:** показать, что для **KNN** стандартизация **кардинально** меняет результат.

### 3.1. KNN без стандартизации

```python
from sklearn.neighbors import KNeighborsRegressor

knn = KNeighborsRegressor(n_neighbors=5)
knn.fit(X_train, y_train)
predictions_knn = knn.predict(X_test)

r2_no_scale = r2_score(y_test, predictions_knn)
rmse_no_scale = np.sqrt(mean_squared_error(y_test, predictions_knn))

print(f"KNN без стандартизации: R² = {r2_no_scale:.4f}, RMSE = ${rmse_no_scale:.0f}")
```

**Ожидаемое:** R² **низкий** (~0.15), RMSE большой.

### 3.2. KNN со стандартизацией

```python
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

knn_scaled = KNeighborsRegressor(n_neighbors=5)
knn_scaled.fit(X_train_scaled, y_train)
predictions_knn_scaled = knn_scaled.predict(X_test_scaled)

r2_scaled = r2_score(y_test, predictions_knn_scaled)
rmse_scaled = np.sqrt(mean_squared_error(y_test, predictions_knn_scaled))

print(f"KNN со стандартизацией: R² = {r2_scaled:.4f}, RMSE = ${rmse_scaled:.0f}")
```

**Ожидаемое:** R² **в 4-5 раз выше** (~0.65)!

> **Шок-эффект:** одна и та же модель, одни и те же данные — но **разница огромная**. Это и есть «суперсила» стандартизации.

### 3.3. Сравнение для разных моделей

```python
from sklearn.linear_model import LinearRegression
from sklearn.tree import DecisionTreeRegressor

models = {
    'LinearReg': LinearRegression(),
    'KNN-5': KNeighborsRegressor(n_neighbors=5),
    'DecisionTree': DecisionTreeRegressor(random_state=42)
}

print(f"{'Модель':<15} {'Без станд.':<12} {'Со станд.':<12}")
for name, model in models.items():
    # Без стандартизации
    model.fit(X_train, y_train)
    r2_raw = model.score(X_test, y_test)
    # Со стандартизацией
    model.fit(X_train_scaled, y_train)
    r2_scl = model.score(X_test_scaled, y_test)
    print(f"{name:<15} {r2_raw:<12.4f} {r2_scl:<12.4f}")
```

**Что увидим:**
- **LinearRegression** — почти **без разницы**.
- **KNN** — **огромный** прирост.
- **DecisionTree** — почти без разницы (деревьям не важна шкала).

> **Это и есть правило:** для одних моделей стандартизация **критична**, для других — **бесполезна**.

---

## Тайминг

| Время | Блок |
|------:|------|
| 0–10 | Повторение |
| 10–35 | Теория + Задание 1 |
| 35–53 | Задание 2 (California Housing) |
| 53–65 | Задание 3 (стандартизация) |
| 65–80 | Самостоятельная |
| 80–87 | Итоги |
