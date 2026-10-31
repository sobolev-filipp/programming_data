# ===== 🏆 УМНЫЙ ПЫЛЕСОС — БОЛЬШОЙ ПРАКТИКУМ (16 заданий) =====
# Комната 10x10. Собери ВЕСЬ мусор, написав алгоритм из команд.
#
# ВАЖНО: комната КАЖДЫЙ РАЗ РАЗНАЯ! Пылесос стартует со случайного места,
# мусор тянется до стены на случайное расстояние, а кое-где стоят
# ВНУТРЕННИЕ СТЕНЫ (тёмные клетки). Поэтому «посчитать шаги заранее»
# (for range(9)) уже НЕ выйдет — нужно ехать ДО СТЕНЫ и читать сенсоры.
# Нажми запуск несколько раз — увидишь, что комната меняется, а твой
# правильный алгоритм собирает мусор при любом раскладе.
#
# КОМАНДЫ движения (пиши их в блоке «ТВОЙ АЛГОРИТМ»):
#   right()  left()  up()  down()   — переехать на клетку
#   clean()                          — убрать мусор в текущей клетке
#
# СЕНСОРЫ (переменные-флаги, True/False — читай их в условии while):
#   wall_right — справа стена (дальше вправо нельзя: край ИЛИ тёмная стена)
#   wall_left  — слева стена
#   wall_up    — сверху стена
#   wall_down  — снизу стена
#   wall       — рядом ЛЮБАЯ стена
#   x, y       — текущие координаты пылесоса (0..9)
#
# НОМЕР ЗАДАНИЯ — переменная TASK ниже (1..16). Описания заданий — в конце файла.

import turtle, time, random

# =========================================================
# ================  ДВИЖОК — НЕ ТРОГАЙ  ===================
# =========================================================
_N = 10
_CELL = 40
_ORIGIN = -180
_STEP_DELAY = 0.12
WALL = "#4b5563"       # цвет внутренней стены

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
_walls = set()
_x, _y = 0, 0
_crash = False
x = y = 0
wall_right = wall_left = wall_up = wall_down = wall = False

def _blocked(cx, cy):
    # клетка непроходима: край комнаты ИЛИ внутренняя стена
    return cx < 0 or cx > _N - 1 or cy < 0 or cy > _N - 1 or (cx, cy) in _walls

def _place(cells):
    for (cx, cy) in cells:
        _trash.add((cx, cy))
        _bg.goto(_sx(cx), _sy(cy))
        _bg.dot(18, "#b0b0b0")

def _square(cx, cy, color=WALL, size=34):
    _walls.add((cx, cy))
    _bg.penup(); _bg.goto(_sx(cx) - size / 2, _sy(cy) - size / 2)
    _bg.setheading(0); _bg.pendown(); _bg.fillcolor(color); _bg.begin_fill()
    for _ in range(4):
        _bg.forward(size); _bg.left(90)
    _bg.end_fill(); _bg.penup()

def make_task(n):
    global _x, _y
    rr = random.randint
    if n == 1:                                   # ряд ВПРАВО до стены (while)
        _y = rr(1, 8); _x = rr(0, 3)
        end = rr(_x + 3, 9)
        if end < 9: _square(end + 1, _y)
        _place([(i, _y) for i in range(_x + 1, end + 1)])
    elif n == 2:                                 # столбец ВВЕРХ до стены (while)
        _x = rr(1, 8); _y = rr(0, 3)
        end = rr(_y + 3, 9)
        if end < 9: _square(_x, end + 1)
        _place([(_x, j) for j in range(_y + 1, end + 1)])
    elif n == 3:                                 # ряд ВЛЕВО до стены (while)
        _y = rr(1, 8); _x = rr(6, 9)
        end = rr(0, _x - 3)
        if end > 0: _square(end - 1, _y)
        _place([(i, _y) for i in range(end, _x)])
    elif n == 4:                                 # столбец ВНИЗ до стены (while)
        _x = rr(1, 8); _y = rr(6, 9)
        end = rr(0, _y - 3)
        if end > 0: _square(_x, end - 1)
        _place([(_x, j) for j in range(end, _y)])
    elif n == 5:                                 # доехать до стены, убрать соринку в углу (while)
        _y = rr(1, 8); _x = rr(0, 3)
        end = rr(_x + 3, 9)
        if end < 9: _square(end + 1, _y)
        _place([(end, _y)])
    elif n == 6:                                 # весь ряд от стены до стены (2x while)
        _y = rr(1, 8); _x = rr(2, 7)
        _place([(i, _y) for i in range(0, 10)])
    elif n == 7:                                 # диагональ вправо-вверх до стены (while)
        _x = rr(0, 2); _y = rr(0, 2)
        k = 9 - max(_x, _y)
        _place([(_x + i, _y + i) for i in range(1, k + 1)])
    elif n == 8:                                 # буква Г: вправо до стены + вверх до стены (2x while)
        _x = rr(0, 2); _y = rr(0, 2)
        _place([(i, _y) for i in range(_x + 1, 10)] + [(9, j) for j in range(_y + 1, 10)])
    elif n == 9:                                 # периметр комнаты (4x while)
        _x, _y = 0, 0
        _place([(i, j) for i in range(10) for j in range(10) if i in (0, 9) or j in (0, 9)])
    elif n == 10:                                # два ряда змейкой (while, случайная высота)
        _x = 0; _y = rr(0, 7)
        _place([(i, _y) for i in range(10)] + [(i, _y + 1) for i in range(10)])
    elif n == 11:                                # вся комната змейкой (for + while + флаг)
        _x, _y = 0, 0
        _place([(i, j) for i in range(10) for j in range(10)])
    elif n == 12:                                # буква L: левый столбец + нижний ряд (2x while)
        _x, _y = 0, 9
        _place([(0, j) for j in range(10)] + [(i, 0) for i in range(1, 10)])
    elif n == 13:                                # комната с ПЕРЕГОРОДКОЙ: собрать до стены (while)
        _x = 0; _y = rr(1, 8)
        wcol = rr(3, 7)
        for j in range(10):
            _square(wcol, j)                     # сплошная вертикальная стена
        _place([(i, _y) for i in range(1, wcol)])
    elif n == 14:                                # шахматка (змейка + continue, читаем x,y)
        _x, _y = 0, 0
        _place([(i, j) for i in range(10) for j in range(10) if (i + j) % 2 == 0])
    elif n == 15:                                # чётные столбцы целиком (змейка + условие по x)
        _x, _y = 0, 0
        _place([(i, j) for i in range(0, 10, 2) for j in range(10)])
    elif n == 16:                                # ромб вокруг центра (змейка + condition)
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
    wall_right = _blocked(_x + 1, _y)
    wall_left = _blocked(_x - 1, _y)
    wall_up = _blocked(_x, _y + 1)
    wall_down = _blocked(_x, _y - 1)
    wall = wall_right or wall_left or wall_up or wall_down

def _show():
    turtle.update()
    time.sleep(_STEP_DELAY)

def _step(dx, dy):
    global _x, _y, _crash
    if _crash:
        return
    nx, ny = _x + dx, _y + dy
    if _blocked(nx, ny):
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
# Комната каждый раз РАЗНАЯ, поэтому главный приём — ехать «до стены»
# и смотреть на сенсор, а не считать шаги заранее.
#
# Пример «ряд вправо до стены» (ЗАДАНИЕ 1 — длину НЕ знаем, берём while):
# while not wall_right:
#     right()
#     clean()
#
# Пример «сначала доехать, потом убрать» (ЗАДАНИЕ 5):
# while not wall_right:
#     right()
# clean()


# =========================================================
# ==================  КОНЕЦ — НЕ ТРОГАЙ  ==================
# =========================================================
_finish()
turtle.done()

# =========================================================
# ======  ОПИСАНИЕ ЗАДАНИЙ (подробно — в практике)  ======
# =========================================================
# --- 🟢 едем ДО СТЕНЫ (while + сенсор, шаги НЕ считаем) ---
#  1. Ряд вправо до стены.         Едь вправо и убирай, пока справа не стена.
#  2. Столбец вверх до стены.      Едь вверх и убирай, пока сверху не стена.
#  3. Ряд влево до стены.          Едь влево и убирай, пока слева не стена.
#  4. Столбец вниз до стены.       Едь вниз и убирай, пока снизу не стена.
#  5. Доехать и убрать угол.       Доедь до правой стены, там одна соринка.
#  6. Ряд от стены до стены.       Пылесос в середине ряда — собери всю строку.
#  7. Диагональ до стены.          Едь вправо-вверх, пока не упрёшься в край.
#  8. Буква Г.                     Вправо до стены, затем вверх до стены.
# --- 🟡 обход области (while-стороны, змейка) ---
#  9. Периметр комнаты.            Обойди рамку по четырём сторонам.
# 10. Два ряда змейкой.            Две строки во всю ширину — туда и обратно.
# 11. Вся комната змейкой.         Все 100 клеток, строка за строкой.
# 12. Буква L.                     Левый столбец + нижний ряд.
# --- 🔴 со звёздочкой ---
# 13. Комната с перегородкой.      Внутренняя стена — собери мусор ДО неё.
# 14. Шахматка.                    Убери клетки, где (x + y) чётное.
# 15. Чётные столбцы.              Убери столбцы 0, 2, 4, 6, 8.
# 16. Ромб.                        Клетки, где abs(x-4)+abs(y-4) <= 3.
