# ===== АНИМАЦИЯ В КОНСОЛИ (time.sleep) =====
# time.sleep(секунды) делает ПАУЗУ.
# Приём end="\r" возвращает курсор в начало строки — можно перерисовывать её.

import time

# 1) обратный отсчёт с паузой в 1 секунду
for i in range(3, 0, -1):
    print(i)
    time.sleep(1)
print("Поехали!")

# 2) прогресс-бар: строка перерисовывается на месте
print("Загрузка:")
for i in range(1, 11):
    bar = "#" * i + "." * (10 - i)        # 10 клеток: # заполнено, . пусто
    print(f"[{bar}] {i * 10}%", end="\r") # \r — вернуться в начало строки
    time.sleep(0.2)
print()                                    # перевод строки после бара
print("Готово!")

# 3) бегущая строка
text = "PYTHON "
for i in range(len(text) * 2):
    shift = i % len(text)                  # сдвиг по кругу
    line = text[shift:] + text[:shift]     # прокрутка строки
    print(line, end="\r")
    time.sleep(0.15)
print()
