# Плейлист: список можно МЕНЯТЬ — добавлять, удалять, править по индексу.
# Запусти файл целиком: увидишь, как список меняется на каждом шаге.

playlist = ["Imagine Dragons", "Coldplay", "Twenty One Pilots"]
print("Стартовый плейлист:", playlist)
print("Всего треков:", len(playlist))
print("-" * 40)

# 1. ОБРАЩЕНИЕ по индексу (нумерация с 0)
print("Первый трек  [0]:", playlist[0])
print("Второй трек  [1]:", playlist[1])
print("Последний трек [-1]:", playlist[-1])   # -1 = с конца
print("-" * 40)

# 2. ИЗМЕНЕНИЕ элемента по индексу (список меняется на месте!)
playlist[1] = "Linkin Park"
print("Заменили [1] на Linkin Park:", playlist)
print("-" * 40)

# 3. ДОБАВЛЕНИЕ
playlist.append("Muse")            # в конец
print("append('Muse'):", playlist)
playlist.insert(0, "The Weeknd")   # на позицию 0 (в начало), остальные сдвинулись
print("insert(0, 'The Weeknd'):", playlist)
print("-" * 40)

# 4. УДАЛЕНИЕ
playlist.remove("Twenty One Pilots")   # по ЗНАЧЕНИЮ (первое совпадение)
print("remove('Twenty One Pilots'):", playlist)
last = playlist.pop()              # pop() без числа — снимает ПОСЛЕДНИЙ и возвращает его
print("pop() снял:", last, "->", playlist)
first = playlist.pop(0)            # pop(0) — по индексу
print("pop(0) снял:", first, "->", playlist)
print("-" * 40)

# 5. ПОЛЕЗНЫЕ МЕТОДЫ
print("Сколько треков:", len(playlist))
print("Есть ли 'Linkin Park'? ->", "Linkin Park" in playlist)
print("Позиция 'Linkin Park':", playlist.index("Linkin Park"))
playlist.sort()                    # сортировка по алфавиту (меняет список!)
print("После sort():", playlist)
playlist.reverse()                 # развернуть
print("После reverse():", playlist)
print("-" * 40)

# 6. ПЕРЕБОР с номерами (enumerate из Модуля 3)
print("Итоговый плейлист:")
for number, track in enumerate(playlist, start=1):
    print(f"  {number}. {track}")
