# Урок 0.2. Практика на занятии: пошаговая установка

> Все шаги делаем **синхронно вместе с классом**. Не «доделают потом».

---

## Шаг 1. Устанавливаем Anaconda (15 минут)

1. Открыть [https://www.anaconda.com/download](https://www.anaconda.com/download)
2. Скачать установщик для своей ОС (Windows / macOS / Linux).
3. Запустить установщик. **Важные галочки на Windows:**
   - **«Add Anaconda3 to my PATH environment variable»** — поставить (по умолчанию выключено!).
   - **«Register Anaconda3 as my default Python»** — поставить.
4. После установки открыть **«Anaconda Prompt»** (на Windows — через меню «Пуск», на Mac/Linux — обычный терминал).
5. Проверить установку:

```bash
python --version
```

Должно вывести что-то вроде `Python 3.11.x`.

```bash
conda --version
```

Должно вывести `conda 24.x.x` (или похоже).

> **Если `python --version` не работает** — Anaconda не прописалась в PATH. Переустановите с галочкой.

---

## Шаг 2. Устанавливаем VS Code и расширения (10 минут)

1. Скачать VS Code: [https://code.visualstudio.com/Download](https://code.visualstudio.com/Download)
2. Установить (стандартный мастер, ничего особенного).
3. Открыть VS Code.
4. Слева — иконка «Extensions» (или `Ctrl+Shift+X`). Установить:
   - **Python** (от Microsoft)
   - **Jupyter** (от Microsoft)
   - (опционально) **Pylance** (от Microsoft) — подсветка и автодополнение
   - (опционально) **GitLens** — расширенная работа с git
5. Перезапустить VS Code.
6. Открыть пустую папку (`File → Open Folder`). Создать в ней файл `hello.py`:

```python
print("Привет, машинное обучение!")
```

7. Запустить: правый верхний угол → треугольная кнопка «Run».
8. Снизу должен открыться терминал с выводом `Привет, машинное обучение!`.

> **Если выскочило окно «Select Python Interpreter»** — выберите тот, что из Anaconda (в пути будет `anaconda3`).

---

## Шаг 3. Устанавливаем и настраиваем Git (10 минут)

### Для Windows:

1. Скачать [Git for Windows](https://git-scm.com/download/win)
2. Установить (можно с настройками по умолчанию). Один важный экран — «Choosing the default editor» — оставьте «Use Visual Studio Code as Git's default editor».

### Для macOS / Linux:

Git обычно уже установлен. Проверить в терминале:

```bash
git --version
```

Если не установлен — на Mac: `xcode-select --install`; на Ubuntu: `sudo apt install git`.

### Настройка (всем):

Открыть терминал (на Windows — Git Bash или Anaconda Prompt), ввести:

```bash
git config --global user.name "Иван Иванов"
git config --global user.email "ivan@example.com"
```

Имя и email используют для подписи коммитов. Email должен совпадать с тем, что укажете при регистрации на GitHub.

---

## Шаг 4. Регистрируемся на GitHub (10 минут)

1. Открыть [https://github.com/signup](https://github.com/signup)
2. Ввести email, придумать пароль и логин.
   - **Логин выбирайте серьёзно** — это ваше «лицо» в IT-мире. `cool-coder-2010` плохо, `ivan-petrov-dev` хорошо.
3. Подтвердить email (письмо придёт почти сразу).
4. **Включить двухфакторную аутентификацию (2FA).**
   - Settings → Password and authentication → Two-factor authentication.
   - Установить на телефон [Google Authenticator](https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2) или [Microsoft Authenticator](https://apps.apple.com/app/microsoft-authenticator/id983156458).
   - Сохранить резервные коды в надёжное место (например, в Google Keep).
5. Заполнить профиль (фото опционально, но желательно).

---

## Шаг 5. Первый репозиторий и коммит (10 минут)

### На GitHub:

1. Нажать «+» в правом верхнем углу → «New repository».
2. Имя репозитория: `neural-networks-course-<ваше_имя>` (например, `neural-networks-course-ivan`).
3. Описание: «Мои работы по курсу нейросетей»
4. **Public** (приватные тоже можно, но публичные — это портфолио).
5. **Поставить галочку «Add a README file»**.
6. Лицензия — MIT (необязательно, но хорошо).
7. Нажать «Create repository».

### На своём компьютере:

1. Открыть **Anaconda Prompt** (или терминал в VS Code).
2. Перейти в удобную папку, например:

```bash
cd Desktop
```

3. Скопировать в браузере **HTTPS-ссылку** репозитория (зелёная кнопка «Code» на GitHub → HTTPS).

4. Клонировать:

```bash
git clone https://github.com/<ваш_логин>/neural-networks-course-<имя>.git
cd neural-networks-course-<имя>
```

5. Открыть папку в VS Code:

```bash
code .
```

6. Создать в папке файл `homework/lesson-0-1/homework_0_1.md` (даже если он пустой — это «заготовка» для ДЗ).

7. В терминале VS Code:

```bash
git add homework/lesson-0-1/homework_0_1.md
git commit -m "Создал структуру для ДЗ урока 0.1"
git push
```

8. Обновить страницу репозитория на GitHub — файл должен появиться.

> **Если `git push` запросит логин/пароль** — GitHub с 2021 не принимает пароль. Нужно:
> - Либо войти через **GitHub Desktop** (он подружит ваш git с аккаунтом).
> - Либо создать **Personal Access Token**: Settings → Developer settings → Personal access tokens → Generate. Этот токен использовать вместо пароля.
> - На уроке проще всего поставить GitHub Desktop.

---

## Шаг 6. Jupyter и Google Colab (10 минут)

### Локальный Jupyter:

1. В Anaconda Prompt:

```bash
jupyter notebook
```

2. Откроется браузер с интерфейсом Jupyter.
3. New → Python 3 → ввести:

```python
print("Hello, AI!")
2 + 2
```

4. Нажать `Shift + Enter` для выполнения.

### Google Colab:

1. Открыть [https://colab.research.google.com/](https://colab.research.google.com/)
2. Войти под Google-аккаунтом.
3. «New notebook».
4. В ячейку:

```python
print("Hello, AI from cloud!")
```

5. Нажать `Shift + Enter`.

6. Проверка GPU (на потом — Модуль 5):

```python
import torch
print(torch.cuda.is_available())
```

Сейчас может вывести `False` (бесплатный Colab по умолчанию без GPU). Это нормально — мы включим GPU позже.

---

## Шаг 7. Первые библиотеки (8 минут)

В Anaconda Prompt:

```bash
pip install numpy pandas matplotlib scikit-learn jupyter
```

> **Если выскочит ошибка про права доступа** — на Windows запускайте Anaconda Prompt от имени администратора, на Mac/Linux добавляйте `pip install --user ...`.

Проверка — в Python (или Jupyter):

```python
import numpy
import pandas
import matplotlib
import sklearn

print("Всё установлено:", numpy.__version__, pandas.__version__, sklearn.__version__)
```

Если вывелось без ошибок и с номерами версий — поздравляю, всё работает.

---

## Troubleshooting: типичные проблемы

| Проблема | Причина | Решение |
|----------|---------|---------|
| `python` не найден в терминале | Anaconda не в PATH | Переустановить с галочкой «Add to PATH» |
| VS Code не видит Anaconda-Python | Не выбран интерпретатор | `Ctrl+Shift+P` → `Python: Select Interpreter` → выбрать Anaconda |
| `git push` просит пароль | GitHub запретил пароли | GitHub Desktop или Personal Access Token |
| `pip install` падает с SSL/прокси-ошибкой | Корпоративная сеть | `pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org <пакет>` |
| Colab жалуется на лимиты | Бесплатный лимит исчерпан | Подождать сутки или использовать другой Google-аккаунт |
| `git clone` падает с auth-ошибкой | Не настроен Git с GitHub | Установить GitHub Desktop, он сам всё подружит |
| На Windows `pip install` собирает что-то долго | Нет Visual C++ Build Tools | Поставить [Build Tools](https://visualstudio.microsoft.com/visual-cpp-build-tools/) или ставить пакеты через `conda install` |

> Если что-то не решается за 5 минут — **не зависайте классом**. Запишите задачу «доделать индивидуально» и идите дальше.

---

## К концу урока у каждого ученика есть:

- [ ] Установленная Anaconda + Python 3.11.
- [ ] Установленный VS Code с расширениями Python и Jupyter.
- [ ] Установленный Git, настроены имя и email.
- [ ] Аккаунт на GitHub с включённой 2FA.
- [ ] Личный публичный репозиторий `neural-networks-course-<имя>`.
- [ ] В нём — `README.md` и заготовка `homework/lesson-0-1/homework_0_1.md`.
- [ ] Сделан минимум один коммит и push.
- [ ] Открывается Google Colab и работает простой `print`.
- [ ] Установлены библиотеки: `numpy`, `pandas`, `matplotlib`, `scikit-learn`, `jupyter`.
