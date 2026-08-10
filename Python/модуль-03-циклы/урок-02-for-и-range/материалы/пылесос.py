import turtle, time

# =========================================================
# ================  ДВИЖОК — НЕ ТРОГАЙ  ===================
# =========================================================
_N = 10
_CELL = 40
_ORIGIN = -180
_STEP_DELAY = 0.25          # пауза между шагами (анимация). Меньше = быстрее.

def _sx(x): return _ORIGIN + x * _CELL
def _sy(y): return _ORIGIN + y * _CELL

_screen = turtle.Screen()
_screen.setup(560, 560)
_screen.title("Умный пылесос")
turtle.tracer(0, 0)         # рисуем без промежуточных обновлений — показываем сами

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
wall = False
_crash = False

def _place(cells):
    for (cx, cy) in cells:
        _trash.add((cx, cy))
        _bg.goto(_sx(cx), _sy(cy))
        _bg.dot(18, "#b0b0b0")

def make_task(n):
    global _x, _y
    if n == 1:                                                      # ряд вправо
        _x, _y = 0, 5; _place([(i, 5) for i in range(1, 10)])
    elif n == 2:                                                    # столбец вверх
        _x, _y = 5, 0; _place([(5, i) for i in range(1, 10)])
    elif n == 3:                                                    # нижний ряд
        _x, _y = 0, 0; _place([(i, 0) for i in range(1, 10)])
    elif n == 4:                                                    # левый столбец
        _x, _y = 0, 0; _place([(0, i) for i in range(1, 10)])
    elif n == 5:                                                    # диагональ /
        _x, _y = 0, 0; _place([(i, i) for i in range(1, 10)])
    elif n == 6:                                                    # верхний ряд, справа налево
        _x, _y = 9, 9; _place([(i, 9) for i in range(0, 9)])
    elif n == 7:                                                    # диагональ \
        _x, _y = 0, 9; _place([(i, 9 - i) for i in range(1, 10)])
    elif n == 8:                                                    # угол L (низ + правый край)
        _x, _y = 0, 0
        _place([(i, 0) for i in range(1, 10)] + [(9, i) for i in range(1, 10)])
    elif n == 9:                                                    # два ряда змейкой
        _x, _y = 0, 3
        _place([(i, 3) for i in range(1, 10)] + [(i, 4) for i in range(0, 9)])
    elif n == 10:                                                   # буква U
        _x, _y = 0, 9
        _place([(0, i) for i in range(0, 9)] + [(i, 0) for i in range(1, 10)] + [(9, i) for i in range(1, 10)])
    elif n == 11:                                                   # рамка по периметру
        _x, _y = 0, 0
        _place([(i, 0) for i in range(1, 10)] + [(9, i) for i in range(1, 10)]
               + [(i, 9) for i in range(0, 9)] + [(0, i) for i in range(0, 9)])
    elif n == 12:                                                   # лесенка
        _x, _y = 0, 0
        _steps = []
        for _k in range(1, 5):
            _steps += [(_k, _k - 1), (_k, _k)]
        _place(_steps)
    make_walls()

def make_walls():
    pass  # внутренних стен пока нет (появятся в следующих уроках)

_v = turtle.Turtle()
_v.shape("circle")
_v.color("purple", "orange")
_v.penup()
_v.speed(0)

def _refresh_wall():
    global wall
    wall = (_x == 0 or _x == _N - 1 or _y == 0 or _y == _N - 1)

def _show():
    turtle.update()
    time.sleep(_STEP_DELAY)     # пауза — чтобы был виден каждый шаг

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
    _refresh_wall()
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
        print("Пылесос выехал за стену. Считай клетки: ряд из 9 клеток — это range(9).")
    elif not _trash:
        _screen.title("Умный пылесос — ЧИСТО! Молодец!")
        print("Готово! Весь мусор собран.")
    else:
        _screen.title(f"Осталось мусора: {len(_trash)} — доработай алгоритм")
        print(f"Осталось мусора: {len(_trash)}. Проверь алгоритм.")
        
# ===== 🐢 УМНЫЙ ПЫЛЕСОС (игра на циклах) =====
# Пылесос ездит по комнате 10x10 и собирает мусор (серые точки).
# Черепашку изучать НЕ нужно! Тебе нужно:
#   1) выбрать номер задания в переменной TASK ниже;
#   2) написать АЛГОРИТМ из команд движения — так, чтобы собрать ВЕСЬ мусор.
#
# КОМАНДЫ (пиши их внизу, в блоке «ТВОЙ АЛГОРИТМ»):
#   right()  — переехать на клетку вправо
#   left()   — влево
#   up()     — вверх
#   down()   — вниз
#   clean()  — убрать мусор в текущей клетке (закрасить синим)
#   wall     — флаг: True, когда пылесос стоит у стены
#
# Клетки нумеруются 0..9. Выедешь за стену — пылесос покраснеет и остановится.

# =========================================================
# ==================  НАСТРОЙКА ИГРЫ  =====================
# =========================================================

TASK = 1               # <-- НОМЕР ЗАДАНИЯ (меняй: 1..12)

make_task(TASK)
_v.goto(_sx(_x), _sy(_y))
_refresh_wall()
turtle.update()        # показать комнату и пылесос перед стартом

# =========================================================
# ==================  ТВОЙ АЛГОРИТМ  ======================
# =========================================================
# Пример для ЗАДАНИЯ 1 (ряд мусора справа от старта):
# for i in range(9):
#     right()
#     clean()


# =========================================================
# ==================  КОНЕЦ — НЕ ТРОГАЙ  ==================
# =========================================================
_finish()
turtle.done()
