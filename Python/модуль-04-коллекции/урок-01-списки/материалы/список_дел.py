# Приложение "Список дел" — меню в цикле while.
# Список tasks хранит дела. Меняем его командами: добавить, удалить, отметить.
# Ctrl+C — аварийный выход.

tasks = ["Сделать домашку", "Погулять с собакой"]
done = []   # сюда складываем выполненные (для галочки)


def show():
    """Показать список с номерами и галочками."""
    print()
    if len(tasks) == 0:
        print("  Список пуст. Добавь первое дело!")
    for number, task in enumerate(tasks, start=1):
        mark = "[x]" if task in done else "[ ]"
        print(f"  {number}. {mark} {task}")
    print()


print("=== СПИСОК ДЕЛ ===")

while True:
    show()
    print("Меню: [1] добавить  [2] удалить  [3] выполнено  [4] выход")
    choice = input("Что делаем? ")

    if choice == "1":
        new_task = input("Новое дело: ")
        tasks.append(new_task)          # добавили в конец
        print("Добавлено!")

    elif choice == "2":
        number = int(input("Номер дела для удаления: "))
        if 1 <= number <= len(tasks):
            removed = tasks.pop(number - 1)   # номер 1 -> индекс 0
            print("Удалено:", removed)
        else:
            print("Нет дела с таким номером.")

    elif choice == "3":
        number = int(input("Номер выполненного дела: "))
        if 1 <= number <= len(tasks):
            task = tasks[number - 1]
            if task not in done:
                done.append(task)       # отметили галочкой
            print("Отмечено:", task)
        else:
            print("Нет дела с таким номером.")

    elif choice == "4":
        print("Пока! Дел осталось:", len(tasks))
        break

    else:
        print("Не понял команду. Введи число 1-4.")
