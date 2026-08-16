# Проект «Уникальные теги»: у каждого поста свой набор тегов.
# Множества дают уникальность и операции, а словарь-счётчик считает популярность.

# Теги трёх постов (список множеств)
post1 = {"питон", "код", "игра"}
post2 = {"код", "музыка", "игра", "арт"}
post3 = {"питон", "арт", "код"}
posts = [post1, post2, post3]

# 1. ВСЕ уникальные теги блога — объединяем все множества
all_tags = set()
for post in posts:
    all_tags = all_tags | post          # копим объединение
print("Всего уникальных тегов:", len(all_tags))
print("Список тегов:", all_tags)
print("-" * 40)

# 2. ОБЩИЕ теги для post1 и post2 — пересечение
common = post1 & post2
print("Общие теги post1 и post2:", common)
print("-" * 40)

# 3. ЧЕМ post1 отличается от post2 — разность
print("Только у post1:", post1 - post2)
print("-" * 40)

# 4. ПОПУЛЯРНОСТЬ каждого тега — словарь-счётчик по всем постам
popularity = {}
for post in posts:
    for tag in post:                    # проходим теги поста
        popularity[tag] = popularity.get(tag, 0) + 1

print("Популярность тегов:")
for tag, n in popularity.items():       # красивый перебор парами
    print(f"  {tag}: в {n} постах")
print("-" * 40)

# 5. Самый популярный тег
top_tag = ""
top_n = 0
for tag, n in popularity.items():
    if n > top_n:
        top_n = n
        top_tag = tag
print(f"Самый популярный тег: {top_tag} ({top_n} постов)")
