# -*- coding: utf-8 -*-
"""
Генератор учебных файлов для курса «Excel для работы».

Запуск:  python generate_materials.py
Требует: openpyxl  (pip install openpyxl)

Создаёт в текущей папке:
  - Продажи.xlsx              (основная таблица заказов, ~300 строк; столбец «Сумма» ученик считает сам)
  - Прайс.xlsx                (справочник товар→цена→категория для ВПР/ПРОСМОТРX)
  - Сотрудники.xlsx           («грязные» данные: ФИО одной строкой, даты, телефоны в разных форматах)
  - Выгрузка_грязная.csv      (грязный CSV для Power Query: пробелы, текст-числа, пустые строки)
  - Данные_для_дашборда.xlsx  (продажи за год, ~1200 строк, для итогового проекта)

Данные детерминированы (random.seed=42) — при повторном запуске получаются те же файлы.
Все данные вымышленные.
"""
import csv
import random
from datetime import date, timedelta

from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill, Alignment

random.seed(42)

# ---------- Справочники ----------
MANAGERS = ["Иванова А.", "Петров С.", "Сидорова М.", "Кузнецов Д.", "Смирнова О.", "Волков И."]
CITIES = ["Москва", "Санкт-Петербург", "Казань", "Новосибирск", "Екатеринбург", "Краснодар"]

# Товар -> (категория, цена)
PRODUCTS = {
    "Ноутбук Aspire 15": ("Компьютеры", 54990),
    "Ноутбук ProBook 14": ("Компьютеры", 72990),
    "Монитор 27\" IPS": ("Периферия", 18990),
    "Клавиатура механическая": ("Периферия", 4990),
    "Мышь беспроводная": ("Периферия", 1490),
    "Веб-камера Full HD": ("Периферия", 3990),
    "Наушники с шумоподавлением": ("Аудио", 12990),
    "Колонка Bluetooth": ("Аудио", 5990),
    "Микрофон USB": ("Аудио", 8990),
    "SSD 1 ТБ": ("Комплектующие", 8490),
    "Оперативная память 16 ГБ": ("Комплектующие", 4290),
    "Видеокарта RTX": ("Комплектующие", 64990),
    "Роутер Wi-Fi 6": ("Сеть", 6990),
    "Сетевой фильтр": ("Аксессуары", 990),
    "Коврик для мыши XL": ("Аксессуары", 790),
    "Сумка для ноутбука": ("Аксессуары", 2490),
}
PRODUCT_NAMES = list(PRODUCTS.keys())

HEADER_FILL = PatternFill("solid", fgColor="305496")
HEADER_FONT = Font(bold=True, color="FFFFFF")


def style_header(ws, ncols):
    for c in range(1, ncols + 1):
        cell = ws.cell(row=1, column=c)
        cell.fill = HEADER_FILL
        cell.font = HEADER_FONT
        cell.alignment = Alignment(horizontal="center", vertical="center")
    ws.freeze_panes = "A2"


def autofit(ws):
    for col in ws.columns:
        width = max((len(str(c.value)) for c in col if c.value is not None), default=10)
        ws.column_dimensions[col[0].column_letter].width = min(width + 3, 40)


# ---------- 1. Продажи.xlsx ----------
def make_sales(filename="Продажи.xlsx", n=300, start=date(2025, 1, 1), days=180, dashboard=False):
    wb = Workbook()
    ws = wb.active
    ws.title = "Продажи"
    headers = ["Дата заказа", "Менеджер", "Город", "Категория", "Товар", "Количество", "Цена", "Сумма"]
    ws.append(headers)
    for _ in range(n):
        d = start + timedelta(days=random.randint(0, days))
        product = random.choice(PRODUCT_NAMES)
        category, price = PRODUCTS[product]
        qty = random.randint(1, 8)
        row = [d, random.choice(MANAGERS), random.choice(CITIES), category, product, qty, price, None]
        # «Сумма» намеренно пустая — ученик считает формулой на уроке 2.
        ws.append(row)
    # форматы
    for r in range(2, n + 2):
        ws.cell(row=r, column=1).number_format = "DD.MM.YYYY"
        ws.cell(row=r, column=7).number_format = "# ##0 ₽"
    style_header(ws, len(headers))
    autofit(ws)
    wb.save(filename)
    print(f"  сохранён {filename} ({n} строк)")


# ---------- 2. Прайс.xlsx ----------
def make_price(filename="Прайс.xlsx"):
    wb = Workbook()
    ws = wb.active
    ws.title = "Прайс"
    ws.append(["Товар", "Категория", "Цена"])
    for name, (cat, price) in PRODUCTS.items():
        ws.append([name, cat, price])
    for r in range(2, len(PRODUCTS) + 2):
        ws.cell(row=r, column=3).number_format = "# ##0 ₽"
    style_header(ws, 3)
    autofit(ws)
    wb.save(filename)
    print(f"  сохранён {filename} ({len(PRODUCTS)} товаров)")


# ---------- 3. Сотрудники.xlsx («грязные» данные) ----------
def make_employees(filename="Сотрудники.xlsx", n=40):
    last_m = ["Иванов", "Петров", "Сидоров", "Кузнецов", "Смирнов", "Волков", "Морозов", "Новиков"]
    last_f = ["Иванова", "Петрова", "Сидорова", "Кузнецова", "Смирнова", "Волкова", "Морозова", "Новикова"]
    first_m = ["Александр", "Сергей", "Дмитрий", "Иван", "Пётр", "Николай"]
    first_f = ["Анна", "Мария", "Ольга", "Елена", "Наталья", "Ирина"]
    patr_m = ["Александрович", "Сергеевич", "Дмитриевич", "Иванович", "Петрович"]
    patr_f = ["Александровна", "Сергеевна", "Дмитриевна", "Ивановна", "Петровна"]
    depts = ["Продажи", "Маркетинг", "Логистика", "Бухгалтерия", "IT"]

    wb = Workbook()
    ws = wb.active
    ws.title = "Сотрудники"
    ws.append(["ФИО", "Отдел", "Дата приёма", "Телефон", "Email"])
    for _ in range(n):
        if random.random() < 0.5:
            ln, fn, pt = random.choice(last_m), random.choice(first_m), random.choice(patr_m)
        else:
            ln, fn, pt = random.choice(last_f), random.choice(first_f), random.choice(patr_f)
        # ФИО одной строкой, иногда с лишними пробелами
        fio = f"{ln} {fn} {pt}"
        if random.random() < 0.3:
            fio = "  " + fio + " "          # лишние пробелы по краям
        if random.random() < 0.2:
            fio = fio.replace(" ", "  ", 1)  # двойной пробел внутри
        # дата приёма
        d = date(random.randint(2015, 2024), random.randint(1, 12), random.randint(1, 28))
        # телефон в РАЗНЫХ форматах — намеренно
        digits = f"9{random.randint(10,99)}{random.randint(1000000,9999999)}"
        fmt = random.choice([
            f"+7 ({digits[0:3]}) {digits[3:6]}-{digits[6:8]}-{digits[8:10]}",
            f"8{digits}",
            f"+7{digits}",
            f"7 {digits[0:3]} {digits[3:]}",
        ])
        email = f"{fn.lower()}.{ln.lower()}@company.ru"
        ws.append([fio, random.choice(depts), d.strftime("%d.%m.%Y"), fmt, email])
    # ВНИМАНИЕ: дата приёма записана как ТЕКСТ (строка) — ученик учится превращать её в дату.
    style_header(ws, 5)
    autofit(ws)
    wb.save(filename)
    print(f"  сохранён {filename} ({n} сотрудников, 'грязные' данные)")


# ---------- 4. Выгрузка_грязная.csv (для Power Query) ----------
def make_dirty_csv(filename="Выгрузка_грязная.csv", n=120):
    city_variants = {
        "Москва": ["Москва", "москва", " Москва", "МОСКВА", "Москва "],
        "Санкт-Петербург": ["Санкт-Петербург", "СПб", "санкт-петербург", " Санкт-Петербург"],
        "Казань": ["Казань", "казань", "Казань "],
    }
    base_cities = list(city_variants.keys())
    rows = [["Дата", "Город", "Товар", "Количество", "Сумма"]]
    for _ in range(n):
        if random.random() < 0.08:
            rows.append(["", "", "", "", ""])  # пустая строка-мусор
            continue
        d = date(2025, random.randint(1, 6), random.randint(1, 28))
        city = random.choice(city_variants[random.choice(base_cities)])
        product = random.choice(PRODUCT_NAMES)
        qty = random.randint(1, 10)
        _, price = PRODUCTS[product]
        total = qty * price
        # число как ТЕКСТ, иногда с пробелом-разделителем тысяч и лишними пробелами
        total_str = f" {total:,} ".replace(",", " ") if random.random() < 0.5 else str(total)
        rows.append([d.strftime("%d.%m.%Y"), city, "  " + product if random.random() < 0.3 else product,
                     str(qty), total_str])
    with open(filename, "w", newline="", encoding="utf-8-sig") as f:
        csv.writer(f, delimiter=";").writerows(rows)
    print(f"  сохранён {filename} ({n} строк, спец. 'грязный' для Power Query)")


if __name__ == "__main__":
    print("Генерация учебных файлов…")
    make_sales("Продажи.xlsx", n=300, start=date(2025, 1, 1), days=180)
    make_price("Прайс.xlsx")
    make_employees("Сотрудники.xlsx", n=40)
    make_dirty_csv("Выгрузка_грязная.csv", n=120)
    make_sales("Данные_для_дашборда.xlsx", n=1200, start=date(2025, 1, 1), days=364)
    print("Готово. Файлы лежат рядом со скриптом.")
