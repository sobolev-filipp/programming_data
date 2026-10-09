# Как клонировать этот репозиторий на macOS (git-crypt)

> Репозиторий `github.com/sobolev-filipp/programming_data` использует **git-crypt** (часть файлов — theory.md, преподавателю.md, изображения.md, HANDOFF.md — зашифрованы). Плюс репозиторий **большой (~0.5 ГБ)**, поэтому по HTTPS бывает обрыв `curl 92`. Эта инструкция даёт рабочий путь в обход всех граблей.

---

## TL;DR (рабочий путь — делай так)

```bash
# 0. Подготовка (один раз)
brew install git git-crypt
git config --global http.version HTTP/1.1      # лечит обрыв curl 92 (HTTP/2)
git config --global http.postBuffer 524288000  # буфер 500 МБ

# 1. Перейди в папку, где будешь хранить проект
cd ~/Projects          # любая СУЩЕСТВУЮЩАЯ папка

# 2. Клонируй БЕЗ checkout (чтобы git-crypt не ругался во время клона)
#    SSH — надёжнее всего (в обход curl). Если SSH-ключа нет — см. HTTPS-вариант ниже.
git clone -n git@github.com:sobolev-filipp/programming_data.git
cd programming_data

# 3. Найди свой ключ и разблокируй ПОЛНЫМ абсолютным путём
find ~ -name "course-git-crypt.key" 2>/dev/null     # покажет реальный путь
git-crypt unlock /Users/ТВОЙ_ПОЛЬЗОВАТЕЛЬ/путь/course-git-crypt.key

# 4. Теперь выложи файлы (checkout) — git-crypt расшифрует на лету
git checkout .
```

Готово. Проверь: `git-crypt status | head` и открой любой `theory.md` — текст должен быть читаемым.

---

## Почему именно так (разбор 4 проблем)

### Проблема 1 — `RPC failed; curl 92 HTTP/2 stream … CANCEL`
Это **баг curl с HTTP/2 на больших потоках** (обрыв посреди ~500 МБ). git-crypt ни при чём — он работает позже, на checkout.

**Лечение (любое из):**
```bash
git config --global http.version HTTP/1.1     # ← основное решение
git config --global http.postBuffer 524288000
```
Или **клонируй по SSH** — тогда curl/HTTP вообще не участвует:
```bash
git clone -n git@github.com:sobolev-filipp/programming_data.git
```
SSH требует настроенного ключа на GitHub (`ssh-keygen` → добавить `~/.ssh/id_ed25519.pub` в GitHub → Settings → SSH keys). Проверка: `ssh -T git@github.com`.

### Проблема 2 — `smudge filter git-crypt failed`
Это **нормально**: при обычном `git clone` git пытается сразу выложить файлы, а зашифрованные ещё не расшифровать (репозиторий заблокирован).

**Лечение:** клонируй с `-n` (`--no-checkout`), **сначала** разблокируй git-crypt, **потом** `git checkout .` (см. TL;DR). Тогда smudge-фильтр ни разу не падает.

### Проблема 3 — `git-crypt unlock` → `fatal: bad object HEAD`
git-crypt **требует полной истории коммитов**. На **shallow-клоне** (`--depth 1`) истории нет → ошибка.

**Лечение:**
- **НЕ используй `--depth 1`** для этого репозитория. Клонируй полностью.
- `git fetch --unshallow` здесь ненадёжен (снова `curl 92`) и может **повредить** репозиторий — не чини на месте, а пересоздай заново по этой инструкции.
- Если клон обрывается — не мучай shallow, переключись на **SSH** (Проблема 1).

### Проблема 4 — `Unable to read current working directory: No such file or directory`
Терминал «стоит» внутри **удалённой** папки (ты снёс репозиторий, а оболочка осталась в ней).

**Лечение:**
```bash
cd ~            # или любая существующая папка — и команды снова работают
```
И про ключ: указывай **полный абсолютный путь** к `course-git-crypt.key`, а не `course-git-crypt.key` и не `/course-git-crypt.key`. Найти реальный путь:
```bash
find ~ -name "course-git-crypt.key" 2>/dev/null
```

---

## Шпаргалка «ошибка → что делать»

| Ошибка | Причина | Решение |
|--------|---------|---------|
| `curl 92 … HTTP/2 … CANCEL` | HTTP/2 рвёт большой поток | `http.version HTTP/1.1` **или** клон по **SSH** |
| `smudge filter git-crypt failed` | checkout до разблокировки | клон с `-n` → `unlock` → `checkout .` |
| `git-crypt unlock: bad object HEAD` | нет полной истории (shallow) | полный клон, **без** `--depth 1` |
| `fetch --unshallow` снова падает | тот же HTTP/2-баг | не чинить, пересоздать по SSH |
| `Unable to read current working directory` | терминал в удалённой папке | `cd ~` сначала |
| `unlock` не находит ключ | относительный путь к ключу | полный абсолютный путь (`find ~ -name …`) |

---

## HTTPS-вариант (если SSH не настроен)

```bash
git config --global http.version HTTP/1.1
git config --global http.postBuffer 524288000
cd ~/Projects
git clone -n https://github.com/sobolev-filipp/programming_data.git
cd programming_data
git-crypt unlock /полный/путь/course-git-crypt.key
git checkout .
```
Если HTTPS всё равно рвётся на `curl 92` — надёжнее перейти на SSH.

---

## Проверка, что всё ок

```bash
git-crypt status | grep -i encrypted | head     # зашифрованные файлы перечислены
sed -n '1,3p' "computer literacy/HANDOFF.md"     # текст читаемый, а не бинарный мусор
```

Если `HANDOFF.md`/`theory.md` показывают **нормальный русский текст** — git-crypt разблокирован правильно.

---

## Важно

- 🔑 **Ключ `course-git-crypt.key` — секрет.** Никогда не коммить его в репозиторий и не выкладывай. Храни локально (например, в `~/.keys/`), передавай только безопасным каналом.
- 🚫 **Без `--depth 1`** для этого репо (ломает git-crypt).
- 🧹 Обновление уже склонированного репо: обычный `git pull` (при обрывах — тот же `http.version HTTP/1.1` или SSH). Разблокировка нужна **один раз** после клона, при следующих `pull` она сохраняется.
