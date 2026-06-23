# Урок 1.7. Практика на занятии (вместе с преподавателем)

> ### 💻 Как работать с кодом урока
> Весь код пишем в **одном ноутбуке** (`.ipynb`, в Google Colab или Jupyter), разбивая на **ячейки**: один логический шаг — одна ячейка, запускаем сверху вниз. Переменные сохраняются между ячейками, поэтому импорты, данные, модель и обучение держим в **разных** ячейках. Домашку продолжаем в **том же** ноутбуке (раздел `## Самостоятельная работа`), а ответы на 🤔-вопросы пишем в **Markdown-ячейках**. Отдельные `.py`-файлы не нужны — они пригодятся только для большого проекта (Модуль 9). Перед сдачей запусти ноутбук целиком («Перезапустить и выполнить всё»), чтобы проверить, что всё работает по порядку.


> Тетрадка: `lesson-1-7-derivatives.ipynb`. Все задания пишем вместе.

В первой ячейке:
```python
import numpy as np
import matplotlib.pyplot as plt
```

---

## Задание 1. Производная как наклон функции (18 минут)

### 1.1. Графическая интуиция

```python
xs = np.linspace(-3, 3, 100)
ys = xs ** 2          # парабола

plt.figure(figsize=(8, 5))
plt.plot(xs, ys, label="f(x) = x²")

# Касательная в точке x = 1
# f(1) = 1, наклон f'(1) = 2·1 = 2
# Касательная: y = 2·(x - 1) + 1 = 2x - 1
tangent_xs = np.array([-1, 3])
tangent_ys = 2 * tangent_xs - 1
plt.plot(tangent_xs, tangent_ys, '--', color='red', label="касательная в x=1, наклон=2")
plt.scatter([1], [1], color='red', s=100, zorder=5)

# Касательная в точке x = -2
# f(-2) = 4, наклон f'(-2) = -4
tangent_xs2 = np.array([-3, -1])
tangent_ys2 = -4 * (tangent_xs2 - (-2)) + 4
plt.plot(tangent_xs2, tangent_ys2, '--', color='green', label="касательная в x=-2, наклон=-4")
plt.scatter([-2], [4], color='green', s=100, zorder=5)

plt.axhline(0, color='gray', linewidth=0.5)
plt.axvline(0, color='gray', linewidth=0.5)
plt.grid()
plt.legend()
plt.title("Производная = наклон касательной")
plt.show()
```

**Спросить:**
- В точке x = 0 наклон какой? **0** (минимум функции, касательная горизонтальная).
- В точке x = 2 — какая производная? **2·2 = 4** (функция растёт со скоростью 4).
- В точке x = -3 — какая? **-6** (функция падает со скоростью 6).

### 1.2. Производная говорит про монотонность

```python
xs = np.linspace(-3, 3, 100)

# Возьмём «горбатую» функцию: f(x) = -x² + 5
ys = -xs ** 2 + 5
dys = -2 * xs        # производная: f'(x) = -2x

plt.figure(figsize=(10, 4))

plt.subplot(1, 2, 1)
plt.plot(xs, ys)
plt.title("f(x) = -x² + 5")
plt.axhline(0, color='gray', linewidth=0.5)
plt.grid()

plt.subplot(1, 2, 2)
plt.plot(xs, dys, color='red')
plt.axhline(0, color='gray', linewidth=0.5)
plt.title("f'(x) = -2x")
plt.grid()

plt.show()
```

**Обсудить:**
- Слева — холм с максимумом в `x = 0`.
- Справа — производная.
- Где функция растёт (`x < 0`)? Производная **положительна**.
- Где убывает (`x > 0`)? Производная **отрицательна**.
- В точке максимума (`x = 0`)? Производная **равна 0**.

> **Главный вывод:** производная меняет знак в точке максимума или минимума.

---

## Задание 2. Численная производная (15 минут)

### 2.1. Базовая функция

```python
def derivative(f, x, h=1e-4):
    """Центральная разность."""
    return (f(x + h) - f(x - h)) / (2 * h)
```

### 2.2. Проверка на f(x) = x²

```python
def f(x):
    return x ** 2

# Знаем, что f'(x) = 2x
# В точке 3: ожидаем 6
print(derivative(f, 3))      # ~6.0
print(derivative(f, 0))      # ~0
print(derivative(f, -5))     # ~-10
```

### 2.3. Проверка на f(x) = sin(x)

```python
def f(x):
    return np.sin(x)

# Знаем, что f'(x) = cos(x)
# В точке 0: cos(0) = 1
print(derivative(f, 0))            # ~1
# В точке π/2: cos(π/2) = 0
print(derivative(f, np.pi / 2))    # ~0
# В точке π: cos(π) = -1
print(derivative(f, np.pi))        # ~-1
```

### 2.4. Производная как массив

NumPy позволяет передать сразу массив x:

```python
def f(x):
    return x ** 3

xs = np.linspace(-3, 3, 100)
ys = f(xs)
dys = derivative(f, xs)   # массив производных!

plt.plot(xs, ys, label="f(x) = x³")
plt.plot(xs, dys, label="f'(x) = 3x²")
plt.legend()
plt.grid()
plt.show()
```

**Сравнить:** наша численная производная — должна совпасть с аналитической `3x²`. Если совпадает — наш `derivative` работает правильно.

### 2.5. Что будет при «плохой» h

```python
def f(x):
    return x ** 2

# h слишком большое — грубое приближение
print(derivative(f, 5, h=1))         # = (36 - 16) / 2 = 10  (по «случайности» точно)
print(derivative(f, 5, h=0.5))       # = (5.5²-4.5²)/1 = 10  (всё ещё точно для линейной разности)
# Парабола — особый случай, в общем случае большая h даёт ошибку

# h слишком маленькое — ошибка float
print(derivative(f, 5, h=1e-10))     # начинаются проблемы с точностью
print(derivative(f, 5, h=1e-15))     # вообще ерунда из-за округлений

# Оптимально: 1e-4 или 1e-5
print(derivative(f, 5, h=1e-4))      # ~10.0 — точно
```

> **Правило:** в практике используем `h = 1e-4` или `h = 1e-5`. Меньше — float портит, больше — приближение грубое.

---

## Задание 3. Градиент (15 минут)

### 3.1. Функция двух переменных

```python
def f(p):
    """f(x, y) = x² + y² — «чаша»."""
    return p[0] ** 2 + p[1] ** 2

# В точке (3, 4) значение функции:
point = np.array([3.0, 4.0])
print(f(point))      # 25
```

### 3.2. Численный градиент

```python
def numerical_gradient(f, point, h=1e-4):
    grad = np.zeros_like(point)
    for i in range(len(point)):
        p_plus = point.copy()
        p_minus = point.copy()
        p_plus[i] += h
        p_minus[i] -= h
        grad[i] = (f(p_plus) - f(p_minus)) / (2 * h)
    return grad


point = np.array([3.0, 4.0])
print(numerical_gradient(f, point))      # ~[6, 8]
```

**Проверка:** `∇f(x, y) = [2x, 2y]`, в (3, 4): `[6, 8]`. Совпало!

### 3.3. Градиент показывает «крутизну»

```python
points = [
    np.array([1.0, 0.0]),    # рядом с минимумом
    np.array([5.0, 5.0]),    # подальше
    np.array([10.0, 10.0]),  # ещё дальше
    np.array([0.1, 0.1]),    # совсем близко к минимуму
]

for p in points:
    g = numerical_gradient(f, p)
    print(f"Точка {p}, градиент {g}, длина {np.linalg.norm(g):.3f}")
```

**Что увидим:**
- Чем **дальше** точка от минимума, тем **больше** длина градиента.
- В минимуме (точка `(0, 0)`) градиент будет почти нулевой.
- Это значит: «крутизна спуска» зависит от того, **далеко ли мы от минимума**.

### 3.4. Визуализация градиента — стрелки

```python
# Сетка точек
x = np.linspace(-3, 3, 15)
y = np.linspace(-3, 3, 15)
X, Y = np.meshgrid(x, y)

# Значения функции
Z = X**2 + Y**2

# Антиградиент в каждой точке: (-2x, -2y)
U = -2 * X
V = -2 * Y

plt.figure(figsize=(8, 8))
plt.contour(X, Y, Z, levels=20)            # изолинии
plt.quiver(X, Y, U, V, alpha=0.7)           # стрелки антиградиента
plt.scatter([0], [0], color='red', s=200, marker='*', label='минимум')
plt.legend()
plt.title("Антиградиент f(x,y) = x² + y² — все стрелки ведут в минимум!")
plt.axis('equal')
plt.show()
```

**Что увидим:** все стрелки указывают **в центр** (на красную звезду = минимум). Это и есть смысл антиградиента: «вниз по самому крутому склону».

---

## Задание 4. Градиентный спуск (12 минут)

### 4.1. Простейшая реализация

```python
def gradient_descent(f, start, lr=0.1, n_steps=50, verbose=True):
    point = np.array(start, dtype=float)
    history = [point.copy()]

    for step in range(n_steps):
        grad = numerical_gradient(f, point)
        point = point - lr * grad
        history.append(point.copy())

        if verbose and step % 10 == 0:
            print(f"Шаг {step:3d}: точка = {point}, f = {f(point):.6f}")

    return point, np.array(history)


# Запускаем
final, history = gradient_descent(f, start=[5.0, 7.0])
print(f"\nИтог: {final}, f = {f(final):.6f}")
```

**Что увидим:**
```
Шаг   0: точка = [4.    5.6], f = 47.36
Шаг  10: точка = [0.537 0.751], f = 0.852
Шаг  20: точка = [0.058 0.080], f = 0.010
...
Итог: [~0, ~0], f ≈ 0
```

### 4.2. Нарисуем траекторию

```python
# Сетка для контурного графика
x = np.linspace(-1, 6, 100)
y = np.linspace(-1, 8, 100)
X, Y = np.meshgrid(x, y)
Z = X**2 + Y**2

plt.figure(figsize=(8, 8))
plt.contour(X, Y, Z, levels=30, cmap='viridis')
plt.plot(history[:, 0], history[:, 1], 'r-o', markersize=4, label='траектория')
plt.scatter([0], [0], color='lime', s=200, marker='*', label='минимум')
plt.title(f"Градиентный спуск: {len(history)} шагов")
plt.xlabel("x")
plt.ylabel("y")
plt.legend()
plt.show()
```

**Что увидим:** красная линия с точками «спускается» по «чаше» к минимуму в (0, 0).

### 4.3. Эксперимент: разные learning rate

```python
# Слишком большой
print("=== lr = 1.1 ===")
gradient_descent(f, start=[5.0, 7.0], lr=1.1, n_steps=15, verbose=True)

# Хороший
print("\n=== lr = 0.1 ===")
gradient_descent(f, start=[5.0, 7.0], lr=0.1, n_steps=15, verbose=True)

# Слишком маленький
print("\n=== lr = 0.001 ===")
gradient_descent(f, start=[5.0, 7.0], lr=0.001, n_steps=15, verbose=True)
```

**Что увидим:**
- `lr = 1.1` → точка скачет всё дальше («расходится»).
- `lr = 0.1` → плавно сходится к (0, 0).
- `lr = 0.001` → спускается, но очень медленно.

> **Это самая частая проблема в ML.** Подбор learning rate — отдельный навык.

---

## Тайминг (90 минут)

| Время | Блок |
|------:|------|
| 0–12 | Повторение |
| 12–22 | Введение «зачем» |
| 22–40 | Задание 1 (графика производной) |
| 40–55 | Задание 2 (численная производная) |
| 55–70 | Задание 3 (градиент) |
| 70–82 | Задание 4 (градиентный спуск) |
| 82–88 | Самостоятельная работа (`homework.md`) |
| 88–90 | Итоги |
