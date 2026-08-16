# Инвентарь героя: предмет -> количество.
# Значение в словаре — число. Удобно СЧИТАТЬ: сколько раз встретился предмет.

# Что герой подобрал за поход (обычный список — с повторами)
loot = ["монета", "зелье", "монета", "меч", "монета", "зелье", "монета"]

# Складываем в инвентарь: считаем, сколько каждого предмета.
# .get(item, 0) вернёт текущее число или 0, если предмета ещё не было.
inventory = {}
for item in loot:
    inventory[item] = inventory.get(item, 0) + 1

print("=== ИНВЕНТАРЬ ===")
print("Собрано предметов (штук всего):", len(loot))
print("Разных видов:", len(inventory))
print()

# Показать инвентарь (перебор по ключам)
print("Содержимое:")
for item in inventory:
    print(f"  {item}: {inventory[item]} шт.")
print()

# Сколько всего предметов — сумма всех значений
total = sum(inventory.values())
print("Всего вещей в сумке:", total)
print()

# Чего больше всего? Идём по ключам и запоминаем «рекордсмена».
best = ""
best_count = 0
for item in inventory:
    if inventory[item] > best_count:
        best_count = inventory[item]
        best = item
print(f"Больше всего: {best} ({best_count} шт.)")
print()

# Потратили 2 монеты, нашли новый щит
inventory["монета"] -= 2          # значение — число, можно вычитать
inventory["щит"] = 1              # нового ключа не было -> добавился
print("Потратили 2 монеты, нашли щит.")
print("Монет осталось:", inventory["монета"])
print("Есть щит?", "щит" in inventory)
print("Итог:", inventory)
