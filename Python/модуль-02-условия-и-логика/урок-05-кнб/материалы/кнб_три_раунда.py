# ===== КАМЕНЬ-НОЖНИЦЫ-БУМАГА (3 раунда, со счётом) =====
# Играем 3 раунда, ведём счёт копилками (Урок 4) и объявляем чемпиона.
# Раунды написаны подряд, потому что цикл будет только в Модуле 3.

import random

variants = ["камень", "ножницы", "бумага"]
wins = 0     # копилка побед игрока
losses = 0   # копилка побед компьютера

print("=" * 34)
print("КНБ: ЛУЧШИЙ ИЗ 3 РАУНДОВ")
print("=" * 34)

# --- Раунд 1 ---
player = input("\nРаунд 1. Твой выбор: ").lower().strip()
comp = random.choice(variants)
print(f"Компьютер: {comp}")
if player == comp:
    print("Ничья.")
elif (player == "камень" and comp == "ножницы") or (player == "ножницы" and comp == "бумага") or (player == "бумага" and comp == "камень"):
    print("Раунд за тобой!")
    wins += 1
else:
    print("Раунд за компьютером.")
    losses += 1

# --- Раунд 2 ---
player = input("\nРаунд 2. Твой выбор: ").lower().strip()
comp = random.choice(variants)
print(f"Компьютер: {comp}")
if player == comp:
    print("Ничья.")
elif (player == "камень" and comp == "ножницы") or (player == "ножницы" and comp == "бумага") or (player == "бумага" and comp == "камень"):
    print("Раунд за тобой!")
    wins += 1
else:
    print("Раунд за компьютером.")
    losses += 1

# --- Раунд 3 ---
player = input("\nРаунд 3. Твой выбор: ").lower().strip()
comp = random.choice(variants)
print(f"Компьютер: {comp}")
if player == comp:
    print("Ничья.")
elif (player == "камень" and comp == "ножницы") or (player == "ножницы" and comp == "бумага") or (player == "бумага" and comp == "камень"):
    print("Раунд за тобой!")
    wins += 1
else:
    print("Раунд за компьютером.")
    losses += 1

# --- Итог серии ---
print("\n" + "=" * 34)
print(f"СЧЁТ: ты {wins} : {losses} компьютер")
if wins > losses:
    print("ЧЕМПИОН - ТЫ! Поздравляем!")
elif losses > wins:
    print("Победил компьютер. Реванш?")
else:
    print("Ничья по серии! Силы равны.")
