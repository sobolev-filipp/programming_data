# ===== ГЕНЕРАТОР НИКОВ =====
# Эталонный код урока 2. Запусти: Run ▶ (PyCharm / VS Code) или  python генератор_ников.py

name = input("Введи своё имя: ").strip()   # strip() уберёт случайные пробелы по краям
number = input("Любимое число: ")

# Собираем ник склейкой строк
nick = "xX_" + name.upper() + "_" + number + "_Xx"
nick2 = name.lower() + "." + number        # второй вариант

print("=" * 24)
print(f"Твой игровой ник: {nick}")
print(f"Вариант попроще:  {nick2}")
print(f"Длина ника: {len(nick)} символов")
