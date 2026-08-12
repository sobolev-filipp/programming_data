# ===== 🏆 УМНЫЙ ПЫЛЕСОС — БОЛЬШОЙ ПРАКТИКУМ (16 заданий) =====
# Комната 10x10. Собери ВЕСЬ мусор, написав алгоритм из команд.
# Здесь пригодятся ВСЕ циклы: for (когда знаешь, сколько шагов),
# while (когда едешь «до стены»), вложенные (когда заливаешь область).
#
# КОМАНДЫ движения (пиши их в блоке «ТВОЙ АЛГОРИТМ»):
#   right()  left()  up()  down()   — переехать на клетку
#   clean()                          — убрать мусор в текущей клетке
#
# СЕНСОРЫ (переменные-флаги, True/False — читай их в условии while):
#   wall_right — справа стена (дальше вправо нельзя)
#   wall_left  — слева стена
#   wall_up    — сверху стена
#   wall_down  — снизу стена
#   wall       — рядом ЛЮБАЯ стена
#   x, y       — текущие координаты пылесоса (0..9)
#
# НОМЕР ЗАДАНИЯ — переменная TASK ниже (1..16). Описания заданий — в конце файла.

import turtle, time

# =========================================================
# ================  ДВИЖОК — НЕ ТРОГАЙ  ===================
# =========================================================
_N = 10
_CELL = 40
_ORIGIN = -180
_STEP_DELAY = 0.12

def _sx(v): return _ORIGIN + v * _CELL
def _sy(v): return _ORIGIN + v * _CELL

_screen = turtle.Screen()
_screen.setup(560, 560)
_screen.title("Умный пылесос — практикум")
turtle.tracer(0, 0)

_bg = turtle.Turtle(visible=False)
_bg.speed(0)
_bg.pensize(1)
_bg.pencolor("#d0d0d0")
for _i in range(_N + 1):
    _bg.penup(); _bg.goto(-200, -200 + _i * _CELL); _bg.pendown(); _bg.goto(200, -200 + _i * _CELL)
    _bg.penup(); _bg.goto(-200 + _i * _CELL, -200); _bg.pendown(); _bg.goto(-200 + _i * _CELL, 200)
_bg.pensize(4)
_bg.pencolor("#000096")
_bg.penup(); _bg.goto(-200, -200); _bg.pendown(); _bg.setheading(0)
for _i in range(4):
    _bg.forward(_N * _CELL); _bg.left(90)
_bg.penup()

_trash = set()
_x, _y = 0, 0
_crash = False
x = y = 0
wall_right = wall_left = wall_up = wall_down = wall = False

def _place(cells):
    for (cx, cy) in cells:
        _trash.add((cx, cy))
        _bg.goto(_sx(cx), _sy(cy))
        _bg.dot(18, "#b0b0b0")

def make_task(n):
    global _x, _y
    if n == 1:                                   # ряд вправо (for)
        _x, _y = 0, 5; _place([(i, 5) for i in range(1, 10)])
    elif n == 2:                                 # столбец вверх (for)
        _x, _y = 5, 0; _place([(5, i) for i in range(1, 10)])
    elif n == 3:                                 # диагональ (for)
        _x, _y = 0, 0; _place([(i, i) for i in range(1, 10)])
    elif n == 4:                                 # обратная диагональ (for)
        _x, _y = 0, 9; _place([(i, 9 - i) for i in range(1, 10)])
    elif n == 5:                                 # ряд ДО СТЕНЫ (while)
        _x, _y = 3, 5; _place([(i, 5) for i in range(4, 10)])
    elif n == 6:                                 # столбец ДО СТЕНЫ вверх (while)
        _x, _y = 5, 4; _place([(5, i) for i in range(5, 10)])
    elif n == 7:                                 # доехать до стены, убрать угол (while)
        _x, _y = 2, 5; _place([(9, 5)])
    elif n == 8:                                 # весь ряд от стены до стены (2x while)
        _x, _y = 5, 5; _place([(i, 5) for i in range(0, 10)])
    elif n == 9:                                 # периметр комнаты (4x while)
        _x, _y = 0, 0
        _place([(i, j) for i in range(10) for j in range(10) if i in (0, 9) or j in (0, 9)])
    elif n == 10:                                # два ряда змейкой (while)
        _x, _y = 0, 7
        _place([(i, 7) for i in range(10)] + [(i, 8) for i in range(10)])
    elif n == 11:                                # вся комната змейкой (for + while + флаг)
        _x, _y = 0, 0
        _place([(i, j) for i in range(10) for j in range(10)])
    elif n == 12:                                # шахматка (змейка + continue, читаем x,y)
        _x, _y = 0, 0
        _place([(i, j) for i in range(10) for j in range(10) if (i + j) % 2 == 0])
    elif n == 13:                                # блок 5x5 змейкой
        _x, _y = 2, 2
        _place([(i, j) for i in range(2, 7) for j in range(2, 7)])
    elif n == 14:                                # чётные столбцы целиком
        _x, _y = 0, 0
        _place([(i, j) for i in range(0, 10, 2) for j in range(10)])
    elif n == 15:                                # буква L: левый столбец + нижний ряд
        _x, _y = 0, 9
        _place([(0, j) for j in range(10)] + [(i, 0) for i in range(1, 10)])
    elif n == 16:                                # ромб вокруг центра (змейка + continue)
        _x, _y = 0, 0
        _place([(i, j) for i in range(10) for j in range(10) if abs(i - 4) + abs(j - 4) <= 3])

_v = turtle.Turtle()
_v.shape("circle")
_v.color("purple", "orange")
_v.penup()
_v.speed(0)

def _update():
    global x, y, wall_right, wall_left, wall_up, wall_down, wall
    x, y = _x, _y
    wall_right = _x == _N - 1
    wall_left = _x == 0
    wall_up = _y == _N - 1
    wall_down = _y == 0
    wall = wall_right or wall_left or wall_up or wall_down

def _show():
    turtle.update()
    time.sleep(_STEP_DELAY)

def _step(dx, dy):
    global _x, _y, _crash
    if _crash:
        return
    nx, ny = _x + dx, _y + dy
    if nx < 0 or nx > _N - 1 or ny < 0 or ny > _N - 1:
        _crash = True
        _v.color("red", "red")
        _show()
        return
    _x, _y = nx, ny
    _v.goto(_sx(_x), _sy(_y))
    _update()
    _show()

def right(): _step(1, 0)
def left():  _step(-1, 0)
def up():    _step(0, 1)
def down():  _step(0, -1)

def clean():
    if _crash:
        return
    _trash.discard((_x, _y))
    _v.dot(20, "#1e63ff")
    _show()

def _finish():
    turtle.update()
    if _crash:
        _screen.title("Пылесос врезался в стену! Проверь алгоритм.")
        print("Пылесос выехал за стену. Двигайся, пока НЕ wall (сенсор).")
    elif not _trash:
        _screen.title("Умный пылесос — ЧИСТО! Молодец!")
        print("Готово! Весь мусор собран.")
    else:
        _screen.title(f"Осталось мусора: {len(_trash)} — доработай алгоритм")
        print(f"Осталось мусора: {len(_trash)}. Проверь маршрут.")

# =========================================================
# ==================  НАСТРОЙКА ИГРЫ  =====================
# =========================================================

TASK = 1               # <-- НОМЕР ЗАДАНИЯ (меняй: 1..16)

make_task(TASK)
_v.goto(_sx(_x), _sy(_y))
_update()
turtle.update()

# =========================================================
# ==================  ТВОЙ АЛГОРИТМ  ======================
# =========================================================
# Пример для ЗАДАНИЯ 1 (ряд мусора справа, длина известна — берём for):
# for i in range(9):
#     right()
#     clean()
#
# Пример «до стены» (ЗАДАНИЕ 5, длину не знаем — берём while + сенсор):
# while not wall_right:
#     right()
#     clean()


# =========================================================
# ==================  КОНЕЦ — НЕ ТРОГАЙ  ==================
# =========================================================
_finish()
turtle.done()
