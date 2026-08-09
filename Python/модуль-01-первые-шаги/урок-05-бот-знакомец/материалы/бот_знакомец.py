import datetime
import random
import time

# ===== БОТ-ЗНАКОМЕЦ =====
# Итоговый проект модуля 1. Запусти: Run ▶ (PyCharm / VS Code) или  python бот_знакомец.py

# 1. Приветствие по времени суток (без if — через трюк hour // 6)
hour = datetime.datetime.now().hour
greetings = ["Доброй ночи", "Доброе утро", "Добрый день", "Добрый вечер"]
print(f"{greetings[hour // 6]}! Я бот-знакомец.")
time.sleep(1)   # небольшая пауза для эффекта

# 2. Знакомство
name = input("Как тебя зовут? ").strip()
age = int(input("Сколько тебе лет? "))
year = int(input("Год рождения (например 2013): "))
month = int(input("Месяц рождения (1-12): "))
day = int(input("День рождения (1-31): "))

# 3. Считаем
birthday = datetime.date(year, month, day)
today = datetime.date.today()
days_lived = (today - birthday).days

# 4. Случайный совет
advice = random.choice([
    "Попробуй сегодня что-то новенькое!",
    "Не забудь улыбнуться сегодня.",
    "Ты справишься с чем угодно.",
    "Сделай перерыв и попей воды.",
])

# 5. Выводим всё красиво
print("=" * 34)
print(f"Приятно познакомиться, {name}!")
print(f"Ты живёшь на свете уже {days_lived} дней — вот это да!")
print(f"Через 10 лет тебе будет {age + 10}.")
print(f"Мой случайный совет: {advice}")
print(f"До встречи, {name}!")
