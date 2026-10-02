# -*- coding: utf-8 -*-
# ===== СВОЯ КОМАНДА ДЛЯ ЧЕРЕПАШКИ — ПЕСОЧНИЦА (практикум) =====
# Поле 16x16 клеток. Готова ОДНА простая команда: paint(x, y) - закрасить клетку.
# Твоя задача - СОЧИНИТЬ свои команды через def: hline, vline, box, cross...
# и собирать из них рисунки. Это и есть функции: своё слово в языке.
#
# ЧТО УЖЕ ГОТОВО (низкоуровневая команда):
#   paint(x, y)              - закрасить клетку (x, y). x вправо 0..15, y вверх 0..15
#   paint(x, y, "red")       - то же, но своим цветом ("red", "green", "#2563eb", ...)
#
# НОМЕР ЗАДАНИЯ - переменная TASK ниже. Описания всех заданий - в практика.md.
# Запускать на КОМПЬЮТЕРЕ (PyCharm / VS Code), не онлайн.

import turtle
import time

# ---------- НАСТРОЙКА ПОЛЯ (можно не читать) ----------
_N = 16
_UNIT = 32
_ORIGIN = -_N * _UNIT / 2
_STEP_DELAY = 0.05

_screen = turtle.Screen()
_screen.setup(600, 600)
_screen.title("Своя команда для черепашки")
turtle.tracer(0, 0)

_grid = turtle.Turtle(visible=False)
_grid.speed(0); _grid.pencolor("#e5e7eb")
for _i in range(_N + 1):
    _grid.penup(); _grid.goto(_ORIGIN + _i * _UNIT, _ORIGIN); _grid.pendown(); _grid.goto(_ORIGIN + _i * _UNIT, _ORIGIN + _N * _UNIT)
    _grid.penup(); _grid.goto(_ORIGIN, _ORIGIN + _i * _UNIT); _grid.pendown(); _grid.goto(_ORIGIN + _N * _UNIT, _ORIGIN + _i * _UNIT)
_grid.penup()

_pen = turtle.Turtle(visible=False)
_pen.speed(0); _pen.penup()


def paint(x, y, color="#e11d48"):
    """Готовая команда: закрасить одну клетку (x, y) цветом color."""
    _pen.goto(_ORIGIN + x * _UNIT, _ORIGIN + y * _UNIT)
    _pen.fillcolor(color); _pen.begin_fill()
    for _ in range(4):
        _pen.forward(_UNIT); _pen.left(90)
    _pen.end_fill()
    turtle.update(); time.sleep(_STEP_DELAY)


turtle.update()

# =========================================================
# ==================  ТВОИ КОМАНДЫ (def)  =================
# =========================================================
TASK = 1     # <-- НОМЕР ЗАДАНИЯ (меняй). Описания всех - в практика.md

# ПРИМЕР (ЗАДАНИЕ 1): сочини команду hline - закрасить горизонтальную линию клеток.
# Опиши её ОДИН раз через def, а потом зови сколько нужно:
#
#     def hline(x1, x2, y):
#         for x in range(x1, x2 + 1):
#             paint(x, y)
#
#     hline(2, 10, 4)      # линия снизу
#     hline(2, 10, 11)     # и ещё одна сверху - команду не копировали!
#
# Дальше - ТВОЯ ОЧЕРЕДЬ: смени TASK и сочиняй свои команды
# (vline - вертикаль, box - прямоугольник, cross - крестик, frame - рамку...).
# Пиши свои def и вызовы здесь:


# =========================================================
# ==================  КОНЕЦ - НЕ ТРОГАЙ  ==================
# =========================================================
turtle.done()   # держит окно открытым - не трогай
