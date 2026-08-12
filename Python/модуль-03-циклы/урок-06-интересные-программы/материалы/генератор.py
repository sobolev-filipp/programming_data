# ===== ГЕНЕРАТОР ПАРОЛЕЙ И НИКОВ =====
# Цикл for + random.choice собирают строку по одному символу/слову.

import random

# --- 1) Пароль нужной длины ---
symbols = "abcdefghijklmnopqrstuvwxyz0123456789!@#$%"
length = int(input("Длина пароля: "))

password = ""                       # начинаем с пустой строки-копилки
for i in range(length):
    password += random.choice(symbols)   # добавляем случайный символ
print("Твой пароль:", password)

# --- 2) Три случайных ника ---
adjectives = ["Быстрый", "Тёмный", "Дикий", "Хитрый", "Ледяной", "Огненный"]
nouns = ["Волк", "Дракон", "Ниндзя", "Феникс", "Тигр", "Робот"]

print("Ники на выбор:")
for i in range(3):
    nick = random.choice(adjectives) + random.choice(nouns) + str(random.randint(1, 99))
    print("-", nick)
