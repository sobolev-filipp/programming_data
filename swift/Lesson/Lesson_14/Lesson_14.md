# Урок 14 — Движение и анимация спрайтов
**Полный план для учителя · 45 минут · Возраст 12 лет**

---

## Цель урока

Ребёнок понимает как работают `SKAction` — действия в SpriteKit. Умеет двигать, вращать, масштабировать спрайты, комбинировать действия и запускать их по очереди и одновременно. Делает проект «Летящий астероид».

---

## Таймлайн урока

| Время | Что делаем |
|---|---|
| 0–5 мин | Разминка — вспоминаем прошлый урок |
| 5–20 мин | Теория: SKAction и все его виды |
| 20–40 мин | Пишем проект «Летящий астероид» |
| 40–45 мин | Запускаем, объясняем домашнее задание |

---

## Часть 1 — Разминка (5 минут)

**Спроси ребёнка:**
- Как называется главный класс игровой сцены? (`SKScene`)
- Какой метод вызывается при загрузке сцены? (`didMove`)
- Как добавить объект на сцену? (`addChild`)
- Чем отличаются координаты SpriteKit от UIKit? (0,0 внизу слева, Y вверх)
- Покажи домашнее задание — посмотри как написал функцию `addEnemy`

---

## Часть 2 — Теория: SKAction (15 минут)

### Что такое SKAction?

`SKAction` — это команда «что сделать» спрайту. Ты создаёшь действие и запускаешь его на спрайте через `.run()`.

> **Аналогия с Godot:** SKAction — это как `Tween` в Godot. Ты говоришь: «за 1 секунду переместись вот сюда» — и объект плавно перемещается.

```swift
// Создать действие
let moveAction = SKAction.move(to: CGPoint(x: 300, y: 400), duration: 1.0)

// Запустить на спрайте
hero.run(moveAction)
```

---

### Основные действия — одно за раз

```swift
// --- ДВИЖЕНИЕ ---

// Переместить в точку (абсолютно)
let moveTo = SKAction.move(to: CGPoint(x: 300, y: 400), duration: 1.0)

// Переместить на расстояние (относительно текущего положения)
let moveBy = SKAction.moveBy(x: 100, y: 0, duration: 0.5)  // сдвинуть вправо на 100

// Только по одной оси
let moveX = SKAction.moveTo(x: 300, duration: 1.0)
let moveY = SKAction.moveTo(y: 100, duration: 1.0)

// --- ВРАЩЕНИЕ ---

// Повернуть на угол (в радианах, относительно текущего)
let rotate = SKAction.rotate(byAngle: .pi, duration: 1.0)    // 180° по часовой
let rotate2 = SKAction.rotate(byAngle: -.pi / 2, duration: 0.5) // 90° против часовой

// Повернуть до конкретного угла
let rotateTo = SKAction.rotate(toAngle: .pi / 4, duration: 1.0)

// --- МАСШТАБ ---

// Изменить масштаб
let grow   = SKAction.scale(to: 2.0, duration: 0.5)    // увеличить в 2 раза
let shrink = SKAction.scale(to: 0.5, duration: 0.5)    // уменьшить в 2 раза
let scaleXY = SKAction.scaleX(to: 2.0, duration: 0.5) // только по X

// --- ПРОЗРАЧНОСТЬ ---

// Исчезнуть / появиться
let fadeOut = SKAction.fadeOut(withDuration: 0.5)
let fadeIn  = SKAction.fadeIn(withDuration: 0.5)

// Установить конкретную прозрачность
let halfAlpha = SKAction.fadeAlpha(to: 0.5, duration: 0.3)

// --- ПАУЗА ---

// Подождать указанное время
let wait = SKAction.wait(forDuration: 1.0)

// Подождать случайное время (min...max)
let randomWait = SKAction.wait(forDuration: 1.0, withRange: 0.5)
// ждёт от 0.75 до 1.25 секунды

// --- УДАЛИТЬ ---

// Удалить спрайт со сцены
let remove = SKAction.removeFromParent()

// --- ЗАПУСТИТЬ КОД ---

// Выполнить любой код как действие
let doSomething = SKAction.run {
    print("Действие выполнено!")
    self.score += 1
}
```

---

### Углы в радианах — как объяснить ребёнку

Swift использует радианы, а не градусы. Это пугает, но запомнить просто:

| Градусы | Радианы | Запись в Swift |
|---|---|---|
| 360° | 2π | `.pi * 2` |
| 180° | π | `.pi` |
| 90° | π/2 | `.pi / 2` |
| 45° | π/4 | `.pi / 4` |

```swift
// Если проще думать в градусах — сделай функцию:
func toRadians(_ degrees: Double) -> CGFloat {
    return CGFloat(degrees * .pi / 180)
}

// Использование:
let rotate = SKAction.rotate(byAngle: toRadians(90), duration: 1.0)
```

> **Объясни ребёнку:** «π (пи) = 3.14. Полный круг = 2 × π. Половина круга = π. Четверть = π/2. Просто запомни эти три числа».

---

### Комбинирование действий — самое важное!

#### sequence — по очереди

```swift
// Сначала одно, потом другое, потом ещё
let sequence = SKAction.sequence([
    SKAction.move(to: CGPoint(x: 300, y: 400), duration: 1.0),  // сначала переместиться
    SKAction.wait(forDuration: 0.5),                             // подождать
    SKAction.scale(to: 0.0, duration: 0.3),                     // уменьшиться до нуля
    SKAction.removeFromParent()                                   // исчезнуть
])
hero.run(sequence)
```

#### group — одновременно

```swift
// Всё происходит в одно и то же время
let group = SKAction.group([
    SKAction.scale(to: 2.0, duration: 0.5),              // растёт
    SKAction.rotate(byAngle: .pi, duration: 0.5),         // вращается
    SKAction.fadeOut(withDuration: 0.5)                   // исчезает
])
hero.run(group)
// Результат: спрайт одновременно растёт, крутится и исчезает
```

#### repeat — повторить N раз

```swift
let bounce = SKAction.sequence([
    SKAction.moveBy(x: 0, y: 30, duration: 0.3),
    SKAction.moveBy(x: 0, y: -30, duration: 0.3)
])

// Повторить 5 раз
hero.run(SKAction.repeat(bounce, count: 5))
```

#### repeatForever — повторять бесконечно

```swift
// Бесконечное вращение
let spinForever = SKAction.repeatForever(
    SKAction.rotate(byAngle: .pi * 2, duration: 2.0)
)
asteroid.run(spinForever)

// Бесконечное покачивание
let bob = SKAction.repeatForever(SKAction.sequence([
    SKAction.moveBy(x: 0, y: 15, duration: 0.8),
    SKAction.moveBy(x: 0, y: -15, duration: 0.8)
]))
hero.run(bob)
```

---

### Ключи — управление действиями

```swift
// Запустить с ключом (именем)
asteroid.run(spinForever, withKey: "spin")
hero.run(moveAction, withKey: "move")

// Остановить конкретное действие
asteroid.removeAction(forKey: "spin")

// Остановить все действия
asteroid.removeAllActions()

// Проверить — выполняется ли действие с ключом
if hero.action(forKey: "move") != nil {
    print("Герой сейчас движется")
}
```

> **Зачем нужны ключи?** Без ключа нельзя остановить конкретное действие. С ключом — можно. Например: герой двигается, игрок нажал в новое место — останавливаем старое движение и запускаем новое.

---

### Плавность (timingMode)

```swift
let move = SKAction.move(to: CGPoint(x: 300, y: 300), duration: 1.0)

move.timingMode = .linear        // равномерно (по умолчанию)
move.timingMode = .easeIn        // медленно разгоняется, резко заканчивает
move.timingMode = .easeOut       // резко начинает, плавно останавливается
move.timingMode = .easeInEaseOut // плавно начинает и заканчивает (самое красивое)
```

> **Аналогия:** easeInEaseOut — как автомобиль: плавно трогается и плавно тормозит.

---

### Скорость действия

```swift
// speed — множитель скорости (1.0 = нормально, 2.0 = вдвое быстрее)
asteroid.speed = 2.0   // все действия на спрайте в 2 раза быстрее
asteroid.speed = 0.5   // в 2 раза медленнее
asteroid.speed = 0.0   // полная пауза
```

---

## Часть 3 — Проект «Летящий астероид» (20 минут)

### Что делает проект

- Космический фон со звёздами (из урока 13 — повторение)
- Астероид появляется за правым краем экрана
- Летит влево через весь экран и бесконечно вращается
- Когда вылетает за левый край — появляется снова справа
- Каждый раз астероид летит по новой случайной высоте
- При нажатии на астероид — он «взрывается»: вырастает и исчезает

---

### Шаг 1 — Создать проект

Создаём новый проект **или** продолжаем проект с урока 13 (если хочет ребёнок).

Если новый:
```
File → New → Project → iOS → Game → SpaceAsteroid
```

Заменить `GameViewController.swift` (как в уроке 13) и очистить `GameScene.swift`.

---

### Шаг 2 — Скелет и фон

```swift
import SpriteKit

class GameScene: SKScene {

    var asteroid: SKSpriteNode!

    override func didMove(to view: SKView) {
        setupBackground()
        setupAsteroid()
        startFlying()
    }

    func setupBackground() {
        backgroundColor = .rgb(8, 8, 30)

        for _ in 0..<100 {
            let star = SKShapeNode(circleOfRadius: CGFloat.random(in: 0.5...2.5))
            star.fillColor = .white
            star.strokeColor = .clear
            star.alpha = CGFloat.random(in: 0.2...1.0)
            star.position = CGPoint(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: 0...size.height)
            )
            addChild(star)
        }
    }
}

// Расширение для удобных RGB цветов
extension SKColor {
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> SKColor {
        return SKColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
}
```

▶ **Запустить** — тёмный фон со звёздами.

---

### Шаг 3 — Создаём астероид

```swift
func setupAsteroid() {
    // Рисуем астероид из фигур (без картинки)
    asteroid = SKSpriteNode(color: .clear, size: CGSize(width: 60, height: 60))

    // Неровный серый камень — несколько кругов разного размера
    let body = SKShapeNode(circleOfRadius: 28)
    body.fillColor = .rgb(140, 120, 100)
    body.strokeColor = .rgb(80, 65, 55)
    body.lineWidth = 2
    asteroid.addChild(body)

    // Кратеры
    let crater1 = SKShapeNode(circleOfRadius: 8)
    crater1.fillColor = .rgb(100, 85, 70)
    crater1.strokeColor = .clear
    crater1.position = CGPoint(x: -10, y: 8)
    asteroid.addChild(crater1)

    let crater2 = SKShapeNode(circleOfRadius: 5)
    crater2.fillColor = .rgb(100, 85, 70)
    crater2.strokeColor = .clear
    crater2.position = CGPoint(x: 12, y: -10)
    asteroid.addChild(crater2)

    let crater3 = SKShapeNode(circleOfRadius: 4)
    crater3.fillColor = .rgb(100, 85, 70)
    crater3.strokeColor = .clear
    crater3.position = CGPoint(x: -5, y: -15)
    asteroid.addChild(crater3)

    // Стартовая позиция — за правым краем экрана
    asteroid.position = CGPoint(x: size.width + 50, y: size.height / 2)
    asteroid.name = "asteroid"
    addChild(asteroid)
}
```

▶ **Запустить** — астероид должен появиться справа за экраном (не виден). Проверим позже когда полетит.

---

### Шаг 4 — Запускаем полёт и вращение

```swift
func startFlying() {
    flyAcrossScreen()
    spinAsteroid()
}

func spinAsteroid() {
    // Бесконечное вращение — repeatForever + rotate
    let spin = SKAction.repeatForever(
        SKAction.rotate(byAngle: .pi * 2, duration: 3.0)  // полный оборот за 3 сек
    )
    asteroid.run(spin, withKey: "spin")
}

func flyAcrossScreen() {
    // Случайная высота для этого пролёта
    let randomY = CGFloat.random(in: 80...(size.height - 80))

    // Сначала поставить за правый край
    asteroid.position = CGPoint(x: size.width + 50, y: randomY)

    // Лететь к левому краю за 3–5 секунд
    let duration = Double.random(in: 3.0...5.0)
    let fly = SKAction.moveTo(x: -50, duration: duration)

    // Когда долетел — запустить снова
    let reset = SKAction.run {
        self.flyAcrossScreen()
    }

    asteroid.run(SKAction.sequence([fly, reset]), withKey: "fly")
}
```

▶ **Запустить** — астероид должен лететь справа налево, крутиться, и каждый раз появляться на новой высоте.

> **Объясни ребёнку:** `SKAction.run {}` — это action который выполняет любой наш код. Мы используем его чтобы снова вызвать `flyAcrossScreen()` когда астероид улетел.

---

### Шаг 5 — Нажатие на астероид — «взрыв»

```swift
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)

    // Проверяем — попали ли в астероид
    let tappedNodes = nodes(at: location)

    for node in tappedNodes {
        if node.name == "asteroid" || node.parent?.name == "asteroid" {
            explodeAsteroid()
            break
        }
    }
}

func explodeAsteroid() {
    // Останавливаем полёт
    asteroid.removeAction(forKey: "fly")

    // Анимация взрыва: вырасти и исчезнуть
    let grow    = SKAction.scale(to: 3.0, duration: 0.15)
    let fadeOut = SKAction.fadeOut(withDuration: 0.3)
    let explode = SKAction.group([grow, fadeOut])

    // После взрыва — вернуть астероид и запустить снова
    let reset = SKAction.run {
        self.asteroid.setScale(1.0)
        self.asteroid.alpha = 1.0
        self.flyAcrossScreen()
    }

    asteroid.run(SKAction.sequence([explode, reset]))
}
```

▶ **Запустить** — при нажатии на астероид он должен вспыхнуть и появиться снова.

> **Объясни ребёнку:** `node.parent?.name == "asteroid"` — потому что кратеры это дочерние объекты астероида. Если нажать на кратер — `node` это кратер, а не сам астероид. Поэтому проверяем и родителя тоже.

---

### Шаг 6 — Счётчик взрывов и скорость

```swift
// Добавить в свойства класса:
var destroyCount = 0
var scoreLabel: SKLabelNode!
var asteroidSpeed = 4.0   // начальная скорость

// Добавить в didMove:
setupScoreLabel()

func setupScoreLabel() {
    scoreLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
    scoreLabel.text = "Уничтожено: 0"
    scoreLabel.fontSize = 22
    scoreLabel.fontColor = .white
    scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 60)
    scoreLabel.horizontalAlignmentMode = .center
    scoreLabel.zPosition = 10
    addChild(scoreLabel)
}

// В функцию explodeAsteroid добавить в начало:
func explodeAsteroid() {
    destroyCount += 1
    scoreLabel.text = "Уничтожено: \(destroyCount)"

    // Каждые 5 взрывов — ускоряем астероид
    if destroyCount % 5 == 0 {
        asteroidSpeed = max(1.5, asteroidSpeed - 0.5)
        showSpeedUpMessage()
    }

    // ... остальной код взрыва
}

func showSpeedUpMessage() {
    let msg = SKLabelNode(fontNamed: "Helvetica-Bold")
    msg.text = "БЫСТРЕЕ! 🔥"
    msg.fontSize = 32
    msg.fontColor = .rgb(255, 150, 0)
    msg.position = CGPoint(x: size.width / 2, y: size.height / 2)
    msg.zPosition = 20
    addChild(msg)

    let appear  = SKAction.scale(from: 0.5, to: 1.0, duration: 0.2)
    let wait    = SKAction.wait(forDuration: 0.8)
    let fadeOut = SKAction.fadeOut(withDuration: 0.4)
    let remove  = SKAction.removeFromParent()
    msg.run(SKAction.sequence([appear, wait, fadeOut, remove]))
}
```

▶ **Запустить** — при каждом уничтожении обновляется счёт, каждые 5 — астероид ускоряется.

---

### Полный код GameScene.swift

```swift
import SpriteKit

extension SKColor {
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> SKColor {
        return SKColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
}

class GameScene: SKScene {

    var asteroid: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var destroyCount = 0
    var asteroidSpeed = 4.0

    override func didMove(to view: SKView) {
        setupBackground()
        setupAsteroid()
        setupScoreLabel()
        startFlying()
    }

    // MARK: - Фон

    func setupBackground() {
        backgroundColor = .rgb(8, 8, 30)
        for _ in 0..<100 {
            let star = SKShapeNode(circleOfRadius: CGFloat.random(in: 0.5...2.5))
            star.fillColor = .white
            star.strokeColor = .clear
            star.alpha = CGFloat.random(in: 0.2...1.0)
            star.position = CGPoint(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: 0...size.height)
            )
            addChild(star)
        }
    }

    // MARK: - Астероид

    func setupAsteroid() {
        asteroid = SKSpriteNode(color: .clear, size: CGSize(width: 60, height: 60))

        let body = SKShapeNode(circleOfRadius: 28)
        body.fillColor = .rgb(140, 120, 100)
        body.strokeColor = .rgb(80, 65, 55)
        body.lineWidth = 2
        asteroid.addChild(body)

        let crater1 = SKShapeNode(circleOfRadius: 8)
        crater1.fillColor = .rgb(100, 85, 70)
        crater1.strokeColor = .clear
        crater1.position = CGPoint(x: -10, y: 8)
        asteroid.addChild(crater1)

        let crater2 = SKShapeNode(circleOfRadius: 5)
        crater2.fillColor = .rgb(100, 85, 70)
        crater2.strokeColor = .clear
        crater2.position = CGPoint(x: 12, y: -10)
        asteroid.addChild(crater2)

        let crater3 = SKShapeNode(circleOfRadius: 4)
        crater3.fillColor = .rgb(100, 85, 70)
        crater3.strokeColor = .clear
        crater3.position = CGPoint(x: -5, y: -15)
        asteroid.addChild(crater3)

        asteroid.position = CGPoint(x: size.width + 50, y: size.height / 2)
        asteroid.name = "asteroid"
        addChild(asteroid)
    }

    // MARK: - Счёт

    func setupScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        scoreLabel.text = "Уничтожено: 0"
        scoreLabel.fontSize = 22
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 60)
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.zPosition = 10
        addChild(scoreLabel)
    }

    // MARK: - Полёт

    func startFlying() {
        flyAcrossScreen()
        spinAsteroid()
    }

    func spinAsteroid() {
        let spin = SKAction.repeatForever(
            SKAction.rotate(byAngle: .pi * 2, duration: 3.0)
        )
        asteroid.run(spin, withKey: "spin")
    }

    func flyAcrossScreen() {
        let randomY = CGFloat.random(in: 80...(size.height - 80))
        asteroid.position = CGPoint(x: size.width + 50, y: randomY)

        let fly   = SKAction.moveTo(x: -50, duration: asteroidSpeed)
        let reset = SKAction.run { self.flyAcrossScreen() }
        asteroid.run(SKAction.sequence([fly, reset]), withKey: "fly")
    }

    // MARK: - Касание

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        for node in nodes(at: location) {
            if node.name == "asteroid" || node.parent?.name == "asteroid" {
                explodeAsteroid()
                break
            }
        }
    }

    // MARK: - Взрыв

    func explodeAsteroid() {
        destroyCount += 1
        scoreLabel.text = "Уничтожено: \(destroyCount)"

        if destroyCount % 5 == 0 {
            asteroidSpeed = max(1.5, asteroidSpeed - 0.5)
            showSpeedUpMessage()
        }

        asteroid.removeAction(forKey: "fly")

        let grow    = SKAction.scale(to: 3.0, duration: 0.15)
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        let explode = SKAction.group([grow, fadeOut])
        let reset   = SKAction.run {
            self.asteroid.setScale(1.0)
            self.asteroid.alpha = 1.0
            self.flyAcrossScreen()
        }

        asteroid.run(SKAction.sequence([explode, reset]))
    }

    // MARK: - Сообщение об ускорении

    func showSpeedUpMessage() {
        let msg = SKLabelNode(fontNamed: "Helvetica-Bold")
        msg.text = "БЫСТРЕЕ! 🔥"
        msg.fontSize = 32
        msg.fontColor = .rgb(255, 150, 0)
        msg.position = CGPoint(x: size.width / 2, y: size.height / 2)
        msg.zPosition = 20
        addChild(msg)

        let appear  = SKAction.scale(from: 0.5, to: 1.0, duration: 0.2)
        let wait    = SKAction.wait(forDuration: 0.8)
        let fadeOut = SKAction.fadeOut(withDuration: 0.4)
        let remove  = SKAction.removeFromParent()
        msg.run(SKAction.sequence([appear, wait, fadeOut, remove]))
    }
}
```

---

## Частые ошибки на этом уроке

| Ошибка | Причина | Решение |
|---|---|---|
| Астероид не двигается | Забыли вызвать `startFlying()` в `didMove` | Добавить вызов |
| Нажатие на астероид не срабатывает | Нажали на кратер а не на сам спрайт | Проверить `node.parent?.name` |
| Астероид исчезает после взрыва навсегда | Забыли сбросить `alpha` и `scale` в `reset` | Добавить `setScale(1.0)` и `alpha = 1.0` |
| Два действия с одним ключом | Второй `run(withKey:)` заменяет первый | Это нормально! Так и должно быть |
| Вращение останавливается при взрыве | `removeAllActions()` убивает и вращение | Использовать `removeAction(forKey:)` только для нужного |

---

## Домашнее задание

### Задание

Сделать несколько астероидов разного размера которые летят одновременно.

**Конкретно:**
1. Создать массив `var asteroids: [SKSpriteNode] = []`
2. Написать функцию `createAsteroid(size: CGFloat) -> SKSpriteNode` которая возвращает готовый астероид нужного размера
3. При старте создать **3 астероида** разного размера (40, 60, 80) и запустить каждый
4. При нажатии на любой астероид — он взрывается и появляется снова
5. ⭐ **Бонус:** маленькие астероиды летят быстрее, большие — медленнее

### Подсказка

```swift
// Создать несколько астероидов
func createAsteroid(size: CGFloat) -> SKSpriteNode {
    let asteroid = SKSpriteNode(color: .clear, size: CGSize(width: size, height: size))
    asteroid.name = "asteroid"

    let radius = size / 2 - 2
    let body = SKShapeNode(circleOfRadius: radius)
    body.fillColor = .rgb(140, 120, 100)
    body.strokeColor = .rgb(80, 65, 55)
    body.lineWidth = 2
    asteroid.addChild(body)

    return asteroid
}

// Запустить каждый со своей скоростью
for asteroid in asteroids {
    let speed = 60.0 / Double(asteroid.size.width)  // меньше = быстрее
    flyAsteroid(asteroid, duration: speed * 2)
}
```

### Решение (для учителя)

```swift
import SpriteKit

extension SKColor {
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> SKColor {
        return SKColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
}

class GameScene: SKScene {

    var asteroids: [SKSpriteNode] = []
    var scoreLabel: SKLabelNode!
    var destroyCount = 0

    override func didMove(to view: SKView) {
        setupBackground()
        setupScoreLabel()

        // Три астероида разного размера
        let sizes: [CGFloat] = [40, 60, 80]
        for size in sizes {
            let asteroid = createAsteroid(size: size)
            asteroids.append(asteroid)
            addChild(asteroid)
            flyAsteroid(asteroid)
            spinAsteroid(asteroid)
        }
    }

    func setupBackground() {
        backgroundColor = .rgb(8, 8, 30)
        for _ in 0..<100 {
            let star = SKShapeNode(circleOfRadius: CGFloat.random(in: 0.5...2.5))
            star.fillColor = .white
            star.strokeColor = .clear
            star.alpha = CGFloat.random(in: 0.2...1.0)
            star.position = CGPoint(
                x: CGFloat.random(in: 0...self.size.width),
                y: CGFloat.random(in: 0...self.size.height)
            )
            addChild(star)
        }
    }

    func setupScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        scoreLabel.text = "Уничтожено: 0"
        scoreLabel.fontSize = 22
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 60)
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.zPosition = 10
        addChild(scoreLabel)
    }

    func createAsteroid(size: CGFloat) -> SKSpriteNode {
        let asteroid = SKSpriteNode(color: .clear, size: CGSize(width: size, height: size))
        asteroid.name = "asteroid"

        let body = SKShapeNode(circleOfRadius: size / 2 - 2)
        body.fillColor = .rgb(CGFloat.random(in: 110...160),
                              CGFloat.random(in: 90...130),
                              CGFloat.random(in: 70...110))
        body.strokeColor = .rgb(70, 60, 50)
        body.lineWidth = 2
        asteroid.addChild(body)

        let craterR = size / 7
        let crater = SKShapeNode(circleOfRadius: craterR)
        crater.fillColor = .rgb(90, 75, 62)
        crater.strokeColor = .clear
        crater.position = CGPoint(x: -size * 0.2, y: size * 0.15)
        asteroid.addChild(crater)

        return asteroid
    }

    func spinAsteroid(_ asteroid: SKSpriteNode) {
        // Скорость вращения зависит от размера — большие крутятся медленнее
        let spinDuration = Double(asteroid.size.width) / 20.0
        let spin = SKAction.repeatForever(
            SKAction.rotate(byAngle: .pi * 2, duration: spinDuration)
        )
        asteroid.run(spin, withKey: "spin")
    }

    func flyAsteroid(_ asteroid: SKSpriteNode) {
        let randomY = CGFloat.random(in: 80...(size.height - 80))
        // Задержка чтобы не стартовали одновременно
        let delay = Double.random(in: 0...2.0)
        asteroid.position = CGPoint(x: size.width + 50, y: randomY)
        asteroid.alpha = 0

        let wait = SKAction.wait(forDuration: delay)
        let show = SKAction.fadeIn(withDuration: 0.3)

        // ⭐ Бонус — скорость зависит от размера
        let speed = Double(asteroid.size.width) / 15.0
        let fly   = SKAction.moveTo(x: -50, duration: speed)
        let reset = SKAction.run { self.flyAsteroid(asteroid) }

        asteroid.run(SKAction.sequence([wait, show, fly, reset]), withKey: "fly")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        for node in nodes(at: location) {
            // Найти астероид среди нажатых (сам или его дочерний элемент)
            var targetAsteroid: SKSpriteNode? = nil
            if node.name == "asteroid", let s = node as? SKSpriteNode {
                targetAsteroid = s
            } else if node.parent?.name == "asteroid", let s = node.parent as? SKSpriteNode {
                targetAsteroid = s
            }

            if let asteroid = targetAsteroid {
                explodeAsteroid(asteroid)
                break
            }
        }
    }

    func explodeAsteroid(_ asteroid: SKSpriteNode) {
        destroyCount += 1
        scoreLabel.text = "Уничтожено: \(destroyCount)"

        asteroid.removeAction(forKey: "fly")

        let grow    = SKAction.scale(to: 2.5, duration: 0.15)
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        let explode = SKAction.group([grow, fadeOut])
        let reset   = SKAction.run {
            asteroid.setScale(1.0)
            self.flyAsteroid(asteroid)
        }

        asteroid.run(SKAction.sequence([explode, reset]))
    }
}
```
