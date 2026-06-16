# Урок 3.3. Линейная регрессия — резюме

---

## Глоссарий новых терминов

| Термин | Что это |
|--------|---------|
| **Линейная регрессия** | Модель `y = w·x + b` для предсказания числа |
| **`coef_`** | Веса признаков (`w`) |
| **`intercept_`** | Смещение (`b`) |
| **MAE** | Средний модуль ошибки |
| **MSE** | Средний квадрат ошибки (штрафует большие сильнее) |
| **RMSE** | √MSE — в единицах y |
| **R²** | От 0 до 1 — доля объяснённой дисперсии |
| **Стандартизация** | `(x - mean) / std`, среднее 0, std 1 |
| **`StandardScaler`** | Scikit-learn класс для стандартизации |

---

## Главные мысли

1. **Линейная регрессия** = `y = w1·x1 + w2·x2 + ... + b`. Веса подбираются.
2. **4 метрики:** MAE (модуль), MSE (квадрат), RMSE (корень из MSE), R² (от 0 до 1).
3. **`accuracy` для регрессии не работает!** Только метрики ошибки.
4. **Стандартизация** обязательна для KNN/SVM/нейросетей. Деревьям — не нужна.
5. **`scaler.fit_transform(X_train)`, `scaler.transform(X_test)`** — никогда `fit` на test!

---

## Шаблон ML-кода для регрессии

```python
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
import numpy as np

# Данные
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# (опционально) Стандартизация
scaler = StandardScaler()
X_train = scaler.fit_transform(X_train)
X_test = scaler.transform(X_test)

# Модель
model = LinearRegression()
model.fit(X_train, y_train)
preds = model.predict(X_test)

# Метрики
print(f"MAE:  {mean_absolute_error(y_test, preds):.2f}")
print(f"RMSE: {np.sqrt(mean_squared_error(y_test, preds)):.2f}")
print(f"R²:   {r2_score(y_test, preds):.4f}")
```

---

## Главные ошибки

| Ошибка | Что не так | Как исправить |
|--------|-----------|---------------|
| `accuracy_score(y_test, preds)` для регрессии | Не работает | MAE/RMSE/R² |
| `scaler.fit_transform(X_test)` | «Утечка» | `transform` без `fit` |
| Забыли `random_state` в split | Не воспроизвести | Везде `random_state=42` |
| Сравнивают `coef_` без стандартизации | Шкалы разные | Стандартизировать |

---

## Что должно остаться в голове после урока

1. Я знаю, что **линейная регрессия** ищет `y = w·x + b`.
2. Я различаю **MAE, MSE, RMSE, R²**.
3. Я могу обучить `LinearRegression` через 3 строки sklearn.
4. Я понимаю, **зачем** нужна стандартизация (для KNN).
5. Я знаю правило `fit_transform(train)` / `transform(test)`.

---

## К следующему уроку

**Урок 3.4. Логистическая регрессия.** Будем:
- Возвращаться к **классификации**.
- Разбирать **логистическую регрессию**.
- Метрики: precision, recall, F1.
- **Confusion matrix**.

Это последняя «базовая» модель перед алгоритмами (Урок 3.5+).
