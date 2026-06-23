# Урок 6.3. Практика (вместе с преподавателем)

> ### 💻 Как работать с кодом урока
> Весь код пишем в **одном ноутбуке** (`.ipynb`, в Google Colab или Jupyter), разбивая на **ячейки**: один логический шаг — одна ячейка, запускаем сверху вниз. Переменные сохраняются между ячейками, поэтому импорты, данные, модель и обучение держим в **разных** ячейках. Домашку продолжаем в **том же** ноутбуке (раздел `## Самостоятельная работа`), а ответы на 🤔-вопросы пишем в **Markdown-ячейках**. Отдельные `.py`-файлы не нужны — они пригодятся только для большого проекта (Модуль 9). Перед сдачей запусти ноутбук целиком («Перезапустить и выполнить всё»), чтобы проверить, что всё работает по порядку.


> Тетрадка: `lesson-6-3-cnn.ipynb`. Работаем в Google Colab. **Включи GPU!**

---

## Что мы будем делать на уроке

**Сегодня — соберём настоящую CNN и побьём нашу MLP:**

1. **Задание 1:** соберём **класс CNN** на PyTorch (свёртки + пулинг + классификатор).
2. **Задание 2:** обучим её на MNIST → **~99%** и сравним с MLP из 5.8.

> Всё знакомо: PyTorch (5.7), MNIST (5.8), свёртка и пулинг (6.2). Сегодня собираем из них CNN.

---

## Импорты

```python
import torch
import torch.nn as nn
from torch.utils.data import DataLoader
from torchvision import datasets, transforms

device = "cuda" if torch.cuda.is_available() else "cpu"
print("Устройство:", device)        # cuda если включил GPU
```

> ### 🖥️ Как включить GPU в Google Colab (один раз, ~20 секунд)
>
> 1. Меню Colab → **«Среда выполнения»** (*Runtime*) → **«Сменить среду выполнения»** (*Change runtime type*).
> 2. В поле **«Аппаратный ускоритель»** выбери **«T4 GPU»** → **«Сохранить»**.
> 3. Проверка: запусти ячейку выше — должно напечататься **`Устройство: cuda`**. Если `cpu` — повтори.
> ⚠️ После включения Colab перезапустит среду — запусти ячейки заново сверху.

---

## Задание 1. Собираем CNN (20 минут)

### Что мы хотим сделать

Построить свёрточную сеть из кубиков `Conv2d` и `MaxPool2d`.

### 1.1. Данные MNIST (как в 5.8)

```python
transform = transforms.ToTensor()
train_data = datasets.MNIST(root='./data', train=True, download=True, transform=transform)
test_data = datasets.MNIST(root='./data', train=False, download=True, transform=transform)

train_loader = DataLoader(train_data, batch_size=64, shuffle=True)
test_loader = DataLoader(test_data, batch_size=1000)
```

> **Важно:** для CNN картинку **НЕ вытягиваем** в 784! CNN работает с картинкой как с картинкой (28×28). Это её преимущество.

### 1.2. Строим класс CNN

```python
class CNN(nn.Module):
    def __init__(self):
        super().__init__()
        # === ИЗВЛЕКАТЕЛЬ ПРИЗНАКОВ (свёртки + пулинг) ===
        self.conv1 = nn.Conv2d(1, 16, kernel_size=3, padding=1)   # 1 → 16 каналов
        self.conv2 = nn.Conv2d(16, 32, kernel_size=3, padding=1)  # 16 → 32 канала
        self.pool = nn.MaxPool2d(2)                                # уменьшает вдвое
        # === КЛАССИФИКАТОР (обычные слои) ===
        self.fc1 = nn.Linear(32 * 7 * 7, 64)
        self.fc2 = nn.Linear(64, 10)

    def forward(self, x):
        x = self.pool(torch.relu(self.conv1(x)))    # 28×28 → 14×14, 16 каналов
        x = self.pool(torch.relu(self.conv2(x)))    # 14×14 → 7×7, 32 канала
        x = x.view(x.size(0), -1)                    # вытянуть: 32×7×7 = 1568
        x = torch.relu(self.fc1(x))                  # классификатор
        return self.fc2(x)                           # 10 цифр (без softmax)

net = CNN().to(device)
print(net)
print("Параметров:", sum(p.numel() for p in net.parameters()))   # ~106 000
```

#### Что мы собрали — разбор

- **`conv1` (1→16):** первый свёрточный слой, 16 фильтров → 16 карт признаков.
- **`conv2` (16→32):** второй слой, 32 фильтра (детали из краёв).
- **`pool`:** после каждой свёртки уменьшаем картинку вдвое.
- **`fc1, fc2`:** обычные слои-классификатор (наша MLP внутри CNN!).

> **Заметь динамику в `forward`:** 28×28 → (пулинг) 14×14 → (пулинг) 7×7. Размер падает, каналы растут (1→16→32). Перед классификатором «вытягиваем» 32×7×7 = 1568 признаков.

### 1.3. Проверим, что данные проходят

```python
# Возьмём один батч и прогоним через сеть
images, labels = next(iter(train_loader))
images = images.to(device)
output = net(images)
print("Вход:", images.shape)        # [64, 1, 28, 28] — 64 картинки 28×28
print("Выход:", output.shape)        # [64, 10] — 64 ответа по 10 цифр
```

**Что увидим:** вход `[64, 1, 28, 28]` (батч картинок), выход `[64, 10]` (по 10 чисел на картинку). Сеть собрана правильно — данные проходят!

### Итог Задания 1

1. Собрали CNN: свёртки + пулинг (признаки) + Linear (классификатор).
2. ~106 000 параметров.
3. Данные проходят: картинка → 10 ответов.

---

## Задание 2. Обучаем CNN на MNIST (12 минут)

### Что мы хотим сделать

Обучить нашу CNN и сравнить с MLP из Урока 5.8.

### 2.1. Цикл обучения (как в 5.8)

```python
loss_fn = nn.CrossEntropyLoss()
optimizer = torch.optim.Adam(net.parameters(), lr=0.001)

for epoch in range(3):
    net.train()
    for x_batch, y_batch in train_loader:
        x_batch, y_batch = x_batch.to(device), y_batch.to(device)
        optimizer.zero_grad()
        loss = loss_fn(net(x_batch), y_batch)
        loss.backward()
        optimizer.step()

    # Проверка на тесте
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

> **Цикл обучения ТОТ ЖЕ**, что для MLP (5.8)! zero_grad → forward → loss → backward → step. PyTorch и autograd сами разберутся со свёртками — нам не пришлось писать backward для них. Вот сила фреймворка.

**Что увидим (примерно):**
```
Эпоха 1: точность 0.9761
Эпоха 2: точность 0.9834
Эпоха 3: точность 0.9870
```

(С 5+ эпохами дойдёт до ~0.99.)

### 2.2. Сравниваем CNN и MLP

```python
print("=" * 35)
print("MLP (Урок 5.8):  ~0.970")
print(f"CNN (сегодня):   {correct/total:.3f}")
print("=" * 35)
mlp_err = (1 - 0.97) * 10000
cnn_err = (1 - correct/total) * 10000
print(f"Ошибок MLP: ~{mlp_err:.0f} из 10000")
print(f"Ошибок CNN: ~{cnn_err:.0f} из 10000")
```

#### Что это значит

```
MLP: ~300 ошибок из 10000
CNN: ~130 ошибок из 10000   ← в 2+ раза меньше!
```

> 🎉 **CNN побила MLP!** Та же задача, те же цифры — но свёрточная сеть ошибается **в 2+ раза реже**. Почему? Свёртки **сохранили структуру** картинки (соседство пикселей), нашли узоры **в любом месте** и собрали их в иерархию. MLP «вытягивала» картинку и теряла всё это. Вот зачем нужны свёртки — они реально видят лучше.

### 2.3. Посмотрим на предсказания

```python
import matplotlib.pyplot as plt
net.eval()
images, labels = next(iter(test_loader))
with torch.no_grad():
    preds = net(images.to(device)).argmax(dim=1).cpu()

fig, axes = plt.subplots(2, 5, figsize=(12, 5))
for i, ax in enumerate(axes.flat):
    ax.imshow(images[i].squeeze(), cmap='gray')
    ok = preds[i] == labels[i]
    ax.set_title(f"CNN: {preds[i]}", color='green' if ok else 'red')
    ax.axis('off')
plt.show()
```

**Что увидим:** цифры с предсказаниями CNN — почти все верные (зелёные).

### Итог Задания 2

1. Обучили CNN на MNIST → **~98–99%**.
2. CNN **побила MLP** (ошибок в 2+ раза меньше).
3. Цикл обучения тот же — PyTorch сам справился со свёртками.

---

## Тайминг (90 минут)

| Время | Блок |
|------:|------|
| 0–10 | Повторение (`review.md`) |
| 10–50 | Конвейер CNN, слои, архитектура (теория) |
| 50–70 | Задание 1 (собираем CNN) |
| 70–82 | Задание 2 (обучаем, сравниваем) |
| 82–86 | Самостоятельная (`homework.md`) |
| 86–90 | Итоги (`summary.md`) |
