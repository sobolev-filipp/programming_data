import random

# ===== ГЕНЕРАТОР ПАРОЛЕЙ =====
# Эталонный код урока 3. Запусти: Run ▶ (PyCharm / VS Code) или  python генератор_паролей.py

name = input("Введи имя (для основы пароля): ").strip()

# 1. Случайный 4-значный PIN
pin = random.randint(1000, 9999)

# 2. Пароль: имя + случайный символ + случайное число
symbol = random.choice(["!", "@", "#", "$", "%", "&", "*"])
password = name.lower() + symbol + str(random.randint(10, 99))

print("=" * 30)
print(f"Твой PIN-код: {pin}")
print(f"Твой пароль:  {password}")
print("(запиши и никому не показывай!)")
