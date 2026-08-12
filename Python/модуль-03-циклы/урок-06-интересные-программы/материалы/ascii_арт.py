# ===== ASCII-АРТ И ЧИСЛОВЫЕ УЗОРЫ =====
# Вложенные циклы + умножение строки строят узоры любого размера.

size = int(input("Размер узора (например 5): "))

# --- 1) Ромб из звёзд ---
print("Ромб:")
for row in range(1, size + 1):                 # верхняя половина
    print(" " * (size - row) + "*" * (2 * row - 1))
for row in range(size - 1, 0, -1):             # нижняя половина
    print(" " * (size - row) + "*" * (2 * row - 1))

# --- 2) Числовой треугольник (внутренний зависит от строки) ---
print("Числовой треугольник:")
for row in range(1, size + 1):
    line = ""
    for col in range(1, row + 1):
        line += str(col)
    print(line)

# --- 3) Рамка size x size ---
print("Рамка:")
for row in range(size):
    for col in range(size):
        if row == 0 or row == size - 1 or col == 0 or col == size - 1:
            print("#", end="")
        else:
            print(" ", end="")
    print()
