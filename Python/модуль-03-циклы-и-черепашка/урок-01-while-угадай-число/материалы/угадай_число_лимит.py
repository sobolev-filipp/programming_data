# ===== УГАДАЙ ЧИСЛО (версия 🎓 с лимитом попыток) =====
# То же, но у игрока только 7 попыток. Если не угадал — компьютер победил.
# Здесь два условия выхода: угадал (break) ИЛИ попытки кончились (условие while).

import random

secret = random.randint(1, 100)
attempts = 0
max_attempts = 7                  # больше 7 попыток не даём
won = False                       # флаг победы: пока не угадал

print("У тебя 7 попыток. Я загадал число от 1 до 100.")

while attempts < max_attempts:
    guess = int(input("Твой вариант: "))
    attempts += 1
    left = max_attempts - attempts    # сколько попыток осталось

    if guess < secret:
        print(f"Больше! Осталось попыток: {left}")
    elif guess > secret:
        print(f"Меньше! Осталось попыток: {left}")
    else:
        print(f"Верно! Ты угадал число {secret} за {attempts} попыток.")
        won = True
        break                     # угадал раньше лимита — выходим

# сюда попадаем и после break, и когда попытки кончились
if not won:
    print(f"Попытки кончились. Я загадал {secret}. Компьютер победил!")
