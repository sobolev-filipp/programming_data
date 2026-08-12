# ===== 🐢 УМНЫЙ ПЫЛЕСОС: УБРАТЬ ОБЛАСТЬ (вложенные циклы) =====
# Мусор заполняет целую ОБЛАСТЬ (прямоугольник, треугольник, шахматку).
# Убрать её удобно ВЛОЖЕННЫМ циклом: внешний — строки, внутренний — столбцы.
#
# КОМАНДЫ (пиши в блоке «ТВОЙ АЛГОРИТМ»):
#   go_to(x, y) — переместить пылесос в клетку (x, y), координаты 0..9
#   clean()     — убрать мусор в текущей клетке
#
# ОБЛАСТИ ЗАДАНИЙ (что и где закрашено):
#   TASK 1: прямоугольник cols 2..6, rows 2..6 (блок 5x5)
#   TASK 2: прямоугольник cols 1..8, rows 3..5 (широкий)
#   TASK 3: вся комната cols 0..9, rows 0..9
#   TASK 4: треугольник — в строке row закрашены cols 0..row
#   TASK 5: шахматка 10x10 — клетки, где (row+col) чётное
#   TASK 6: рамка прямоугольника cols 1..8, rows 1..8 (только край)
#   TASK 7: два блока — cols 0..3/rows 0..3 и cols 6..9/rows 6..9
#   TASK 8: 🎓 ромб вокруг центра (4,4)

import turtle, time

# =========================================================
# ================  ДВИЖОК — НЕ ТРОГАЙ  ===================
# =========================================================
_N = 10
_CELL = 40
_ORIGIN = -180
_STEP_DELAY = 0.08          # пауза между шагами (клеток много — делаем быстрее)

def _sx(x): return _ORIGIN + x * _CELL
def _sy(y): return _ORIGIN + y * _CELL

_screen = turtle.Screen()
_screen.setup(560, 560)
_screen.title("Умный пылесос: убрать область")
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

def _place(cells):
    for (cx, cy) in cells:
        _trash.add((cx, cy))
        _bg.goto(_sx(cx), _sy(cy))
        _bg.dot(18, "#b0b0b0")

def make_task(n):
    if n == 1:
        _place([(c, r) for r in range(2, 7) for c in range(2, 7)])
    elif n == 2:
        _place([(c, r) for r in range(3, 6) for c in range(1, 9)])
    elif n == 3:
        _place([(c, r) for r in range(10) for c in range(10)])
    elif n == 4:
        _place([(c, r) for r in range(9) for c in range(r + 1)])
    elif n == 5:
        _place([(c, r) for r in range(10) for c in range(10) if (r + c) % 2 == 0])
    elif n == 6:
        _place([(c, r) for r in range(1, 9) for c in range(1, 9)
                if c == 1 or c == 8 or r == 1 or r == 8])
    elif n == 7:
        _place([(c, r) for r in range(4) for c in range(4)])
        _place([(c, r) for r in range(6, 10) for c in range(6, 10)])
    elif n == 8:
        _place([(c, r) for r in range(10) for c in range(10) if abs(c - 4) + abs(r - 4) <= 3])

_v = turtle.Turtle()
_v.shape("circle")
_v.color("purple", "orange")
_v.penup()
_v.speed(0)

def _show():
    turtle.update()
    time.sleep(_STEP_DELAY)

def go_to(x, y):
    global _x, _y, _crash
    if _crash:
        return
    if x < 0 or x > _N - 1 or y < 0 or y > _N - 1:
        _crash = True
        _v.color("red", "red")
        _show()
        return
    _x, _y = x, y
    _v.goto(_sx(x), _sy(y))
    _show()

def clean():
    if _crash:
        return
    _trash.discard((_x, _y))
    _v.dot(20, "#1e63ff")
    _show()

def _finish():
    turtle.update()
    if _crash:
        _screen.title("Пылесос ушёл за стену! Координаты должны быть 0..9.")
        print("Ошибка: координата за пределами комнаты (нужно 0..9).")
    elif not _trash:
        _screen.title("Умный пылесос — ЧИСТО! Молодец!")
        print("Готово! Вся область убрана.")
    else:
        _screen.title(f"Осталось мусора: {len(_trash)} — доработай алгоритм")
        print(f"Осталось мусора: {len(_trash)}. Проверь границы циклов.")

# =========================================================
# ==================  НАСТРОЙКА ИГРЫ  =====================
# =========================================================

TASK = 1               # <-- НОМЕР ЗАДАНИЯ (меняй: 1..8)

make_task(TASK)
turtle.update()

# =========================================================
# ==================  ТВОЙ АЛГОРИТМ  ======================
# =========================================================
# ПОДСКАЗКА: область убирают ВЛОЖЕННЫМ циклом.
# Внешний цикл — строки (rows), внутренний — столбцы (cols).
# Раскомментируй и допиши под нужную область (см. комментарий вверху):
#
# for row in range(2, 7):          # строки области
#     for col in range(2, 7):      # столбцы области
#         go_to(col, row)
#         clean()
#
# 🎓 Шахматка (TASK 5) — добавь условие через continue:
# for row in range(10):
#     for col in range(10):
#         if (row + col) % 2 != 0:
#             continue             # пропускаем «белые» клетки
#         go_to(col, row)
#         clean()

# =========================================================
# ==================  КОНЕЦ — НЕ ТРОГАЙ  ==================
# =========================================================
_finish()
turtle.done()
