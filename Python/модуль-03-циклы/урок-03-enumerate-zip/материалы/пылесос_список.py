import turtle, time

# =========================================================
# ================  ДВИЖОК — НЕ ТРОГАЙ  ===================
# =========================================================
_N = 10
_CELL = 40
_ORIGIN = -180
_STEP_DELAY = 0.3           # пауза между шагами (анимация). Меньше = быстрее.

def _sx(x): return _ORIGIN + x * _CELL
def _sy(y): return _ORIGIN + y * _CELL

_screen = turtle.Screen()
_screen.setup(560, 560)
_screen.title("Умный пылесос по списку")
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
trash_x = []               # координаты мусора по X (заполнит задание)
trash_y = []               # координаты мусора по Y

def _place():
    for (cx, cy) in zip(trash_x, trash_y):
        _trash.add((cx, cy))
        _bg.goto(_sx(cx), _sy(cy))
        _bg.dot(18, "#b0b0b0")

def make_task(n):
    global trash_x, trash_y
    if n == 1:                                   # 5 разбросанных точек
        trash_x = [2, 5, 7, 1, 8]
        trash_y = [3, 6, 1, 8, 4]
    elif n == 2:                                 # диагональ через списки
        trash_x = [1, 2, 3, 4, 5, 6, 7]
        trash_y = [1, 2, 3, 4, 5, 6, 7]
    elif n == 3:                                 # зигзаг из 10 точек
        trash_x = [0, 2, 4, 6, 8, 9, 7, 5, 3, 1]
        trash_y = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
    elif n == 4:                                 # длинный ряд, заданный списками
        trash_x = [1, 2, 3, 4, 5, 6, 7, 8]
        trash_y = [4, 4, 4, 4, 4, 4, 4, 4]
    elif n == 5:                                 # 🎓 точки для нумерации enumerate
        trash_x = [3, 6, 2, 7, 5]
        trash_y = [2, 7, 5, 1, 8]
    elif n == 6:                                 # углы квадрата + центр
        trash_x = [2, 7, 2, 7, 4]
        trash_y = [2, 2, 7, 7, 4]
    elif n == 7:                                 # два скопления
        trash_x = [1, 2, 1, 2, 7, 8, 7, 8]
        trash_y = [7, 7, 8, 8, 1, 1, 2, 2]
    elif n == 8:                                 # 🎓 обратная диагональ, 9 точек
        trash_x = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        trash_y = [8, 7, 6, 5, 4, 3, 2, 1, 0]
    _place()

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
        print("Готово! Весь мусор собран.")
    else:
        _screen.title(f"Осталось мусора: {len(_trash)} — доработай алгоритм")
        print(f"Осталось мусора: {len(_trash)}. Проверь, все ли точки обошёл.")
        
# ===== 🐢 УМНЫЙ ПЫЛЕСОС ПО СПИСКУ (zip / enumerate) =====
# Мусор разбросан по комнате 10x10. Его координаты лежат в ДВУХ списках:
#   trash_x — номера столбцов,   trash_y — номера строк.
# Первая точка мусора — в клетке (trash_x[0], trash_y[0]).
#
# Твоя задача: пройти по ВСЕМ точкам мусора через zip и убрать их.
#
# КОМАНДЫ (пиши в блоке «ТВОЙ АЛГОРИТМ»):
#   go_to(x, y) — переместить пылесос в клетку (x, y), координаты 0..9
#   clean()     — убрать мусор в текущей клетке
#
# НОМЕР ЗАДАНИЯ — переменная TASK ниже (1..8).

# =========================================================
# ==================  НАСТРОЙКА ИГРЫ  =====================
# =========================================================

TASK = 1               # <-- НОМЕР ЗАДАНИЯ (меняй: 1..8)

make_task(TASK)
turtle.update()

# Списки с координатами мусора для этого задания (ими и пользуйся):
print("trash_x =", trash_x)
print("trash_y =", trash_y)

# =========================================================
# ==================  ТВОЙ АЛГОРИТМ  ======================
# =========================================================
# ПОДСКАЗКА: zip соединяет два списка координат в пары (x, y).
# Раскомментируй и допиши:
#
# for x, y in zip(trash_x, trash_y):
#     go_to(x, y)
#     clean()
#
# 🎓 Задание 5 — пронумеруй мусор через enumerate:
# for i, (x, y) in enumerate(zip(trash_x, trash_y), start=1):
#     go_to(x, y)
#     clean()
#     print(f"Мусор №{i} убран в клетке ({x}, {y})")

# =========================================================
# ==================  КОНЕЦ — НЕ ТРОГАЙ  ==================
# =========================================================
_finish()
turtle.done()
