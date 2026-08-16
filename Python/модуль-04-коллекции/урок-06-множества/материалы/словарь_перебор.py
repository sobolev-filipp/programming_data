# Красивый перебор словаря: for ключ, значение in словарь.items()
# В Уроке 5 ходили по ключам; теперь берём сразу ПАРУ (ключ, значение).

prices = {"кофе": 120, "чай": 80, "сок": 150}

# 1. Перебор ПАР через .items() + распаковка (как кортеж из Урока 4)
print("Меню:")
for dish, price in prices.items():     # dish = ключ, price = значение
    print(f"  {dish}: {price} руб")
print("-" * 40)

# 2. Отдельно ключи и отдельно значения
print("Только блюда:", list(prices.keys()))
print("Только цены:", list(prices.values()))
print("Сумма цен:", sum(prices.values()))
print("-" * 40)

# 3. Найти пару-рекордсмена (самое дорогое) через items()
top_dish = ""
top_price = 0
for dish, price in prices.items():
    if price > top_price:
        top_price = price
        top_dish = dish
print(f"Дороже всего: {top_dish} ({top_price} руб)")
print("-" * 40)

# 4. Словарь-счётчик + красивый вывод парами
votes = ["кот", "пёс", "кот", "кот", "пёс"]
counts = {}
for animal in votes:
    counts[animal] = counts.get(animal, 0) + 1
print("Результаты голосования:")
for animal, n in counts.items():       # сразу пара «кто : сколько»
    print(f"  {animal} — {n} голос(ов)")
