# ===== ТАБЛО РЕЗУЛЬТАТОВ =====
# Новое: enumerate (номер + значение) и zip (два списка параллельно).
# Плюс накопители по списку: sum() и max().

names = ["Аня", "Боря", "Вика", "Гриша"]
scores = [15, 22, 8, 22]

print("=== РЕЗУЛЬТАТЫ ===")
# zip идёт по ДВУМ спискам сразу: имя и его очки
for name, score in zip(names, scores):
    print(f"{name}: {score} очков")

print("--- список с местами ---")
# enumerate добавляет НОМЕР; start=1 — считать с 1, а не с 0
for place, name in enumerate(names, start=1):
    print(f"{place}. {name}")

# накопители по списку — встроенные функции
print("Всего очков:", sum(scores))
print("Лучший результат:", max(scores))
print("Худший результат:", min(scores))
print("Игроков:", len(names))

# 🎓 объединяем: номер + имя + очки за один проход
print("--- итоговая таблица ---")
for place, (name, score) in enumerate(zip(names, scores), start=1):
    print(f"{place}. {name} — {score}")
