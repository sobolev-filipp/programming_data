# Практикум «Рисуем по клеткам». Python 3, стандартный turtle.
# Запускай файл целиком в PyCharm или VS Code.
# Меняй TASK и пиши команды только в блоке «ТВОЙ АЛГОРИТМ».
# column((1, 3)) — точки на высотах 1 и 3, затем переход вправо.
# column((5,)) — одна точка; column(()) или column((0,)) — пропуск.
import turtle
import time

TASK = 1  # номер задания от 1 до 13

# ---------- ТЕХНИЧЕСКАЯ ЧАСТЬ ----------
COLS, ROWS = 18, 15
STEP = 32
X0, Y0 = -272, -224
TARGETS = [[(5, 6, 7)], [(3, 5), (), (4,)], [(5,), (5,), (5,), (5,), (5,), (5,), (5,), (5,), (5,), (5,)], [(5, 7), (5, 7), (5, 7), (5, 7), (5, 7), (5, 7), (5, 7), (5, 7), (5, 7), (5, 7)], [(1,), (2,), (3,), (4,), (5,), (6,), (7,), (8,), (9,), (10,)], [(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7), (1, 8), (1, 9), (1, 10)], [(1, 10), (1, 9), (1, 8), (1, 7), (1, 6), (1, 5), (1, 4), (1, 3), (1, 2), (1, 1)], [(1, 10), (2, 9), (3, 8), (4, 7), (5, 6), (6, 5), (7, 4), (8, 3), (9, 2), (10, 1)], [(5,), (6, 4), (7, 3), (8, 2), (9, 1)], [(5,), (6, 5, 4), (7, 5, 3), (8, 5, 2), (9, 5, 1), (5,), (5,), (5,), (5,), (5,), (5,)], [(4,), (5,), (4,), (5,), (4,), (5,), (4,), (5,), (4,), (5,)], [(5,), (6,), (7,), (6,), (5,), (4,), (3,), (4,), (5,), (6,), (7,), (6,), (5,), (4,), (3,), (4,), (5,)], [(7, 7), (8, 6), (9, 5), (10, 7, 4), (11, 3), (12, 2), (13, 1), (12, 2), (11, 3), (10, 4), (9, 5), (8, 6), (7, 7), (6, 8), (5, 9)]]
if not 1 <= TASK <= len(TARGETS):
    raise ValueError("TASK должен быть от 1 до 13")

screen = turtle.Screen()
screen.setup(760, 650)
screen.title("Рисуем по клеткам — задание " + str(TASK))
screen.bgcolor("#f8fafc")
screen.tracer(0, 0)
pen = turtle.Turtle(visible=False)
pen.speed(0)
pen.penup()


def line(x1, y1, x2, y2):
    pen.goto(x1, y1)
    pen.pendown()
    pen.goto(x2, y2)
    pen.penup()


pen.pencolor("#cbd5e1")
for i in range(COLS + 1):
    x = X0 + (i - 0.5) * STEP
    line(x, Y0 - STEP / 2, x, Y0 + (ROWS - 0.5) * STEP)
for i in range(ROWS + 1):
    y = Y0 + (i - 0.5) * STEP
    line(X0 - STEP / 2, y, X0 + (COLS - 0.5) * STEP, y)
pen.pencolor("#172554")
for i in range(COLS):
    pen.goto(X0 + i * STEP, Y0 - 38)
    pen.write(i, align="center", font=("Arial", 11, "normal"))
for y in range(1, ROWS + 1):
    pen.goto(X0 - 34, Y0 + (y - 1) * STEP - 7)
    pen.write(y, align="center", font=("Arial", 11, "normal"))
pen.goto(0, 270)
pen.write("Задание " + str(TASK), align="center", font=("Arial", 18, "bold"))
screen.update()

current = 0
painted = set()


def column(heights):
    global current
    if not isinstance(heights, tuple):
        raise TypeError("column принимает кортеж: например (5,)")
    if current >= COLS:
        raise ValueError("На поле только 18 столбцов")
    for y in heights:
        if type(y) is not int or not 0 <= y <= ROWS:
            raise ValueError("Высота должна быть целым числом от 0 до 15")
    for y in heights:
        if y == 0:
            continue
        pen.goto(X0 + current * STEP, Y0 + (y - 1) * STEP)
        pen.dot(23, "#2563eb")
        painted.add((current, y))
    current += 1
    screen.update()
    time.sleep(0.10)


# ---------- ТВОЙ АЛГОРИТМ ----------
# Удали знак # перед примером, чтобы проверить первую задачу.
# column((5, 6, 7))

# ---------- ПРОВЕРКА (не изменяй) ----------
expected = {(x, y) for x, col in enumerate(TARGETS[TASK - 1]) for y in col if y}
missing = len(expected - painted)
extra = len(painted - expected)
message = "Готово! Рисунок совпал." if not missing and not extra else f"Не хватает: {missing}. Лишних: {extra}."
pen.goto(0, -302)
pen.pencolor("#15803d" if not missing and not extra else "#b45309")
pen.write(message, align="center", font=("Arial", 14, "bold"))
screen.update()
turtle.done()
