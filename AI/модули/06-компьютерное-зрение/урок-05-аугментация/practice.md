# Урок 6.5. Практика (вместе с преподавателем)

> Тетрадка: `lesson-6-5-augmentation.ipynb`. Работаем в Google Colab. **Включи GPU.**

---

## Что мы будем делать на уроке

**Сегодня — умножаем данные и поднимаем точность:**

1. **Задание 1:** **увидим** аугментацию — из одной картинки сделаем много вариантов.
2. **Задание 2:** обучим CIFAR **с аугментацией** и сравним с обучением **без** неё.

> Аугментация — пара строк в `transforms`. Главное — понять, **что** она делает и **куда** её ставить (только train!).

---

## Импорты

```python
import torch
import torch.nn as nn
from torch.utils.data import DataLoader
from torchvision import datasets, transforms
import matplotlib.pyplot as plt

device = "cuda" if torch.cuda.is_available() else "cpu"
print("Устройство:", device)
```

> ### 🖥️ Как включить GPU в Google Colab (один раз, ~20 секунд)
>
> 1. Меню Colab → **«Среда выполнения»** (*Runtime*) → **«Сменить среду выполнения»** (*Change runtime type*).
> 2. В поле **«Аппаратный ускоритель»** выбери **«T4 GPU»** → **«Сохранить»**.
> 3. Проверка: запусти ячейку выше — должно напечататься **`Устройство: cuda`**. Если `cpu` — повтори.
> ⚠️ После включения Colab перезапустит среду — запусти ячейки заново сверху.

> 📥 **Датасет CIFAR-10 скачается сам** (через `download=True`, см. урок 6.4) — искать ничего не надо.

---

## Задание 1. Видим аугментацию (12 минут)

### Что мы хотим сделать

Взять одну картинку и **посмотреть**, как аугментация делает из неё разные варианты.

### 1.1. Берём одну картинку CIFAR

```python
# Загружаем CIFAR без аугментации (просто чтобы взять картинку)
raw_data = datasets.CIFAR10(root='./data', train=True, download=True)
img, label = raw_data[7]              # одна картинка (это объект PIL)
print("Класс:", raw_data.classes[label])

plt.imshow(img); plt.title("Оригинал"); plt.axis('off'); plt.show()
```

### 1.2. Применяем разные аугментации

```python
augmentations = {
    "Оригинал":   transforms.Compose([]),
    "Отражение":  transforms.RandomHorizontalFlip(p=1.0),       # p=1 — точно отразить
    "Поворот":    transforms.RandomRotation(30),
    "Обрезка":    transforms.RandomResizedCrop(32, scale=(0.5, 0.9)),
    "Яркость":    transforms.ColorJitter(brightness=0.6, contrast=0.6),
}

plt.figure(figsize=(15, 3))
for i, (name, aug) in enumerate(augmentations.items()):
    plt.subplot(1, 5, i+1)
    plt.imshow(aug(img))
    plt.title(name); plt.axis('off')
plt.show()
```

#### Что увидим

- **Оригинал** — исходная картинка.
- **Отражение** — зеркальная (объект смотрит в другую сторону).
- **Поворот** — наклонённая.
- **Обрезка** — кусок, растянутый на весь размер.
- **Яркость** — посветлее/потемнее.

> **Из ОДНОЙ картинки — пять разных!** И это всё ещё тот же объект того же класса. А если применять **случайно** каждый раз — вариантов бесконечно. Вот так из 50 000 картинок получаются «миллионы».

### 1.3. Случайность — каждый раз по-новому

```python
# Применим случайную аугментацию 5 раз к одной картинке
aug = transforms.Compose([
    transforms.RandomHorizontalFlip(),
    transforms.RandomRotation(20),
    transforms.RandomResizedCrop(32, scale=(0.7, 1.0)),
])

plt.figure(figsize=(15, 3))
for i in range(5):
    plt.subplot(1, 5, i+1)
    plt.imshow(aug(img))            # каждый раз — РАЗНЫЙ результат!
    plt.title(f"Вариант {i+1}"); plt.axis('off')
plt.show()
```

**Что увидим:** 5 **разных** вариантов одной картинки! Случайные аугментации дают каждый раз новое. Сеть в каждую эпоху видит свежие варианты → не зубрит.

### Итог Задания 1

1. Аугментация делает из 1 картинки много вариантов.
2. Все варианты — тот же объект, тот же класс.
3. Случайность → каждый раз по-новому → сеть не зубрит.

---

## Задание 2. Обучаем с аугментацией (18 минут)

### Что мы хотим сделать

Обучить CIFAR **с аугментацией** и сравнить с обучением **без** неё.

### 2.1. Задаём transforms (train с аугментацией, test без!)

```python
# ОБУЧЕНИЕ — с аугментацией
train_transform = transforms.Compose([
    transforms.RandomHorizontalFlip(),        # отражение
    transforms.RandomCrop(32, padding=4),     # обрезка со сдвигом
    transforms.ToTensor()
])

# ТЕСТ — БЕЗ аугментации (честная оценка!)
test_transform = transforms.Compose([
    transforms.ToTensor()
])

train_data = datasets.CIFAR10(root='./data', train=True, download=True, transform=train_transform)
test_data = datasets.CIFAR10(root='./data', train=False, download=True, transform=test_transform)

train_loader = DataLoader(train_data, batch_size=128, shuffle=True)
test_loader = DataLoader(test_data, batch_size=1000)
```

> **Главное:** у `train_transform` есть аугментации, у `test_transform` — **только `ToTensor`**. Тест мы не трогаем (правило из теории!).

### 2.2. CNN (та же, что в 6.4)

```python
class CNN(nn.Module):
    def __init__(self):
        super().__init__()
        self.conv1 = nn.Conv2d(3, 32, 3, padding=1)
        self.conv2 = nn.Conv2d(32, 64, 3, padding=1)
        self.pool = nn.MaxPool2d(2)
        self.fc1 = nn.Linear(64 * 8 * 8, 128)
        self.fc2 = nn.Linear(128, 10)
    def forward(self, x):
        x = self.pool(torch.relu(self.conv1(x)))
        x = self.pool(torch.relu(self.conv2(x)))
        x = x.view(x.size(0), -1)
        x = torch.relu(self.fc1(x))
        return self.fc2(x)

net = CNN().to(device)
```

### 2.3. Обучаем (цикл тот же)

```python
loss_fn = nn.CrossEntropyLoss()
optimizer = torch.optim.Adam(net.parameters(), lr=0.001)

for epoch in range(15):
    net.train()
    for x_batch, y_batch in train_loader:
        x_batch, y_batch = x_batch.to(device), y_batch.to(device)
        optimizer.zero_grad()
        loss = loss_fn(net(x_batch), y_batch)
        loss.backward()
        optimizer.step()

    net.eval()
    correct = total = 0
    with torch.no_grad():
        for x_batch, y_batch in test_loader:
            x_batch, y_batch = x_batch.to(device), y_batch.to(device)
            preds = net(x_batch).argmax(dim=1)
            correct += (preds == y_batch).sum().item()
            total += len(y_batch)
    print(f"Эпоха {epoch+1}: точность {correct/total:.4f}")
```

> **Цикл обучения тот же**, что в 6.4! Изменился только `train_transform` (добавили аугментацию). Никаких изменений в сети или цикле.

**Что увидим (примерно):**
```
Эпоха 5:  точность 0.68
Эпоха 10: точность 0.73
Эпоха 15: точность 0.76
```

### 2.4. Сравнение: с аугментацией vs без

```python
print("Без аугментации (Урок 6.4): ~0.70")
print(f"С аугментацией (сегодня):    {correct/total:.2f}")
print()
print("Аугментация подняла точность на несколько процентов!")
print("И главное — сеть МЕНЬШЕ переобучается (разрыв train/test меньше).")
```

#### Что это значит

> 🎉 **Аугментация подняла точность** (например, с ~70% до ~75%)! Та же сеть, тот же цикл — но мы показали ей картинки в разных вариантах, и она стала **устойчивее** и **меньше зубрит**. Это «бесплатные данные»: пара строк `transforms`, заметный прирост.
>
> ⚠️ **Честно:** прирост зависит от числа эпох и аугментаций. На малом числе эпох эффект скромнее, на большом (20–30) — заметнее. Аугментация раскрывается при **долгом** обучении (сеть успевает «переварить» разнообразие).

### 2.5. Проверим, что переобучение меньше

```python
# Точность на train (аугментированном) и test
net.eval()
def accuracy(loader):
    c = t = 0
    with torch.no_grad():
        for xb, yb in loader:
            c += (net(xb.to(device)).argmax(1) == yb.to(device)).sum().item(); t += len(yb)
    return c / t

print(f"Train: {accuracy(train_loader):.3f}, Test: {accuracy(test_loader):.3f}")
# с аугментацией разрыв train-test МЕНЬШЕ, чем без неё
```

> **Меньший разрыв train-test** = меньше переобучения. Аугментация не даёт сети зазубрить картинки — она каждый раз видит новые варианты.

### Итог Задания 2

1. Аугментация — только в `train_transform` (тест без неё!).
2. Точность выросла, переобучение уменьшилось.
3. Сеть и цикл не менялись — только добавили аугментацию.

---

## Тайминг (90 минут)

| Время | Блок |
|------:|------|
| 0–10 | Повторение (`review.md`) |
| 10–48 | Переобучение, аугментация, виды (теория) |
| 48–60 | Задание 1 (видим аугментацию) |
| 60–80 | Задание 2 (обучаем с аугментацией) |
| 80–86 | Самостоятельная (`homework.md`) |
| 86–90 | Итоги (`summary.md`) |
