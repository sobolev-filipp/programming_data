# Урок 2.3. Графики — резюме

---

## Глоссарий новых терминов

| Термин | Что это |
|--------|---------|
| **Matplotlib** | Главная библиотека Python для графиков. `import matplotlib.pyplot as plt`. |
| **Seaborn** | Надстройка над Matplotlib для красивых статистических графиков. `import seaborn as sns`. |
| **Figure (фигура)** | Холст. |
| **Axes (график)** | Один график на фигуре. |
| **Subplot** | Несколько графиков на одной фигуре сеткой. |
| **Heatmap** | Цветная сетка, цвет = число. |
| **Scatter plot** | График точек. |
| **Regression line** | Линия тренда поверх точек. |
| **KDE** | Гладкая кривая оценки распределения. |

---

## Главные мысли

1. **Числа лгут — графики нет.** Anscombe's Quartet: разные данные с одинаковыми статистиками.
2. **4 главных типа графика:** `plot` (линия), `scatter` (точки), `bar` (столбики), `hist` (распределение).
3. **Заголовок и подписи осей** — **обязательны** на каждом графике.
4. **Heatmap корреляций** — самый полезный график для первого знакомства с датасетом.
5. **Seaborn** даёт красивые графики **в одну строку**, особенно для статистики.

---

## Шпаргалка

### Импорты

```python
import matplotlib.pyplot as plt
import seaborn as sns
sns.set_theme()                          # красивый стиль
```

### Базовые графики

```python
plt.plot(x, y)                           # линия
plt.scatter(x, y)                        # точки
plt.bar(categories, values)              # столбики
plt.hist(data, bins=30)                  # распределение
plt.show()
```

### Настройка

```python
plt.figure(figsize=(10, 5))              # размер
plt.plot(x, y, color='red', linestyle='--', linewidth=2, label='данные')
plt.title("Заголовок")
plt.xlabel("ось X")
plt.ylabel("ось Y")
plt.legend()
plt.grid()
plt.savefig('plot.png', dpi=150, bbox_inches='tight')
plt.show()
```

### Subplots

```python
# Способ 1 — простой
plt.subplot(1, 2, 1)
plt.plot(x, y1)
plt.subplot(1, 2, 2)
plt.plot(x, y2)
plt.tight_layout()

# Способ 2 — современный
fig, axes = plt.subplots(2, 2, figsize=(10, 8))
axes[0, 0].plot(...)
axes[0, 0].set_title(...)
axes[0, 1].hist(...)
```

### Seaborn

```python
# Heatmap корреляций
sns.heatmap(df.corr(), annot=True, cmap='coolwarm', center=0)

# Scatter с раскраской
sns.scatterplot(data=df, x='Age', y='Fare', hue='Survived')

# Линия тренда
sns.regplot(data=df, x='Age', y='Fare')

# Гистограмма с разделением групп
sns.histplot(data=df, x='Age', hue='Survived', kde=True)

# Гистограмма категорий
sns.countplot(data=df, x='Pclass', hue='Survived')

# Все пары признаков
sns.pairplot(df, hue='species')
```

### Из Pandas

```python
df['col'].plot.hist(bins=30)
df['col'].plot.bar()
df['col'].plot.line()
```

---

## Главные ошибки

| Ошибка | Что не так | Как исправить |
|--------|-----------|---------------|
| График без `title`/`xlabel`/`ylabel` | Непонятно, что показано | Всегда подписывать |
| `plt.show()` ДО `plt.savefig()` | Сохранит пустую фигуру | Save сначала, потом show |
| Забыли `plt.figure()` для нового графика | Всё на одной фигуре | Каждый график — `plt.figure()` |
| Subplots без `tight_layout()` | Подписи перекрываются | Всегда добавлять |
| Гистограмма для категориального столбца | `hist` для чисел, не для категорий | Используй `bar` или `countplot` |

---

## Что должно остаться в голове после урока

1. Я могу нарисовать любой из 4 базовых графиков.
2. Я знаю, что **график без подписей — это не график**.
3. Я могу построить `heatmap` корреляций и прочитать его.
4. Я могу собрать subplots для отчёта.
5. Я могу сохранить график в файл.

---

## К следующему уроку

Следующий урок — **Урок 2.4. Мини-проект.** Применим **всё**, что прошли в Модуле 2: загрузка, очистка, графики, выводы.

Темы возможных проектов: исследование Iris, Titanic, California Housing или ваш собственный CSV из интернета.

> **Это первый ваш самостоятельный анализ данных.** Приведите тетрадку в красивый вид — пригодится для портфолио в финальном проекте.
