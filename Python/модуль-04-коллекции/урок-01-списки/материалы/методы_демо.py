# Мини-справочник методов списка на живых примерах.
# Каждый блок печатает: что было -> что стало.

nums = [4, 1, 7, 1, 9, 1]
print("Список:", nums)

# len / sum / max / min — работают со списком чисел
print("len :", len(nums), "| sum:", sum(nums), "| max:", max(nums), "| min:", min(nums))

# count — сколько раз встречается значение
print("count(1):", nums.count(1))

# index — на какой позиции первое совпадение
print("index(7):", nums.index(7))

# in / not in — есть ли значение
print("5 in nums? ->", 5 in nums)
print("7 not in nums? ->", 7 not in nums)

print("-" * 40)

# sort / sorted — сортировка
letters = ["в", "а", "д", "б"]
print("letters:", letters)
print("sorted(letters):", sorted(letters), "(новый список, letters не тронут)")
print("letters всё ещё:", letters)
letters.sort()
print("после letters.sort():", letters, "(сам список изменён)")
letters.sort(reverse=True)
print("sort(reverse=True):", letters)

print("-" * 40)

# append / insert / extend — добавление
box = ["меч", "щит"]
box.append("зелье")
print("append:", box)
box.insert(1, "лук")
print("insert(1):", box)
box.extend(["карта", "ключ"])   # добавить сразу несколько
print("extend:", box)

print("-" * 40)

# remove / pop / clear — удаление
box.remove("щит")
print("remove('щит'):", box)
taken = box.pop()
print("pop() снял:", taken, "->", box)
box.clear()
print("clear():", box, "(пусто)")
