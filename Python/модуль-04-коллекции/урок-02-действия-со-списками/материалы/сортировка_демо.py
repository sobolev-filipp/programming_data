# sort() vs sorted() и сортировка ПО КЛЮЧУ (key=).
# Каждый блок печатает: что было -> что стало.

nums = [5, 1, 9, 3]
print("исходный список:", nums)

# sorted() — НОВЫЙ список, оригинал не трогает
print("sorted(nums)    :", sorted(nums), "| nums цел:", nums)

# sort() — меняет САМ список (возвращает None!)
nums.sort()
print("после nums.sort():", nums)
nums.sort(reverse=True)
print("reverse=True     :", nums)

print("-" * 45)

# Сортировка СТРОК
words = ["дом", "кот", "радуга", "я", "школа"]
print("слова:", words)
print("по алфавиту:", sorted(words))
print("по ДЛИНЕ   :", sorted(words, key=len))   # ключ = длина слова

print("-" * 45)

# Регистр букв: заглавные идут ПЕРЕД строчными по коду
names = ["аня", "Борис", "вика", "Глеб"]
print("обычно (заглавные первыми):", sorted(names))
print("без учёта регистра        :", sorted(names, key=str.lower))

print("-" * 45)

# Частая ошибка: присвоить результат sort()
data = [3, 1, 2]
data = data.sort()          # <- так делать НЕ надо
print("data = data.sort() ->", data, "(стало None, список потерян!)")
