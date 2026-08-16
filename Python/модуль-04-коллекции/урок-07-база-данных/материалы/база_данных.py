# Мини-база данных персонажей: консольное приложение с меню.
# Собирает весь Модуль 4: список словарей, перебор, фильтр, поиск, счётчик, сортировка.

heroes = [
    {"имя": "Рыцарь", "класс": "воин", "hp": 100, "уровень": 5},
    {"имя": "Маг",    "класс": "маг",  "hp": 70,  "уровень": 7},
    {"имя": "Лучник", "класс": "воин", "hp": 80,  "уровень": 4},
]

while True:
    print()
    print("=== БАЗА ГЕРОЕВ ===")
    print("[1] показать всех  [2] найти по имени  [3] фильтр по классу")
    print("[4] добавить героя  [5] чемпион по hp   [6] выход")
    choice = input("Выбор: ")

    if choice == "1":
        for i, hero in enumerate(heroes, start=1):
            print(f"  {i}. {hero['имя']} ({hero['класс']}) — hp {hero['hp']}, ур. {hero['уровень']}")

    elif choice == "2":
        name = input("Имя: ")
        найден = None
        for hero in heroes:
            if hero["имя"] == name:
                найден = hero
        if найден is not None:
            print("  Найден:", найден)
        else:
            print("  Такого героя нет")

    elif choice == "3":
        klass = input("Класс (воин/маг/плут): ")
        нашлись = False
        for hero in heroes:
            if hero["класс"] == klass:
                print("  ", hero["имя"])
                нашлись = True
        if not нашлись:
            print("  Никого такого класса нет")

    elif choice == "4":
        name = input("Имя: ")
        klass = input("Класс: ")
        hp = int(input("hp: "))
        heroes.append({"имя": name, "класс": klass, "hp": hp, "уровень": 1})
        print("  Добавлен:", name)

    elif choice == "5":
        чемпион = heroes[0]
        for hero in heroes:
            if hero["hp"] > чемпион["hp"]:
                чемпион = hero
        print(f"  Больше всех hp: {чемпион['имя']} ({чемпион['hp']})")

    elif choice == "6":
        print("Выход.")
        break

    else:
        print("  Нет такой команды")
