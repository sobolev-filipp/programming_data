# ===== КАЛЬКУЛЯТОР =====
# Эталонный код урока 2. Запусти: Run ▶ (PyCharm / VS Code) или  python калькулятор.py
# ВНИМАНИЕ: второе число не вводи 0 — на ноль делить нельзя (ZeroDivisionError).

a = int(input("Первое число: "))
b = int(input("Второе число: "))

print("=" * 24)
print(f"{a} + {b} = {a + b}")
print(f"{a} - {b} = {a - b}")
print(f"{a} * {b} = {a * b}")
print(f"{a} / {b} = {a / b}")
print(f"{a} // {b} = {a // b}   (нацело)")
print(f"{a} % {b} = {a % b}   (остаток)")
print(f"{a} ** {b} = {a ** b}   (степень)")
print(f"Среднее: {(a + b) / 2}")
