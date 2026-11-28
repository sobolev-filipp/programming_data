from cities import CITIES
import random


def normalize(text):
    return text.strip().lower().replace("ё", "е")


def last_letter(city):
    city = normalize(city)
    for letter in city[::-1]:
        if letter not in "ьъы":
            return letter
    return ""


print("Игра «Города»")
for country, city_list in CITIES.items():
    print(f"{country}: {len(city_list)} городов")

while True:
    country = input("Выбери страну: ").strip().capitalize()
    if country == "Сша":
        country = "США"
    if country in CITIES:
        break
    print("Такой страны нет в базе. Попробуй ещё раз.")

available = {}
for city in CITIES[country]:
    available[normalize(city)] = city

required = ""
score = 0
while True:
    if required:
        print(f"Твой город должен начинаться на «{required.upper()}»")
    answer = normalize(input("Твой город (или стоп): "))
    if answer == "стоп":
        break
    if answer not in available:
        print("Город уже называли или его нет в нашей базе.")
        continue
    if required and not answer.startswith(required):
        print("Неверная первая буква.")
        continue

    player_city = available.pop(answer)
    score += 1
    required = last_letter(player_city)
    candidates = []
    for key, name in available.items():
        if key.startswith(required):
            candidates.append(key)
    if not candidates:
        print("Компьютер не знает подходящего города. Ты победил!")
        break

    computer_key = random.choice(candidates)
    computer_city = available.pop(computer_key)
    print("Компьютер:", computer_city)
    required = last_letter(computer_city)

    can_play = False
    for key in available:
        if key.startswith(required):
            can_play = True
            break
    if not can_play:
        print("В базе больше нет подходящих городов. Компьютер победил.")
        break

print("Твой счёт:", score)
