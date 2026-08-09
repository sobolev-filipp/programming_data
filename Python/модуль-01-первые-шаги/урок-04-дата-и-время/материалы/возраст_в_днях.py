import datetime

# ===== ВОЗРАСТ В ДНЯХ =====
# Эталонный код урока 4. Запусти: Run ▶ (PyCharm / VS Code) или  python возраст_в_днях.py

print("Введи дату рождения.")
year = int(input("Год (например 2013): "))
month = int(input("Месяц (1-12): "))
day = int(input("День (1-31): "))

birthday = datetime.date(year, month, day)
today = datetime.date.today()

age_days = (today - birthday).days
age_years = age_days // 365
age_weeks = age_days // 7

# День недели рождения
names = ["понедельник", "вторник", "среда", "четверг", "пятница", "суббота", "воскресенье"]

print("=" * 30)
print(f"Ты живёшь на свете уже {age_days} дней!")
print(f"Это примерно {age_years} лет ({age_weeks} недель).")
print(f"А ещё это около {age_days * 24} часов.")
print(f"Ты родился в {names[birthday.weekday()]}.")
