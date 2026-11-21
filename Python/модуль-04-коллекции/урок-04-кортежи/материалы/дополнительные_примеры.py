"""Дополнительные примеры к уроку 4: запускайте в PyCharm / VS Code."""

def example(title, value):
    print("\n" + title)
    print(value)

first = (7, 12)
second = 7, 12
third = (7)
fourth = (7,)
empty = ()
for value in (first, second, third, fourth, empty):
    print(value, type(value).__name__)

scores = (10, 20, 30, 20, 50)
example("Срез", scores[1:4])
example("Количество двадцаток", scores.count(20))

player = ("Лена", 12, 150)
name, age, points = player
print(f"{name}: {age} лет, {points} очков")

checkpoints = [(2, 4), (5, 7), (8, 3)]
for x, y in checkpoints:
    print(f"Точка: x={x}, y={y}")

products = [("яблоко", 50), ("груша", 70), ("банан", 60)]
for name, price in products:
    if price > 55:
        print(f"{name}: {price}")

route = ((0, 0), (2, 1), (4, 1), (4, 3))
for step, (x, y) in enumerate(route, start=1):
    print(f"Шаг {step}: перейти в ({x}, {y})")

results = (("Маша", 18), ("Дима", 25), ("Оля", 21))
leader, best_score = "", -1
for name, score in results:
    if score > best_score:
        leader, best_score = name, score
print(f"Победитель: {leader}, очки: {best_score}")

pixels = ((255, 0, 0), (0, 255, 0), (0, 0, 255))
for red, green, blue in pixels:
    print(f"R={red}, G={green}, B={blue}")
