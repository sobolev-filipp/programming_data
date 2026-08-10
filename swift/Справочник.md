# 📱 Swift — Справочник курса

> Этот справочник поможет тебе вспомнить любую тему курса.
> Здесь собраны все команды, объяснения и примеры кода.

---

## 📋 Оглавление

- [Блок 1 — Основы Swift](#блок-1--основы-swift)
  - [Урок 1 — Переменные и типы данных](#урок-1--переменные-и-типы-данных)
  - [Урок 2 — Условия и функции](#урок-2--условия-и-функции)
  - [Урок 3 — Циклы, массивы, случайные числа](#урок-3--циклы-массивы-случайные-числа)
  - [Урок 4 — Классы и структуры](#урок-4--классы-и-структуры)
- [Блок 2 — Первое приложение](#блок-2--первое-приложение)
  - [Урок 5 — Кнопки и метки](#урок-5--кнопки-и-метки)
  - [Урок 6 — Несколько экранов и навигация](#урок-6--несколько-экранов-и-навигация)
  - [Урок 7 — Auto Layout](#урок-7--auto-layout)
  - [Урок 8 — Списки UITableView](#урок-8--списки-uitableview)
- [Блок 3 — Мини-приложения](#блок-3--мини-приложения)
  - [Урок 9 — Сохранение данных UserDefaults](#урок-9--сохранение-данных-userdefaults)
  - [Урок 10 — Анимации](#урок-10--анимации)
  - [Урок 11 — Звуки](#урок-11--звуки)
  - [Урок 12 — Жесты и касания](#урок-12--жесты-и-касания)
- [Блок 4 — Разработка игр SpriteKit](#блок-4--разработка-игр-spritekit)
  - [Урок 13 — Первые спрайты](#урок-13--первые-спрайты)
  - [Урок 14 — Движение и анимация спрайтов](#урок-14--движение-и-анимация-спрайтов)
  - [Урок 15 — Физика и столкновения](#урок-15--физика-и-столкновения)
  - [Урок 16 — Управление игроком](#урок-16--управление-игроком)
  - [Урок 17 — Враги, счёт и жизни](#урок-17--враги-счёт-и-жизни)
  - [Урок 18 — Звуки и частицы в игре](#урок-18--звуки-и-частицы-в-игре)
  - [Урок 19 — Рекорды и меню](#урок-19--рекорды-и-меню)
- [Блок 5 — SwiftUI](#блок-5--swiftui)
  - [Урок 22 — Основы SwiftUI](#урок-22--основы-swiftui)
  - [Урок 23 — Списки и данные](#урок-23--списки-и-данные)
  - [Урок 24 — Загрузка данных из сети](#урок-24--загрузка-данных-из-сети)
- [Шпаргалки](#шпаргалки)
  - [Цвета в Swift](#цвета-в-swift)
  - [Частые ошибки](#частые-ошибки)

---

## Блок 1 — Основы Swift

---

### Урок 1 — Переменные и типы данных

#### Что такое переменная?

Переменная — это коробка с именем, в которой хранится значение. Ты можешь положить туда число, текст или что-то другое, а потом достать когда нужно.

В Swift есть два вида «коробок»:
- **`var`** — значение можно менять
- **`let`** — значение задаётся один раз и не меняется (константа)

```swift
var score = 0          // можно менять позже
score = 10             // ок!

let playerName = "Алиса"  // нельзя менять
// playerName = "Боб"   // ❌ ошибка!
```

> **Правило:** Используй `let` везде где можно. Xcode сам подскажет когда нужен `var`.

#### Основные типы данных

| Тип | Что хранит | Пример |
|---|---|---|
| `Int` | Целое число | `42`, `-5`, `0` |
| `Double` | Число с точкой | `3.14`, `-0.5` |
| `String` | Текст | `"Привет"`, `"Swift"` |
| `Bool` | Правда или ложь | `true`, `false` |

```swift
var age: Int = 12
var height: Double = 1.65
var name: String = "Максим"
var isPlaying: Bool = true
```

> Swift умный — обычно тип писать не нужно, он сам догадается:
> ```swift
> var age = 12        // Swift понял: это Int
> var name = "Максим" // Swift понял: это String
> ```

#### Строки — работа с текстом

```swift
var greeting = "Привет"

// Соединить строки
var message = greeting + ", Мир!"    // "Привет, Мир!"

// Вставить переменную в строку (интерполяция)
var score = 100
var text = "Твой счёт: \(score)"     // "Твой счёт: 100"
var info = "Имя: \(name), возраст: \(age)"

// Длина строки
var len = name.count    // количество символов

// Строка в верхний/нижний регистр
var upper = name.uppercased()   // "МАКСИМ"
var lower = name.lowercased()   // "максим"
```

#### Числа — основные операции

```swift
var a = 10
var b = 3

var sum  = a + b    // 13  — сложение
var diff = a - b    // 7   — вычитание
var mul  = a * b    // 30  — умножение
var div  = a / b    // 3   — деление (целое!)
var rem  = a % b    // 1   — остаток от деления

// Сокращённая запись
a += 5    // то же что a = a + 5  → a = 15
a -= 2    // a = a - 2
a *= 3    // a = a * 3
a /= 2    // a = a / 2
```

> **Важно:** `10 / 3` = `3`, а не `3.33` — потому что оба числа `Int`. Чтобы получить дробное — используй `Double`:
> ```swift
> var result = Double(10) / Double(3)   // 3.333...
> ```

---

### Урок 2 — Условия и функции

#### Условие if / else

Условие — это вопрос на который ответ «да» или «нет». Если да — выполняем один код, если нет — другой.

```swift
var score = 85

if score >= 90 {
    print("Отлично!")
} else if score >= 70 {
    print("Хорошо!")
} else {
    print("Попробуй ещё раз")
}
```

#### Операторы сравнения

| Оператор | Смысл | Пример |
|---|---|---|
| `==` | равно | `a == b` |
| `!=` | не равно | `a != b` |
| `>` | больше | `a > b` |
| `<` | меньше | `a < b` |
| `>=` | больше или равно | `a >= b` |
| `<=` | меньше или равно | `a <= b` |

#### Логические операторы

```swift
// && — И (оба условия должны быть true)
if age >= 10 && age <= 18 {
    print("Ты подросток")
}

// || — ИЛИ (хотя бы одно условие true)
if score == 100 || hasBonus == true {
    print("Получаешь приз!")
}

// ! — НЕ (переворачивает условие)
if !isGameOver {
    print("Игра продолжается")
}
```

#### switch — когда вариантов много

```swift
var day = "Понедельник"

switch day {
case "Суббота", "Воскресенье":
    print("Выходной!")
case "Понедельник":
    print("Начало недели")
default:
    print("Рабочий день")
}
```

#### Функции

Функция — это блок кода с именем. Написал один раз — вызывай сколько угодно.

```swift
// Простая функция без параметров
func sayHello() {
    print("Привет!")
}
sayHello()   // вызов

// Функция с параметром
func greet(name: String) {
    print("Привет, \(name)!")
}
greet(name: "Алиса")

// Функция которая возвращает значение
func add(a: Int, b: Int) -> Int {
    return a + b
}
var result = add(a: 5, b: 3)   // result = 8

// Краткая запись — если одна строка
func multiply(a: Int, b: Int) -> Int {
    a * b   // return можно не писать
}
```

> **Аналогия:** Функция — это как рецепт. Ты написал рецепт торта один раз, а потом можешь готовить его сколько угодно раз.

---

### Урок 3 — Циклы, массивы, случайные числа

#### Массивы

Массив — это список значений одного типа. Как пронумерованные ящики.

```swift
// Создать массив
var fruits = ["яблоко", "банан", "апельсин"]
var scores = [10, 25, 33, 47]

// Обратиться к элементу по индексу (счёт с 0!)
print(fruits[0])   // "яблоко"
print(fruits[1])   // "банан"
print(fruits[2])   // "апельсин"

// Количество элементов
print(fruits.count)   // 3

// Добавить элемент в конец
fruits.append("груша")

// Удалить элемент
fruits.remove(at: 1)   // удалит "банан"

// Изменить элемент
fruits[0] = "слива"

// Проверить — пустой ли массив
if fruits.isEmpty {
    print("Массив пустой")
}
```

#### Цикл for

```swift
// Перебрать все элементы массива
var names = ["Алиса", "Боб", "Вася"]
for name in names {
    print("Привет, \(name)!")
}

// Повторить N раз
for i in 1...5 {
    print("Шаг \(i)")   // 1, 2, 3, 4, 5
}

// Диапазон без последнего числа
for i in 0..<3 {
    print(i)   // 0, 1, 2
}

// Если индекс не нужен — используй _
for _ in 0..<10 {
    print("повтор")
}
```

#### Цикл while

```swift
var lives = 3

while lives > 0 {
    print("Жизней осталось: \(lives)")
    lives -= 1
}
// выводит: 3, 2, 1 — потом цикл заканчивается
```

#### Случайные числа

```swift
// Случайное Int в диапазоне от 1 до 6 (как кубик)
var dice = Int.random(in: 1...6)

// Случайное Double от 0 до 1
var chance = Double.random(in: 0.0...1.0)

// Случайный элемент из массива
var enemies = ["гоблин", "дракон", "скелет"]
var randomEnemy = enemies.randomElement()!
```

---

### Урок 4 — Классы и структуры

#### Структуры (struct)

Структура — это шаблон для создания объектов с несколькими свойствами. Как форма для печенья.

```swift
struct Hero {
    var name: String
    var health: Int
    var level: Int

    // Метод — функция внутри структуры
    func describe() {
        print("\(name) — уровень \(level), здоровье \(health)")
    }

    // mutating — метод который меняет свойства структуры
    mutating func takeDamage(_ amount: Int) {
        health -= amount
    }
}

// Создать объект структуры
var hero = Hero(name: "Артём", health: 100, level: 1)

// Обратиться к свойствам
print(hero.name)     // "Артём"
print(hero.health)   // 100

// Вызвать метод
hero.describe()
hero.takeDamage(30)
print(hero.health)   // 70
```

#### Классы (class)

Класс похож на структуру, но есть важное отличие: когда передаёшь структуру — копируется, когда передаёшь класс — передаётся тот же объект.

```swift
class Enemy {
    var name: String
    var health: Int

    // Инициализатор — запускается при создании объекта
    init(name: String, health: Int) {
        self.name = name
        self.health = health
    }

    func attack() -> Int {
        return Int.random(in: 5...15)
    }
}

// Создать объект класса
var goblin = Enemy(name: "Гоблин", health: 50)
var damage = goblin.attack()
print("Гоблин нанёс \(damage) урона")
```

#### struct vs class — главное отличие

```swift
// STRUCT — копирование
var hero1 = Hero(name: "Артём", health: 100, level: 1)
var hero2 = hero1          // создаётся КОПИЯ
hero2.health = 50
print(hero1.health)        // 100 — hero1 не изменился!

// CLASS — один объект
var enemy1 = Enemy(name: "Гоблин", health: 50)
var enemy2 = enemy1        // это ТОТ ЖЕ объект
enemy2.health = 10
print(enemy1.health)       // 10 — изменился! оба смотрят на одно
```

> **Правило для начинающих:** Для простых данных (герой, настройки) — `struct`. Для сложных объектов (сцена, контроллер) — `class`.

---

## Блок 2 — Первое приложение

---

### Урок 5 — Кнопки и метки

#### Как устроено приложение на UIKit

```
Приложение
  └── UIWindow
        └── UIViewController   ← контроллер экрана (твой .swift файл)
              └── UIView        ← корневое представление
                    ├── UILabel    ← текст
                    ├── UIButton   ← кнопка
                    └── UITextField ← поле ввода
```

#### IBOutlet — подключить элемент к коду

`IBOutlet` — это связь между элементом в Storyboard и переменной в коде. Через неё ты можешь менять элемент программно.

```swift
class ViewController: UIViewController {

    // @IBOutlet — эта переменная подключена к элементу в Storyboard
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // viewDidLoad вызывается когда экран загрузился
        scoreLabel.text = "Счёт: 0"
        nameLabel.textColor = .red
    }
}
```

> **Как подключить в Xcode:** Зажми `Ctrl` и перетащи элемент из Storyboard в код. Выбери `Outlet` и дай имя.

#### IBAction — реакция на нажатие

`IBAction` — это функция которая вызывается когда пользователь нажимает кнопку.

```swift
// @IBAction — эта функция вызывается при нажатии кнопки
@IBAction func buttonTapped(_ sender: UIButton) {
    scoreLabel.text = "Нажато!"
}

// sender — это сама кнопка которую нажали
@IBAction func colorButtonTapped(_ sender: UIButton) {
    // Можно узнать какую именно кнопку нажали
    sender.backgroundColor = .green
}
```

#### UILabel — текст на экране

```swift
var label = UILabel()

label.text = "Привет!"                    // текст
label.font = UIFont.boldSystemFont(ofSize: 24)  // шрифт
label.textColor = .white                  // цвет текста
label.backgroundColor = .blue             // цвет фона
label.textAlignment = .center             // выравнивание
label.numberOfLines = 0                   // 0 = любое кол-во строк
```

#### UIButton — кнопка

```swift
// Изменить кнопку в коде
button.setTitle("Нажми меня", for: .normal)
button.setTitleColor(.white, for: .normal)
button.backgroundColor = .systemBlue
button.layer.cornerRadius = 10    // скруглить углы
button.isEnabled = false          // сделать неактивной
```

---

### Урок 6 — Несколько экранов и навигация

#### NavigationController

`UINavigationController` — это «стопка» экранов. Каждый новый экран кладётся поверх стопки, кнопка «Назад» убирает верхний.

Чтобы добавить: в Storyboard выдели свой ViewController → Editor → Embed In → Navigation Controller.

#### Переход между экранами через Segue

**Способ 1 — прямо из Storyboard:**
Ctrl + перетащи с кнопки на второй экран → выбери `Show`.

**Способ 2 — из кода:**
```swift
// Дать segue идентификатор в Storyboard (поле Identifier)
// Потом вызвать переход из кода:
performSegue(withIdentifier: "goToDetail", sender: nil)
```

#### Передача данных между экранами

```swift
// На ПЕРВОМ экране — отправляем данные
class FirstViewController: UIViewController {

    var selectedName = "Алиса"

    // prepare вызывается ПЕРЕД переходом
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail" {
            // Получаем ссылку на второй контроллер
            let destination = segue.destination as! DetailViewController
            // Передаём данные
            destination.playerName = selectedName
        }
    }
}

// На ВТОРОМ экране — принимаем данные
class DetailViewController: UIViewController {

    var playerName = ""   // сюда запишет первый экран
    @IBOutlet weak var nameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = playerName   // показываем полученное имя
    }
}
```

#### Вернуться назад программно

```swift
// Вернуться на предыдущий экран
navigationController?.popViewController(animated: true)

// Вернуться на самый первый экран
navigationController?.popToRootViewController(animated: true)
```

---

### Урок 7 — Auto Layout

#### Что такое Auto Layout?

Auto Layout — это система правил (констрейнтов) которая говорит: «этот элемент всегда должен быть в 20 точках от левого края». Благодаря ей интерфейс выглядит правильно на любом iPhone — маленьком и большом.

#### Как добавить констрейнты в Storyboard

1. Выбрать элемент
2. Нажать кнопку **Add New Constraints** (квадрат с палочками, внизу справа)
3. Ввести отступы от краёв
4. Нажать **Add Constraints**

Или: **Ctrl + перетащить** на другой элемент / на View — выбрать тип констрейнта.

#### Типы констрейнтов

| Констрейнт | Смысл |
|---|---|
| Leading | Отступ от левого края |
| Trailing | Отступ от правого края |
| Top | Отступ сверху |
| Bottom | Отступ снизу |
| Width | Ширина |
| Height | Высота |
| Center X | Центр по горизонтали |
| Center Y | Центр по вертикали |

#### Констрейнты из кода

```swift
// Включить программные констрейнты (отключить автоматические)
button.translatesAutoresizingMaskIntoConstraints = false

NSLayoutConstraint.activate([
    // Центр по горизонтали
    button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    // Отступ снизу 50 точек
    button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
    // Ширина 200
    button.widthAnchor.constraint(equalToConstant: 200),
    // Высота 50
    button.heightAnchor.constraint(equalToConstant: 50)
])
```

---

### Урок 8 — Списки UITableView

#### Как работает UITableView

`UITableView` показывает список ячеек. Он не хранит данные сам — он спрашивает у тебя: «сколько ячеек нужно?» и «что показать в ячейке №3?». Ты отвечаешь через **dataSource**.

#### Минимальный рабочий список

```swift
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var games = ["Minecraft", "Roblox", "Among Us", "Fortnite", "FIFA"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }

    // Сколько ячеек в таблице?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }

    // Что показать в ячейке с индексом indexPath.row?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = games[indexPath.row]
        return cell
    }

    // Что делать при нажатии на ячейку?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGame = games[indexPath.row]
        print("Выбрана игра: \(selectedGame)")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
```

> **Не забудь** в Storyboard: выбери TableView → Attributes → Cell Identifier → напиши `"cell"`. Иначе краш!

#### Полезные методы таблицы

```swift
// Перезагрузить таблицу (обновить все ячейки)
tableView.reloadData()

// Высота ячейки
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
}
```

---

## Блок 3 — Мини-приложения

---

### Урок 9 — Сохранение данных UserDefaults

#### Что такое UserDefaults?

`UserDefaults` — это маленькая база данных на устройстве. Отлично подходит для хранения простых данных: имя игрока, лучший счёт, настройки. Данные остаются даже после закрытия приложения.

> **Аналогия:** Как записная книжка — записал, закрыл, открыл — всё на месте.

#### Сохранение

```swift
let defaults = UserDefaults.standard

// Сохранить разные типы данных
defaults.set("Алиса", forKey: "playerName")   // String
defaults.set(1500, forKey: "highScore")        // Int
defaults.set(true, forKey: "soundEnabled")     // Bool
defaults.set(1.5, forKey: "volume")            // Double
```

#### Загрузка

```swift
let defaults = UserDefaults.standard

// Загрузить String (может быть nil если не сохраняли)
let name = defaults.string(forKey: "playerName") ?? "Гость"

// Загрузить Int (вернёт 0 если не сохраняли)
let score = defaults.integer(forKey: "highScore")

// Загрузить Bool (вернёт false если не сохраняли)
let sound = defaults.bool(forKey: "soundEnabled")
```

> **`??` — оператор «если nil»:** `defaults.string(forKey: "name") ?? "Гость"` означает: если значение есть — вернуть его, если нет — вернуть `"Гость"`.

#### Удаление

```swift
defaults.removeObject(forKey: "playerName")
```

#### Типичное использование — рекорд

```swift
func saveHighScore(_ score: Int) {
    let current = UserDefaults.standard.integer(forKey: "highScore")
    if score > current {
        UserDefaults.standard.set(score, forKey: "highScore")
        print("Новый рекорд: \(score)!")
    }
}

func loadHighScore() -> Int {
    return UserDefaults.standard.integer(forKey: "highScore")
}
```

---

### Урок 10 — Анимации

#### UIView.animate — основа анимаций

`UIView.animate` плавно изменяет свойства элемента за указанное время.

```swift
// Простая анимация
UIView.animate(withDuration: 0.5) {
    // всё что напишешь здесь — анимируется плавно
    button.alpha = 0              // исчезнуть
    button.transform = CGAffineTransform(scaleX: 2, y: 2)   // увеличиться вдвое
}

// Анимация с завершением
UIView.animate(withDuration: 0.3, animations: {
    label.frame.origin.y -= 50   // поднять вверх
}) { finished in
    // этот код выполнится ПОСЛЕ анимации
    label.text = "Готово!"
}

// Анимация с пружиной (эффект подпрыгивания)
UIView.animate(
    withDuration: 0.6,
    delay: 0,
    usingSpringWithDamping: 0.5,    // 0 = много прыжков, 1 = без прыжков
    initialSpringVelocity: 0.5,
    options: [],
    animations: {
        button.transform = .identity   // вернуть к исходному размеру
    }
)
```

#### CGAffineTransform — трансформации

```swift
// Масштаб
view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)

// Поворот (угол в радианах)
view.transform = CGAffineTransform(rotationAngle: .pi / 4)  // 45 градусов

// Сдвиг
view.transform = CGAffineTransform(translationX: 100, y: 0)

// Вернуть к исходному состоянию
view.transform = .identity
```

#### Что можно анимировать

```swift
UIView.animate(withDuration: 0.4) {
    view.alpha = 0.0                         // прозрачность
    view.backgroundColor = .red              // цвет фона
    view.frame = CGRect(x:0, y:0, w:100, h:100)  // позиция и размер
    view.transform = CGAffineTransform(scaleX: 2, y: 2)  // масштаб/поворот
}
```

---

### Урок 11 — Звуки

#### AVFoundation — воспроизведение звуков

`AVFoundation` — это фреймворк Apple для работы со звуком и видео.

**Шаг 1:** Добавь звуковой файл (`.mp3` или `.wav`) в папку проекта в Xcode.

**Шаг 2:** Импортируй и используй:

```swift
import AVFoundation

class ViewController: UIViewController {

    var audioPlayer: AVAudioPlayer?

    func playSound(named name: String) {
        // Найти файл в проекте
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            print("Файл \(name).mp3 не найден!")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Ошибка воспроизведения: \(error)")
        }
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        playSound(named: "click")
    }
}
```

#### Управление воспроизведением

```swift
audioPlayer?.play()     // играть
audioPlayer?.pause()    // пауза
audioPlayer?.stop()     // стоп

audioPlayer?.volume = 0.5         // громкость от 0.0 до 1.0
audioPlayer?.numberOfLoops = -1   // -1 = зациклить бесконечно
audioPlayer?.numberOfLoops = 2    // повторить 2 раза
```

---

### Урок 12 — Жесты и касания

#### UIGestureRecognizer

Жест — это распознаватель касаний. Добавляешь его к любому элементу, и он сообщает когда пользователь сделал нужный жест.

#### Основные жесты

```swift
// TAP — одиночное нажатие
let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
tap.numberOfTapsRequired = 1    // сколько нажатий
view.addGestureRecognizer(tap)

@objc func handleTap(_ gesture: UITapGestureRecognizer) {
    let point = gesture.location(in: view)   // координаты нажатия
    print("Нажатие в точке \(point)")
}

// SWIPE — свайп
let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
swipe.direction = .left    // .left .right .up .down
view.addGestureRecognizer(swipe)

@objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
    print("Свайп влево!")
}

// LONG PRESS — долгое нажатие
let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
longPress.minimumPressDuration = 0.5   // секунд
view.addGestureRecognizer(longPress)

@objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
    if gesture.state == .began {
        print("Долгое нажатие началось")
    }
}

// PINCH — щипок (масштаб двумя пальцами)
let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
view.addGestureRecognizer(pinch)

@objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
    imageView.transform = imageView.transform.scaledBy(x: gesture.scale, y: gesture.scale)
    gesture.scale = 1   // сбросить чтобы не накапливалось
}
```

---

## Блок 4 — Разработка игр SpriteKit

---

### Урок 13 — Первые спрайты

#### Как устроена игра на SpriteKit

```
Приложение
  └── GameViewController   ← обычный UIViewController
        └── SKView          ← "холст" для игры
              └── SKScene   ← игровой уровень (как сцена в Godot)
                    ├── SKSpriteNode  ← персонаж, враг, фон
                    ├── SKLabelNode   ← текст (счёт, надписи)
                    └── SKShapeNode   ← фигуры (круги, прямоугольники)
```

#### Сравнение с Godot

| Godot | SpriteKit | Что это |
|---|---|---|
| Scene (.tscn) | `SKScene` | Игровой уровень |
| Sprite2D | `SKSpriteNode` | Картинка / персонаж |
| Label | `SKLabelNode` | Текст на экране |
| ColorRect | `SKShapeNode` | Цветная фигура |
| `add_child()` | `addChild()` | Добавить объект |
| `_ready()` | `didMove(to:)` | При загрузке сцены |
| `_process()` | `update()` | Каждый кадр |
| `_input()` | `touchesBegan()` | При касании |

#### Координаты SpriteKit

В SpriteKit (0, 0) — **левый нижний** угол. Y растёт **вверх** (как в математике).

```
(0, высота) ──── (ширина, высота)   ← верхний край
      │                │
      │   (ширина/2, высота/2)      ← центр экрана
      │                │
   (0, 0) ──────── (ширина, 0)     ← нижний край ← тут (0,0)!
```

#### SKScene — главный класс

```swift
class GameScene: SKScene {

    // Вызывается ОДИН РАЗ когда сцена загрузилась
    override func didMove(to view: SKView) {
        // создаём объекты здесь
    }

    // Вызывается при каждом касании
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)   // координаты касания
    }

    // Вызывается 60 раз в секунду
    override func update(_ currentTime: TimeInterval) {
        // логика каждого кадра
    }
}
```

#### SKSpriteNode — спрайт

```swift
// Из картинки (файл добавлен в Assets.xcassets)
let hero = SKSpriteNode(imageNamed: "hero")

// Из цвета (когда нет картинки)
let box = SKSpriteNode(color: .red, size: CGSize(width: 60, height: 60))

// Основные свойства
hero.position  = CGPoint(x: 200, y: 300)    // позиция
hero.size      = CGSize(width: 80, height: 80) // размер
hero.zPosition = 1                            // слой (выше = поверх)
hero.alpha     = 0.5                          // прозрачность (0–1)
hero.zRotation = 0.3                          // поворот в радианах
hero.setScale(2.0)                            // масштаб
hero.xScale    = -1                           // зеркальное отражение

// Добавить на сцену — обязательно!
addChild(hero)

// Удалить со сцены
hero.removeFromParent()
```

#### SKLabelNode — текст

```swift
let label = SKLabelNode(fontNamed: "Helvetica-Bold")
label.text      = "Счёт: 0"
label.fontSize  = 24
label.fontColor = .white
label.position  = CGPoint(x: size.width / 2, y: size.height - 60)
label.horizontalAlignmentMode = .center   // .left .right .center
addChild(label)

// Изменить текст позже
label.text = "Счёт: \(score)"
```

#### SKShapeNode — фигуры

```swift
// Круг
let circle = SKShapeNode(circleOfRadius: 30)
circle.fillColor   = .red
circle.strokeColor = .white    // цвет обводки
circle.lineWidth   = 2
circle.position    = CGPoint(x: 100, y: 200)
addChild(circle)

// Прямоугольник
let rect = SKShapeNode(rectOf: CGSize(width: 100, height: 60))
rect.fillColor   = .blue
rect.strokeColor = .clear      // без обводки
addChild(rect)

// Прямоугольник с закруглёнными углами
let rounded = SKShapeNode(rectOf: CGSize(width: 100, height: 60), cornerRadius: 12)
rounded.fillColor = .green
addChild(rounded)
```

#### zPosition — кто поверх кого

```swift
background.zPosition = 0    // фон — самый нижний
enemy.zPosition      = 1    // враги поверх фона
hero.zPosition       = 2    // герой поверх врагов
scoreLabel.zPosition = 10   // интерфейс всегда сверху
```

---

### Урок 14 — Движение и анимация спрайтов

#### SKAction — действия

`SKAction` — это команда что должен сделать спрайт. Можно двигаться, вращаться, менять размер, проигрывать звук.

```swift
// Переместить в точку за 1 секунду
let move = SKAction.move(to: CGPoint(x: 300, y: 400), duration: 1.0)

// Переместить на расстояние (относительно текущей позиции)
let moveBy = SKAction.moveBy(x: 100, y: 0, duration: 0.5)

// Вращение на угол
let rotate = SKAction.rotate(byAngle: .pi, duration: 1.0)   // 180°

// Масштаб
let grow   = SKAction.scale(to: 2.0, duration: 0.3)
let shrink = SKAction.scale(to: 0.5, duration: 0.3)

// Исчезновение / появление
let fadeOut = SKAction.fadeOut(withDuration: 0.5)
let fadeIn  = SKAction.fadeIn(withDuration: 0.5)

// Пауза
let wait = SKAction.wait(forDuration: 1.0)

// Удалить спрайт со сцены
let remove = SKAction.removeFromParent()

// Запустить действие
hero.run(move)
```

#### Комбинирование действий

```swift
// SEQUENCE — выполнить по очереди
let sequence = SKAction.sequence([
    SKAction.move(to: CGPoint(x: 300, y: 300), duration: 1.0),
    SKAction.wait(forDuration: 0.5),
    SKAction.move(to: CGPoint(x: 100, y: 100), duration: 1.0)
])
hero.run(sequence)

// GROUP — выполнить одновременно
let group = SKAction.group([
    SKAction.scale(to: 2.0, duration: 0.5),
    SKAction.rotate(byAngle: .pi, duration: 0.5),
    SKAction.fadeOut(withDuration: 0.5)
])
hero.run(group)

// REPEAT — повторить N раз
let repeated = SKAction.repeat(move, count: 3)
hero.run(repeated)

// REPEAT FOREVER — повторять бесконечно
let forever = SKAction.repeatForever(
    SKAction.sequence([
        SKAction.moveBy(x: 0, y: 20, duration: 0.5),
        SKAction.moveBy(x: 0, y: -20, duration: 0.5)
    ])
)
hero.run(forever)
```

#### Ключи действий — управление анимацией

```swift
// Запустить с ключом (именем)
hero.run(moveAction, withKey: "moving")

// Остановить по ключу
hero.removeAction(forKey: "moving")

// Остановить все действия
hero.removeAllActions()
```

#### Плавность движения (timingMode)

```swift
let move = SKAction.move(to: CGPoint(x: 300, y: 300), duration: 1.0)
move.timingMode = .easeInEaseOut  // плавное начало и конец
move.timingMode = .easeIn         // плавное начало, резкий конец
move.timingMode = .easeOut        // резкое начало, плавный конец
move.timingMode = .linear         // равномерно (по умолчанию)
```

---

### Урок 15 — Физика и столкновения

#### SKPhysicsBody — добавить физику

Когда добавляешь физическое тело — объект начинает подчиняться законам физики: падает, отскакивает, сталкивается.

```swift
// Физика в форме прямоугольника
hero.physicsBody = SKPhysicsBody(rectangleOf: hero.size)

// Физика в форме круга
ball.physicsBody = SKPhysicsBody(circleOfRadius: 25)

// Физика по контуру картинки (медленнее!)
hero.physicsBody = SKPhysicsBody(texture: hero.texture!, size: hero.size)
```

> **Важно — размер тела должен совпадать со спрайтом!** Частая ошибка: спрайт 50×50, а радиус тела ставят 50. Тогда невидимое физическое тело в два раза больше картинки и объект отскакивает «в воздухе», не долетая до других. Правило: для круга радиус = половина размера спрайта. Спрайт 50×50 → `circleOfRadius: 25`. Чтобы увидеть реальные границы тел, включи `view.showsPhysics = true` в GameViewController — они подсветятся синим.

#### Настройка физического тела

Каждое свойство влияет на поведение объекта. Вот что делает каждое:

```swift
let body = hero.physicsBody!

body.isDynamic     = true     // true = двигается физикой, false = стоит на месте (стены, пол, платформы)
body.affectedByGravity = true // падает ли вниз под действием гравитации
body.allowsRotation = false   // может ли крутиться при ударах (false — всегда «стоит прямо»)

body.friction    = 0.2        // трение о поверхности: 0 = скользкий лёд, 1 = липучка
body.restitution = 0.5        // упругость: 0 = падает как камень, 1 = скачет как супермяч
body.mass        = 1.0        // масса в кг — тяжёлые объекты труднее толкнуть
body.linearDamping  = 0.1     // «сопротивление воздуха» движению: 0 = летит вечно, 1 = быстро тормозит
body.angularDamping = 0.1     // то же для вращения

// Задать скорость напрямую (мгновенно)
hero.physicsBody?.velocity = CGVector(dx: 200, dy: 0)

// Применить импульс — резкий одиночный толчок (как удар по мячу)
hero.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 500))

// Применить силу — постоянное давление (как ветер, пока действует)
hero.physicsBody?.applyForce(CGVector(dx: 100, dy: 0))
```

> **impulse или force?** `applyImpulse` — это резкий удар один раз (прыжок, выстрел, толчок). `applyForce` — это давление которое действует пока ты его прикладываешь (двигатель ракеты, ветер). Для большинства игр нужен `applyImpulse`.

> **CGVector** — это стрелка с направлением. `dx` — насколько вправо (минус = влево), `dy` — насколько вверх (минус = вниз). `CGVector(dx: 0, dy: 500)` — толчок строго вверх.

#### Настройка гравитации сцены

```swift
override func didMove(to view: SKView) {
    // Изменить гравитацию (по умолчанию dy = -9.8)
    physicsWorld.gravity = CGVector(dx: 0, dy: -5)

    // Выключить гравитацию (для космоса, птиц-сверху)
    physicsWorld.gravity = CGVector(dx: 0, dy: 0)
}
```

#### Категории и обнаружение столкновений

Когда в игре много объектов, движку нужно понимать: какой из них герой, какой враг, какой стена. Для этого каждому объекту дают **категорию** — метку в виде числа.

Категории записывают в двоичном виде (`0b0001`) числами степени двойки — 1, 2, 4, 8, 16 и так далее. Почему именно так? Потому что такие числа можно комбинировать через оператор `|` и при этом их всегда можно «разобрать» обратно. Если бы мы использовали обычные 1, 2, 3, 4 — комбинация 1+2 дала бы 3, и движок не смог бы отличить «категория 3» от «категории 1 и 2 вместе».

```swift
// Определяем категории — каждая в 2 раза больше предыдущей
struct PhysicsCategory {
    static let hero:   UInt32 = 0b0001   // = 1
    static let enemy:  UInt32 = 0b0010   // = 2
    static let bullet: UInt32 = 0b0100   // = 4
    static let wall:   UInt32 = 0b1000   // = 8
}
```

У каждого физического тела есть **три разных маски** — их часто путают, поэтому запомни разницу:

| Маска | Отвечает на вопрос | Пример |
|---|---|---|
| `categoryBitMask` | «Кто я?» | герой = `hero` |
| `collisionBitMask` | «От кого я физически отталкиваюсь?» | герой отскакивает от стен |
| `contactTestBitMask` | «О касании с кем мне сообщить?» | сообщи когда коснусь врага |

```swift
// Назначаем маски герою
hero.physicsBody?.categoryBitMask    = PhysicsCategory.hero
hero.physicsBody?.collisionBitMask   = PhysicsCategory.wall     // отталкивается от стен
hero.physicsBody?.contactTestBitMask = PhysicsCategory.enemy    // сообщи о касании врага

enemy.physicsBody?.categoryBitMask   = PhysicsCategory.enemy
```

Разница между `collision` и `contactTest` важна:
- `collisionBitMask` — это **физика**. Объекты реально отталкиваются друг от друга, как настоящие предметы.
- `contactTestBitMask` — это **уведомление**. Движок просто говорит нам «эти двое коснулись», но физически они могут пройти сквозь друг друга.

**Сенсор** — это объект у которого `collisionBitMask = 0` (ни от кого не отталкивается), но есть `contactTestBitMask`. Пуля пролетает сквозь него, но мы получаем уведомление. Так делают невидимые триггеры — зоны которые что-то засчитывают.

#### Обработка столкновений — 3 шага

```swift
// ШАГ 1 — подключить протокол SKPhysicsContactDelegate
class GameScene: SKScene, SKPhysicsContactDelegate {

    override func didMove(to view: SKView) {
        // ШАГ 2 — назначить себя делегатом (без этого didBegin не вызовется!)
        physicsWorld.contactDelegate = self
    }

    // ШАГ 3 — этот метод вызывается автоматически при каждом касании
    func didBegin(_ contact: SKPhysicsContact) {
        // ...
    }
}
```

#### Почему bodyA и bodyB нужно сортировать

Когда два тела касаются, движок кладёт их в `contact.bodyA` и `contact.bodyB`. **Но порядок не гарантирован!** Иногда герой попадает в `bodyA`, иногда в `bodyB` — это зависит от того кто первый обнаружил касание.

Из-за этого наивный код часто не срабатывает:

```swift
// ❌ НЕНАДЁЖНО — сработает только если герой случайно попал в bodyA
func didBegin(_ contact: SKPhysicsContact) {
    let bodyA = contact.bodyA
    let bodyB = contact.bodyB

    if bodyA.categoryBitMask == PhysicsCategory.hero &&
       bodyB.categoryBitMask == PhysicsCategory.enemy {
        // Этот код пропустит половину столкновений!
    }
}
```

Чтобы всегда работало — мы **сортируем** тела: то у которого меньше `categoryBitMask`, кладём в `bodyA`. Поскольку у `hero` категория = 1, а у `enemy` = 2, после сортировки герой всегда окажется в `bodyA`. Так проверка становится предсказуемой:

```swift
// ✅ НАДЁЖНО — так мы пишем на уроках
func didBegin(_ contact: SKPhysicsContact) {
    // Сортируем: меньший categoryBitMask всегда попадает в bodyA
    let (bodyA, bodyB) = contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask
        ? (contact.bodyA, contact.bodyB)   // если A меньше B — оставляем как есть
        : (contact.bodyB, contact.bodyA)   // иначе — меняем местами

    // Теперь герой (категория 1) ГАРАНТИРОВАННО в bodyA
    if bodyA.categoryBitMask == PhysicsCategory.hero &&
       bodyB.categoryBitMask == PhysicsCategory.enemy {
        print("Герой столкнулся с врагом!")
        bodyB.node?.removeFromParent()   // удалить врага
    }
}
```

> **Как читать эту запись:** `условие ? A : B` — это тернарный оператор. Читается «если условие верно — взять A, иначе B». А `let (x, y) = (первое, второе)` — это распаковка кортежа, присваивание сразу двум переменным. Вместе они означают: «если A меньше B — положи их как есть, иначе поменяй местами».

> **Как получить сам объект:** `bodyA` — это физическое тело (`SKPhysicsBody`), а не спрайт. Чтобы добраться до спрайта, используй `bodyA.node` — это вернёт `SKNode` к которому прикреплено тело. Пример: `bodyB.node?.removeFromParent()` удаляет спрайт врага со сцены.

#### Защита от повторного срабатывания

`didBegin` может вызваться дважды за один кадр (например пуля коснулась двух краёв врага). Поэтому перед удалением всегда проверяй что объект ещё на сцене:

```swift
func bulletHitEnemy(bullet: SKNode?, enemy: SKNode?) {
    guard let bullet = bullet, let enemy = enemy else { return }
    // Если уже удалены — выходим, чтобы не начислить очки дважды
    guard bullet.parent != nil, enemy.parent != nil else { return }

    bullet.removeFromParent()
    enemy.removeFromParent()
    score += 1
}
```

---

### Урок 16 — Управление игроком

#### Касания в SpriteKit

```swift
// Одно касание — переместить персонажа
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    hero.position = location   // мгновенно
}

// Касание движется — тянуть персонажа
override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    hero.position = location
}

// Касание закончилось
override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    print("Палец убрали")
}
```

#### Плавное движение к точке касания

```swift
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)

    // Считаем расстояние для постоянной скорости
    let dx = location.x - hero.position.x
    let dy = location.y - hero.position.y
    let distance = sqrt(dx * dx + dy * dy)

    let speed: CGFloat = 300   // пикселей в секунду
    let duration = TimeInterval(distance / speed)

    let move = SKAction.move(to: location, duration: duration)
    move.timingMode = .easeInEaseOut

    hero.removeAction(forKey: "move")
    hero.run(move, withKey: "move")
}
```

#### Кнопки на экране игры

```swift
func addButton(name: String, text: String, position: CGPoint) {
    let button = SKShapeNode(rectOf: CGSize(width: 80, height: 50), cornerRadius: 10)
    button.fillColor = SKColor(white: 0.2, alpha: 0.8)
    button.strokeColor = .white
    button.position = position
    button.name = name      // имя — по нему определяем нажатие
    button.zPosition = 10
    addChild(button)

    let label = SKLabelNode(fontNamed: "Helvetica-Bold")
    label.text = text
    label.fontSize = 18
    label.fontColor = .white
    label.verticalAlignmentMode = .center
    button.addChild(label)
}

override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let nodes = self.nodes(at: location)   // все объекты в этой точке

    for node in nodes {
        if node.name == "fireButton" {
            shoot()
        }
        if node.name == "leftButton" {
            moveLeft()
        }
    }
}
```

---

### Урок 17 — Враги, счёт и жизни

#### Генерация врагов

```swift
func spawnEnemy() {
    let enemy = SKSpriteNode(color: .red, size: CGSize(width: 40, height: 40))

    // Случайная позиция по X, сверху экрана
    let randomX = CGFloat.random(in: 40...(size.width - 40))
    enemy.position = CGPoint(x: randomX, y: size.height + 20)
    enemy.name = "enemy"
    addChild(enemy)

    // Летит вниз
    let moveDown = SKAction.moveTo(y: -50, duration: 2.0)
    let remove   = SKAction.removeFromParent()
    enemy.run(SKAction.sequence([moveDown, remove]))
}

// Запускать каждые 1.5 секунды
func startSpawning() {
    let wait  = SKAction.wait(forDuration: 1.5)
    let spawn = SKAction.run { self.spawnEnemy() }
    let loop  = SKAction.repeatForever(SKAction.sequence([wait, spawn]))
    run(loop)
}
```

#### Счёт

```swift
var score = 0
var scoreLabel: SKLabelNode!

func setupScore() {
    scoreLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
    scoreLabel.text = "0"
    scoreLabel.fontSize = 28
    scoreLabel.fontColor = .white
    scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 60)
    scoreLabel.zPosition = 10
    addChild(scoreLabel)
}

func addScore(_ points: Int) {
    score += points
    scoreLabel.text = "\(score)"

    // Небольшая анимация при добавлении очков
    let grow   = SKAction.scale(to: 1.3, duration: 0.1)
    let shrink = SKAction.scale(to: 1.0, duration: 0.1)
    scoreLabel.run(SKAction.sequence([grow, shrink]))
}
```

#### Жизни

```swift
var lives = 3
var livesLabel: SKLabelNode!

func setupLives() {
    livesLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
    livesLabel.fontSize = 24
    livesLabel.fontColor = .red
    livesLabel.position = CGPoint(x: 60, y: size.height - 60)
    livesLabel.zPosition = 10
    updateLivesLabel()
    addChild(livesLabel)
}

func updateLivesLabel() {
    livesLabel.text = String(repeating: "❤️", count: lives)
}

func loseLife() {
    lives -= 1
    updateLivesLabel()

    if lives <= 0 {
        gameOver()
    }
}
```

#### Game Over

```swift
func gameOver() {
    // Остановить спавн врагов
    removeAllActions()

    // Показать надпись
    let gameOverLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
    gameOverLabel.text = "GAME OVER"
    gameOverLabel.fontSize = 48
    gameOverLabel.fontColor = .red
    gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
    gameOverLabel.zPosition = 20
    addChild(gameOverLabel)

    // Через 2 секунды перезапустить
    let wait    = SKAction.wait(forDuration: 2.0)
    let restart = SKAction.run {
        let newScene = GameScene(size: self.size)
        self.view?.presentScene(newScene, transition: .fade(withDuration: 0.5))
    }
    run(SKAction.sequence([wait, restart]))
}
```

---

### Урок 18 — Звуки и частицы в игре

#### Звуки в SpriteKit

```swift
// Простой способ — SKAction (файл должен быть в проекте)
hero.run(SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false))

// Несколько звуков заранее
func setupSounds() {
    let shootSound   = SKAction.playSoundFileNamed("shoot.wav",   waitForCompletion: false)
    let hitSound     = SKAction.playSoundFileNamed("hit.wav",     waitForCompletion: false)
    let bonusSound   = SKAction.playSoundFileNamed("bonus.wav",   waitForCompletion: false)
}
```

#### SKEmitterNode — частицы

Частицы — это маленькие объекты которые летят из одной точки: взрывы, огонь, дым, звёзды.

**Шаг 1:** Создать файл частиц в Xcode:
`File → New → File → SpriteKit Particle File`
Выбрать шаблон: `Fire`, `Smoke`, `Spark`, `Rain`, `Snow` и т.д.
Назвать, например `Explosion.sks`.

**Шаг 2:** Использовать в коде:

```swift
func showExplosion(at position: CGPoint) {
    // Загрузить систему частиц из файла
    guard let explosion = SKEmitterNode(fileNamed: "Explosion") else { return }
    explosion.position = position
    explosion.zPosition = 5
    addChild(explosion)

    // Удалить через 1 секунду
    let wait   = SKAction.wait(forDuration: 1.0)
    let remove = SKAction.removeFromParent()
    explosion.run(SKAction.sequence([wait, remove]))
}
```

#### Параметры частиц в редакторе Xcode

| Параметр | Что делает |
|---|---|
| Birthrate | Сколько частиц создаётся в секунду |
| Lifetime | Сколько живёт каждая частица (секунды) |
| Speed | Скорость полёта частиц |
| Emission Angle | Направление полёта |
| Scale | Размер частиц |
| Color Blend | Цвет частиц |
| Alpha | Прозрачность |

---

### Урок 19 — Рекорды и меню

#### Сохранение рекорда в игре

```swift
func saveHighScore() {
    let currentBest = UserDefaults.standard.integer(forKey: "highScore")
    if score > currentBest {
        UserDefaults.standard.set(score, forKey: "highScore")
    }
}

func loadHighScore() -> Int {
    return UserDefaults.standard.integer(forKey: "highScore")
}
```

#### Несколько сцен — меню и игра

```swift
// MenuScene.swift — главное меню
class MenuScene: SKScene {

    override func didMove(to view: SKView) {
        backgroundColor = .black

        let title = SKLabelNode(fontNamed: "Helvetica-Bold")
        title.text = "МОЯ ИГРА"
        title.fontSize = 48
        title.fontColor = .white
        title.position = CGPoint(x: size.width / 2, y: size.height * 0.65)
        addChild(title)

        let best = UserDefaults.standard.integer(forKey: "highScore")
        let bestLabel = SKLabelNode(fontNamed: "Helvetica")
        bestLabel.text = "Рекорд: \(best)"
        bestLabel.fontSize = 24
        bestLabel.fontColor = .yellow
        bestLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.5)
        addChild(bestLabel)

        let playButton = SKLabelNode(fontNamed: "Helvetica-Bold")
        playButton.text = "▶  ИГРАТЬ"
        playButton.fontSize = 32
        playButton.fontColor = .green
        playButton.position = CGPoint(x: size.width / 2, y: size.height * 0.35)
        playButton.name = "playButton"
        addChild(playButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        if let node = nodes(at: location).first, node.name == "playButton" {
            startGame()
        }
    }

    func startGame() {
        let gameScene = GameScene(size: self.size)
        let transition = SKTransition.fade(withDuration: 0.5)
        view?.presentScene(gameScene, transition: transition)
    }
}
```

#### Переходы между сценами

```swift
// Из игры обратно в меню
func goToMenu() {
    let menu = MenuScene(size: self.size)
    let transition = SKTransition.fade(withDuration: 0.5)
    view?.presentScene(menu, transition: transition)
}
```

#### Виды переходов

```swift
SKTransition.fade(withDuration: 0.5)              // затухание
SKTransition.crossFade(withDuration: 0.5)         // перекрёстное затухание
SKTransition.flipHorizontal(withDuration: 0.5)    // переворот по горизонтали
SKTransition.moveIn(with: .left, duration: 0.3)   // въезжает слева
SKTransition.push(with: .left, duration: 0.3)     // толкает влево
SKTransition.reveal(with: .down, duration: 0.3)   // открывается вниз
SKTransition.doorway(withDuration: 0.5)           // как дверь
```

---

## Блок 5 — SwiftUI

---

### Урок 22 — Основы SwiftUI

#### Чем SwiftUI отличается от UIKit?

| UIKit | SwiftUI |
|---|---|
| Storyboard + код | Только код |
| Изменяешь элементы вручную | Экран сам обновляется при изменении данных |
| Старый подход | Современный (с 2019 года) |
| `UILabel`, `UIButton` | `Text`, `Button` |
| Сложнее, но гибче | Проще, меньше кода |

#### Основные элементы

```swift
import SwiftUI

// Текст
Text("Привет, мир!")
    .font(.title)
    .foregroundColor(.blue)
    .bold()

// Кнопка
Button("Нажми меня") {
    print("Нажато!")
}
.padding()
.background(Color.blue)
.foregroundColor(.white)
.cornerRadius(10)

// Картинка (из Assets)
Image("hero")
    .resizable()
    .frame(width: 100, height: 100)

// Системная иконка SF Symbols
Image(systemName: "star.fill")
    .foregroundColor(.yellow)
```

#### Стопки (Stack) — расположение элементов

```swift
// VStack — вертикально (сверху вниз)
VStack(spacing: 10) {
    Text("Первый")
    Text("Второй")
    Text("Третий")
}

// HStack — горизонтально (слева направо)
HStack(spacing: 20) {
    Image(systemName: "heart.fill")
    Text("Нравится")
}

// ZStack — слоями (один поверх другого)
ZStack {
    Color.blue           // фон
    Text("Поверх фона")  // текст поверх
}
```

#### @State — данные которые меняются

`@State` — это переменная, при изменении которой экран автоматически обновляется.

```swift
struct ContentView: View {

    @State var score = 0          // @State — SwiftUI следит за этой переменной
    @State var name = "Игрок"

    var body: some View {
        VStack(spacing: 20) {
            Text("Счёт: \(score)")
                .font(.largeTitle)

            Button("+ 10 очков") {
                score += 10       // изменили — экран сам обновился!
            }

            Button("Сбросить") {
                score = 0
            }
        }
    }
}
```

#### Полный пример — профиль героя

```swift
struct HeroProfileView: View {

    @State var level = 1
    @State var health = 100

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: "person.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.cyan)

                Text("Герой")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)

                HStack(spacing: 30) {
                    VStack {
                        Text("Уровень")
                            .foregroundColor(.gray)
                        Text("\(level)")
                            .font(.title.bold())
                            .foregroundColor(.yellow)
                    }
                    VStack {
                        Text("Здоровье")
                            .foregroundColor(.gray)
                        Text("\(health)")
                            .font(.title.bold())
                            .foregroundColor(.green)
                    }
                }

                Button("Прокачать") {
                    level += 1
                    health += 20
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 12)
                .background(Color.purple)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
        }
    }
}
```

---

### Урок 23 — Списки и данные

#### List — список в SwiftUI

```swift
struct GameListView: View {

    @State var games = ["Minecraft", "Roblox", "Among Us", "FIFA", "Fortnite"]

    var body: some View {
        NavigationView {
            List(games, id: \.self) { game in
                Text(game)
            }
            .navigationTitle("Мои игры")
        }
    }
}
```

#### ForEach — повторить элементы

```swift
// Из массива строк
ForEach(games, id: \.self) { game in
    Text(game)
}

// По диапазону чисел
ForEach(1...5, id: \.self) { number in
    Text("Уровень \(number)")
}
```

#### Добавление и удаление из списка

```swift
struct QuestListView: View {

    @State var quests = ["Найти меч", "Победить дракона", "Спасти принца"]
    @State var newQuest = ""

    var body: some View {
        VStack {
            // Поле ввода
            HStack {
                TextField("Новый квест...", text: $newQuest)
                    .textFieldStyle(.roundedBorder)

                Button("Добавить") {
                    if !newQuest.isEmpty {
                        quests.append(newQuest)
                        newQuest = ""
                    }
                }
            }
            .padding()

            // Список с удалением
            List {
                ForEach(quests, id: \.self) { quest in
                    Text(quest)
                }
                .onDelete { indexSet in
                    quests.remove(atOffsets: indexSet)
                }
            }
        }
    }
}
```

> **`$newQuest`** (со знаком `$`) — это двусторонняя связь. TextField читает значение из переменной И записывает обратно когда пользователь печатает.

---

### Урок 24 — Загрузка данных из сети

#### Что такое API и JSON?

**API** — это как окошко в кафе. Ты отправляешь запрос («хочу факт о кошках»), тебе отвечают данными.

**JSON** — формат данных, которым отвечает сервер. Выглядит как Swift-словарь:
```json
{ "fact": "Кошки спят 16 часов в сутки", "length": 31 }
```

#### Модель данных

```swift
// Описываем какие данные ждём от сервера
struct CatFact: Codable {
    let fact: String     // поле "fact" из JSON
    let length: Int      // поле "length" из JSON
}
```

#### Загрузка данных

```swift
func loadFact() async {
    // Адрес API
    guard let url = URL(string: "https://catfact.ninja/fact") else { return }

    do {
        // Загрузить данные
        let (data, _) = try await URLSession.shared.data(from: url)

        // Превратить JSON в нашу структуру
        let catFact = try JSONDecoder().decode(CatFact.self, from: data)

        // Обновить интерфейс (на главном потоке)
        await MainActor.run {
            self.fact = catFact.fact
        }
    } catch {
        print("Ошибка загрузки: \(error)")
    }
}
```

#### Полный пример — факты о кошках

```swift
struct CatFactsView: View {

    @State var fact = "Нажми кнопку чтобы узнать факт о кошках 🐱"
    @State var isLoading = false

    var body: some View {
        VStack(spacing: 30) {
            Text("🐱 Факты о кошках")
                .font(.title.bold())

            Text(fact)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color.orange.opacity(0.15))
                .cornerRadius(12)
                .padding(.horizontal)

            Button(isLoading ? "Загружаю..." : "Новый факт") {
                Task {
                    await loadFact()
                }
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 12)
            .background(isLoading ? Color.gray : Color.orange)
            .foregroundColor(.white)
            .cornerRadius(12)
            .disabled(isLoading)
        }
        .task {
            await loadFact()   // загрузить при открытии
        }
    }

    func loadFact() async {
        isLoading = true
        guard let url = URL(string: "https://catfact.ninja/fact") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let catFact = try JSONDecoder().decode(CatFact.self, from: data)
            await MainActor.run { fact = catFact.fact }
        } catch {
            await MainActor.run { fact = "Не удалось загрузить 😿" }
        }
        isLoading = false
    }
}

struct CatFact: Codable {
    let fact: String
    let length: Int
}
```

---

## Шпаргалки

---

### Цвета в Swift

#### Почему цвета в Swift выглядят странно?

В UIKit и SpriteKit цвет задаётся числами от **0.0 до 1.0**, а не от 0 до 255 как мы привыкли. Это называется нормализованные значения.

**Формула перевода:**
```
обычный RGB ÷ 255 = значение для Swift
```

Пример — тёмно-синий `rgb(13, 13, 51)`:
```
13  ÷ 255 = 0.05  → red:   0.05
13  ÷ 255 = 0.05  → green: 0.05
51  ÷ 255 = 0.2   → blue:  0.2

SKColor(red: 0.05, green: 0.05, blue: 0.2, alpha: 1.0)
```

> **Запомни:** 255 — это 100%. Swift хочет проценты (от 0.0 до 1.0) вместо чисел.

#### UIKit / SpriteKit — UIColor / SKColor

```swift
// Готовые системные цвета (проще всего)
.red  .green  .blue  .yellow  .orange  .purple
.white  .black  .gray  .clear

// Системные цвета — автоматически меняются в тёмной теме
UIColor.systemBlue
UIColor.systemGreen
UIColor.systemRed
UIColor.systemBackground   // белый в светлой / чёрный в тёмной
UIColor.label              // чёрный в светлой / белый в тёмной

// Свой цвет — числа от 0.0 до 1.0
UIColor(red: 0.3, green: 0.8, blue: 1.0, alpha: 1.0)
SKColor(red: 0.3, green: 0.8, blue: 1.0, alpha: 1.0)

// Быстрый способ записать привычные 0–255 (разделить прямо в коде)
UIColor(red: 76/255, green: 204/255, blue: 255/255, alpha: 1)
```

#### Расширение .rgb() — писать привычные числа 0–255

Добавь один раз в проект и больше не думай о делении на 255:

```swift
// Вставить под import SpriteKit в любом файле проекта
extension SKColor {
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> SKColor {
        return SKColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
}

// Использование — привычные числа!
backgroundColor = .rgb(13, 13, 51)
let heroColor   = SKColor.rgb(76, 204, 255)
let enemyColor  = SKColor.rgb(255, 76, 76)
let goldColor   = SKColor.rgb(255, 204, 0)
```

Аналогично для UIKit:
```swift
extension UIColor {
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
}

label.textColor = .rgb(255, 87, 34)
```

#### Расширение для HEX — копировать цвет из интернета или дизайнера

```swift
// Для SpriteKit
extension SKColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = CGFloat((int >> 16) & 0xFF) / 255
        let g = CGFloat((int >> 8)  & 0xFF) / 255
        let b = CGFloat(int         & 0xFF) / 255
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}

// Использование — берёшь HEX из Google, Figma, Photoshop
backgroundColor      = SKColor(hex: "#0D0D33")
let orange           = SKColor(hex: "FF5722")   // # можно не писать
let mint             = SKColor(hex: "#00C9A7")
```

#### SwiftUI — Color

```swift
// Готовые цвета
Color.red  Color.blue  Color.green
Color.primary    // адаптируется к теме
Color.secondary

// Системный UIColor внутри SwiftUI
Color(.systemBlue)

// Свой цвет — числа 0.0–1.0
Color(red: 0.3, green: 0.8, blue: 1.0)

// Свой цвет через разделение
Color(red: 76/255, green: 204/255, blue: 255/255)

// HEX в SwiftUI (встроено начиная с iOS 17)
Color(hex: "#FF5722")   // только iOS 17+
```



---

### Частые ошибки

| Ошибка | Где | Причина | Решение |
|---|---|---|---|
| `unexpectedly found nil while unwrapping` | UIKit, SpriteKit | Обращение к `nil` через `!` | Проверить IBOutlet, использовать `if let` |
| Экран чёрный | SpriteKit | Сцена не загрузилась | Проверить `GameViewController` |
| Спрайт не виден | SpriteKit | Забыл `addChild()` или не та позиция | Добавить `addChild`, проверить координаты |
| Таблица пустая | UIKit | Не назначен `dataSource` | `tableView.dataSource = self` |
| Краш при `addChild` | SpriteKit | Объект уже добавлен | Проверить `if node.parent == nil` |
| Звук не играет | AVFoundation | Файл не добавлен в проект | Перетащить файл в Xcode |
| `@State` не обновляет UI | SwiftUI | Забыл `@State` | Добавить `@State` к переменной |
| Данные не сохранились | UserDefaults | Неправильный ключ | Проверить что ключи совпадают при save и load |ч