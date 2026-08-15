# -*- coding: utf-8 -*-
# ДИАГРАММА «Топ игроков» — turtle-практика к уроку про действия со списками.
# Готовый холст с осями уже нарисован. Твоя задача — командой bar() построить
# столбчатую диаграмму, пройдя ПО СПИСКУ циклом for.
#
# КОМАНДА:
#   bar(value)              — нарисовать один столбец высотой value (0..10), оранжевый
#   bar(value, "#16a34a")   — тот же столбец своим цветом (зелёный)
# Каждый вызов bar() рисует СЛЕДУЮЩИЙ столбец правее предыдущего.
#
# Меняй TASK, чтобы открыть новое задание. Запускать на КОМПЬЮТЕРЕ (PyCharm/VS Code).

import turtle
import time

# ---------- НАСТРОЙКА ХОЛСТА (можно не читать) ----------
_MAX = 10            # верх шкалы
_UNIT = 30           # пикселей на одну единицу высоты
_BAR_W = 40          # ширина столбца
_GAP = 14            # промежуток между столбцами
_X0 = -250           # левый край поля
_Y0 = -200           # базовая линия (низ столбцов)
_COLS = 9            # столбцов помещается на поле
_STEP_DELAY = 0.10   # пауза анимации (меньше -> быстрее)

_screen = turtle.Screen()
_screen.setup(640, 560)
_screen.title("Топ игроков — столбчатая диаграмма")
turtle.tracer(0, 0)

_pen = turtle.Turtle()
_pen.hideturtle()
_pen.speed(0)

_col = 0             # номер следующего столбца


def _center(col):
    return _X0 + col * (_BAR_W + _GAP) + _BAR_W / 2


def _draw_grid():
    # горизонтальные линии + подписи шкалы слева
    _pen.pensize(1)
    for v in range(0, _MAX + 1):
        y = _Y0 + v * _UNIT
        _pen.pencolor("#e2e8f0")
        _pen.penup(); _pen.goto(_X0 - 12, y); _pen.pendown()
        _pen.goto(_X0 + _COLS * (_BAR_W + _GAP), y)
        _pen.penup(); _pen.goto(_X0 - 34, y - 8)
        _pen.pencolor("#94a3b8")
        _pen.write(v, font=("Arial", 10, "normal"))
    # базовая линия (ось X)
    _pen.pensize(2); _pen.pencolor("#334155")
    _pen.penup(); _pen.goto(_X0 - 12, _Y0); _pen.pendown()
    _pen.goto(_X0 + _COLS * (_BAR_W + _GAP), _Y0)
    _pen.penup()


def bar(value, color="#ea580c"):
    """Нарисовать один столбец высотой value. Двигает указатель на следующий."""
    global _col
    if _col >= _COLS:
        return
    x = _center(_col)
    _pen.pensize(_BAR_W)
    _pen.pencolor(color)
    _pen.penup(); _pen.goto(x, _Y0); _pen.setheading(90); _pen.pendown()
    # растим столбец по одной клетке — видно анимацию
    whole = int(value)
    for _ in range(whole):
        _pen.forward(_UNIT)
        turtle.update(); time.sleep(_STEP_DELAY)
    frac = value - whole
    if frac > 0:
        _pen.forward(frac * _UNIT)
    # подпись значения над столбцом
    _pen.penup(); _pen.pensize(1); _pen.pencolor("#1f2937")
    _pen.goto(x, _Y0 + value * _UNIT + 6)
    _pen.write(value, align="center", font=("Arial", 11, "bold"))
    _col += 1
    turtle.update()


_draw_grid()
turtle.update()

# =======================================================
#            ТУТ ПИШИ СВОЙ АЛГОРИТМ (цикл по списку)
# =======================================================
TASK = 1

scores = [8, 5, 10, 3, 7, 6]

# --- ЗАДАНИЕ 1: построй диаграмму по списку scores (пройди циклом for) ---
# for score in scores:
#     bar(score)

# --- ЗАДАНИЕ 2: сначала отсортируй список по убыванию, потом построй ---
# scores.sort(reverse=True)
# for score in scores:
#     bar(score)

# --- ЗАДАНИЕ 3: самый высокий столбец покрась в зелёный (#16a34a) ---
# best = max(scores)
# for score in scores:
#     if score == best:
#         bar(score, "#16a34a")
#     else:
#         bar(score)


# =======================================================
turtle.done()   # держит окно открытым — не трогай
