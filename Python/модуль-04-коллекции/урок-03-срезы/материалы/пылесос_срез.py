# -*- coding: utf-8 -*-
# ===== 🐢 ПЫЛЕСОС ПО СРЕЗАМ — ПРАКТИКУМ (14 заданий) =====
# В ряду 12 клеток (индексы 0..11). В некоторых лежит мусор (серые точки).
# Твоя задача — убрать РОВНО замусоренные клетки, задав СРЕЗ списка cells.
#
# ЧТО УЖЕ ГОТОВО:
#   cells = [0, 1, 2, ..., 11]   — список номеров всех клеток (им и пользуйся)
#
# КОМАНДА (пиши её в блоке «ТВОЙ АЛГОРИТМ»):
#   clean(i)   — убрать мусор в клетке номер i (пылесос подъезжает и красит её синим)
#
# КАК РЕШАТЬ: пройди циклом по нужному СРЕЗУ списка cells и убери каждую клетку:
#   for i in cells[СРЕЗ]:
#       clean(i)
#   Какой именно срез — придумай сам, глядя, ГДЕ лежит мусор.
#
# НОМЕР ЗАДАНИЯ — переменная TASK ниже (1..14). Описания всех заданий — в практика.md.
# Внизу окно напишет «ЧИСТО!» или сколько мусора осталось.
# Запускать на КОМПЬЮТЕРЕ (PyCharm/VS Code).

import turtle
import time

# ---------- НАСТРОЙКА ХОЛСТА (можно не читать) ----------
N = 12
_PITCH = 44
_HALF = 20
_X0 = -(N * _PITCH) // 2 + _HALF   # центр клетки 0
_Y = 40
_STEP_DELAY = 0.18

_screen = turtle.Screen()
_screen.setup(600, 400)
_screen.title("Пылесос по срезам")
turtle.tracer(0, 0)

_pen = turtle.Turtle()
_pen.hideturtle(); _pen.speed(0); _pen.penup()

_vac = turtle.Turtle()
_vac.hideturtle(); _vac.speed(0); _vac.penup()
_vac.shape("square"); _vac.shapesize(1.8, 1.8)
_vac.color("#ea580c")

cells = list(range(N))     # <-- этим списком ты и пользуешься
_crash = False


def _cx(i):
    return _X0 + i * _PITCH


def _square(x, y, size, fill, border):
    _pen.penup(); _pen.goto(x - size / 2, y - size / 2)
    _pen.pensize(2); _pen.pencolor(border); _pen.fillcolor(fill)
    _pen.setheading(0); _pen.pendown(); _pen.begin_fill()
    for _ in range(4):
        _pen.forward(size); _pen.left(90)
    _pen.end_fill(); _pen.penup()


def _make_trash(task):
    a = list(range(N))
    if task == 1:  return a[:5]
    if task == 2:  return a[6:]
    if task == 3:  return a[-4:]
    if task == 4:  return a[3:8]
    if task == 5:  return a[1:-1]
    if task == 6:  return a[::2]
    if task == 7:  return a[1::2]
    if task == 8:  return a[::3]
    if task == 9:  return a[2::3]
    if task == 10: return a[::-1]
    if task == 11: return a[:3] + a[-3:]
    if task == 12: return a[1:-1:2]
    if task == 13: return a[7:3:-1]
    if task == 14: return a[6::2]
    return []


_trash = set()


def _draw_room(task):
    global _trash
    _trash = set(_make_trash(task))
    for i in range(N):
        _square(_cx(i), _Y, 40, "#f1f5f9", "#cbd5e1")
        _pen.goto(_cx(i), _Y - 44)
        _pen.pencolor("#94a3b8"); _pen.write(i, align="center", font=("Arial", 10, "normal"))
    for i in _trash:
        _pen.goto(_cx(i), _Y); _pen.dot(16, "#9ca3af")
    _vac.goto(_cx(0), _Y - 90)   # пылесос ждёт под рядом
    _vac.showturtle()
    turtle.update()


def clean(i):
    """Убрать мусор в клетке i: пылесос подъезжает и красит её синим."""
    global _crash
    if _crash:
        return
    if i < 0 or i >= N:
        _crash = True
        _vac.color("red")
        turtle.update()
        return
    _vac.goto(_cx(i), _Y)
    _square(_cx(i), _Y, 40, "#bfdbfe", "#2563eb")   # клетка убрана
    _pen.goto(_cx(i), _Y); _pen.dot(12, "#2563eb")
    _trash.discard(i)
    turtle.update(); time.sleep(_STEP_DELAY)


def _report():
    _pen.penup(); _pen.goto(0, -140)
    if _crash:
        _pen.pencolor("#dc2626")
        _pen.write("ВЫЕХАЛ ЗА РЯД! Проверь границы среза.",
                   align="center", font=("Arial", 14, "bold"))
    elif len(_trash) == 0:
        _pen.pencolor("#16a34a")
        _pen.write("ЧИСТО! Срез выбран верно.",
                   align="center", font=("Arial", 16, "bold"))
    else:
        _pen.pencolor("#dc2626")
        _pen.write("Осталось мусора: " + str(len(_trash)),
                   align="center", font=("Arial", 14, "bold"))
    turtle.update()


# =========================================================
# ==================  ТВОЙ АЛГОРИТМ  ======================
# =========================================================
TASK = 1               # <-- НОМЕР ЗАДАНИЯ (меняй: 1..14). Описания всех команд — в практика.md

_draw_room(TASK)

# ПРИМЕР (как пользоваться командой) — ЗАДАНИЕ 1: убрать первые 5 клеток.
# Нужные клетки задаёт срез cells[:5], а clean() их убирает:
#
#     for i in cells[:5]:
#         clean(i)
#
# Дальше — ТВОЯ ОЧЕРЕДЬ: смени TASK, посмотри, где мусор,
# и подбери свой срез (cells[-4:], cells[::2], cells[1:-1], ...).
# Пиши свой алгоритм здесь:


# =========================================================
# ==================  КОНЕЦ — НЕ ТРОГАЙ  ==================
# =========================================================
_report()
turtle.done()   # держит окно открытым — не трогай
