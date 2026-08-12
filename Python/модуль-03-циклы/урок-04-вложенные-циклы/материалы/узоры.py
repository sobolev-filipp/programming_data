# ===== УЗОРЫ ВЛОЖЕННЫМИ ЦИКЛАМИ =====
# Внешний цикл рисует строки, внутренний — символы внутри строки.

# 1) Прямоугольник 5 строк x 8 звёзд
print("Прямоугольник:")
for row in range(5):
    for col in range(8):
        print("*", end="")
    print()

# 2) Треугольник: в строке row печатаем row звёзд (внутренний зависит от внешнего)
print("Треугольник:")
for row in range(1, 6):
    for col in range(row):
        print("*", end="")
    print()

# 3) Шахматка 8x8 через условие внутри вложенного цикла
print("Шахматка:")
for row in range(8):
    for col in range(8):
        if (row + col) % 2 == 0:
            print("#", end="")
        else:
            print(".", end="")
    print()
