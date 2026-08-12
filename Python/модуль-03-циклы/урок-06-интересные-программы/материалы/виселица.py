# ===== ВИСЕЛИЦА (угадай слово по буквам) =====
# Компьютер загадывает слово, ты открываешь его по одной букве.
# Собрано из всего модуля: while + break, for (маска), if/in, список, счётчик.

import random

words = ["питон", "кодер", "цикл", "робот", "космос", "черепаха"]
secret = random.choice(words)

guessed = []            # список угаданных букв
mistakes = 0            # счётчик ошибок
max_mistakes = 6

print("=" * 30)
print("ВИСЕЛИЦА: угадай слово")
print(f"В слове {len(secret)} букв. Ошибок можно: {max_mistakes}")
print("=" * 30)

while True:
    # 1) собираем маску слова: угаданные буквы открыты, остальные — "_"
    mask = ""
    for letter in secret:
        if letter in guessed:
            mask += letter
        else:
            mask += "_"
    print("Слово:", mask)

    # 2) условия конца игры
    if "_" not in mask:
        print("Победа! Ты открыл всё слово!")
        break
    if mistakes >= max_mistakes:
        print(f"Увы, проигрыш. Слово было: {secret}")
        break

    # 3) ход игрока
    guess = input("Назови букву: ").lower().strip()
    if guess in guessed:
        print("Эту букву уже называли.")
    elif guess in secret:
        guessed.append(guess)
        print("Есть такая буква!")
    else:
        mistakes += 1
        print(f"Нет такой. Ошибок: {mistakes}/{max_mistakes}")
