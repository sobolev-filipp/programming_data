# Урок 3.8. Показательные примеры (короткая разминка)

> На контрольной времени мало, поэтому здесь — **короткий блок** из 2–3 типовых примеров для совместного разбора. Можно пропустить, если ученики готовы.
>
> **Эти примеры НЕ попадут в контрольную.** Они для «настройки руки».

---

## Пример 1. Полный workflow классификации (5 минут)

> Напоминаем «скелет» любой ML-задачи классификации.

```python
# 1. Данные
X = df[['feature1', 'feature2']]
y = df['target']

# 2. Split (для классификации — со stratify!)
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y)

# 3. (Для KNN/логрег — стандартизация. Для дерева/леса — пропустить)
scaler = StandardScaler()
X_train_s = scaler.fit_transform(X_train)
X_test_s = scaler.transform(X_test)      # transform, НЕ fit!

# 4. Модель
model = LogisticRegression(max_iter=1000)
model.fit(X_train_s, y_train)
preds = model.predict(X_test_s)

# 5. Метрики
print(f"Accuracy:  {accuracy_score(y_test, preds):.3f}")
print(f"Precision: {precision_score(y_test, preds):.3f}")
print(f"Recall:    {recall_score(y_test, preds):.3f}")
print(confusion_matrix(y_test, preds))
```

**Главные приёмы:** split → (стандартизация) → fit → predict → метрики. Этот «скелет» — основа почти всех задач контрольной.

---

## Пример 2. Регрессия + правильные метрики (4 минуты)

> Напоминаем: для **числа** — другие метрики!

```python
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

model = LinearRegression()
model.fit(X_train, y_train)
preds = model.predict(X_test)

mae = mean_absolute_error(y_test, preds)
rmse = np.sqrt(mean_squared_error(y_test, preds))
r2 = r2_score(y_test, preds)
print(f"MAE: {mae:.2f}, RMSE: {rmse:.2f}, R²: {r2:.3f}")
```

**Главные приёмы:**
- Для регрессии **нет stratify** (целевая — число, не классы).
- Метрики — **MAE/RMSE/R²**, а **не** accuracy.
- RMSE = `np.sqrt(MSE)`.

---

## Пример 3. Сравнение моделей по кросс-валидации (4 минуты)

> Напоминаем честный способ сравнивать модели.

```python
models = {
    'Дерево': DecisionTreeClassifier(max_depth=4, random_state=42),
    'Лес':    RandomForestClassifier(n_estimators=100, random_state=42),
}
for name, model in models.items():
    scores = cross_val_score(model, X, y, cv=5)
    print(f"{name}: {scores.mean():.3f} ± {scores.std():.3f}")
```

**Главные приёмы:**
- `cross_val_score` получает **весь** X и y (сам делит на фолды).
- Сравниваем по **средней** CV-точности, а не по одному split.
- `std` показывает стабильность.

---

## Готовы?

Если примеры понятны — переходите к [homework.md](homework.md) и начинайте контрольную.

Если что-то не ясно — поднимите руку, преподаватель подойдёт **до** начала контрольной.
