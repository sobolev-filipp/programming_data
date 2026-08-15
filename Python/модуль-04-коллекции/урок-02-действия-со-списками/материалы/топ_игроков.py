# Топ игроков: считаем итоги по списку очков и строим рейтинг.
# Два параллельных списка: имя игрока и его счёт (одинаковой длины).

players = ["Аня", "Борис", "Вика", "Глеб", "Даша"]
scores = [82, 95, 70, 95, 60]

print("Игроков:", len(players))
print("-" * 40)

# 1. ИТОГИ по списку очков — встроенные функции
print("Всего очков:", sum(scores))
print("Лучший счёт:", max(scores))
print("Худший счёт:", min(scores))
average = sum(scores) / len(scores)
print("Средний счёт:", round(average, 1))
print("-" * 40)

# 2. ПОБЕДИТЕЛЬ — имя игрока с максимальным счётом
best = max(scores)
winner = players[scores.index(best)]   # index(best) -> позиция -> то же имя
print("Победитель:", winner, "со счётом", best)
print("-" * 40)

# 3. РЕЙТИНГ — очки по убыванию (sorted не портит оригинал)
ranking = sorted(scores, reverse=True)
print("Очки по убыванию:", ranking)
print("Топ-3:", ranking[0], ranking[1], ranking[2])
print("-" * 40)

# 4. СОРТИРОВКА ПО КЛЮЧУ — имена по длине и по алфавиту
print("Имена по длине:", sorted(players, key=len))
print("Имена по алфавиту:", sorted(players, key=str.lower))
print("-" * 40)

# 5. ФИЛЬТР — кто набрал не меньше 80 (собираем новый список циклом)
strong = []
for score in scores:
    if score >= 80:
        strong.append(score)
print("Счёт 80 и выше:", strong, "-> таких игроков:", len(strong))
