# Урок 15 — Физика и столкновения

---

## Цель урока

Ребёнок понимает как работает физический движок SpriteKit. Умеет добавлять физические тела, настраивать гравитацию, обнаруживать столкновения между объектами. Делает проект «Мяч в ловушке» — мяч падает сверху, отскакивает от платформ, при попадании в корзину — засчитывается очко.

---

## Таймлайн урока

| Время | Что делаем |
|---|---|
| 0–5 мин | Разминка — вспоминаем прошлый урок |
| 5–20 мин | Теория: физика в SpriteKit |
| 20–40 мин | Пишем проект «Мяч в ловушке» |
| 40–45 мин | Запускаем, объясняем домашнее задание |

---

## Часть 1 — Разминка (5 минут)

**Спроси ребёнка:**
- Что такое SKAction и как его запустить? (`sprite.run(action)`)
- Как повторить действие бесконечно? (`SKAction.repeatForever`)
- Как запустить два действия одновременно? (`SKAction.group`)
- Как запустить два действия по очереди? (`SKAction.sequence`)
- Что такое ключ действия и зачем он нужен? (`withKey:` чтобы остановить конкретное действие)

---

## Часть 2 — Теория: физика в SpriteKit (15 минут)

### Что такое физический движок?

Физический движок — это встроенный в SpriteKit «симулятор физики». Ты говоришь: «вот этот объект подчиняется физике» — и он начинает падать, отскакивать, сталкиваться с другими объектами. Тебе не нужно писать формулы самому.

> **Аналогия с Godot:** В Godot есть `RigidBody2D` и `StaticBody2D`. В SpriteKit то же самое через `SKPhysicsBody`. `isDynamic = true` — как RigidBody, `isDynamic = false` — как StaticBody.

---

### SKPhysicsBody — добавить физику объекту

```swift
// Физика в форме КРУГА (для мячей, монет)
ball.physicsBody = SKPhysicsBody(circleOfRadius: 25)

// Физика в форме ПРЯМОУГОЛЬНИКА (для платформ, стен)
platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)

// Физика по КОНТУРУ ТЕКСТУРЫ (точно но медленно — для сложных форм)
hero.physicsBody = SKPhysicsBody(texture: hero.texture!, size: hero.size)
```

---

### Настройка физического тела

```swift
let body = ball.physicsBody!

// --- Тип объекта ---
body.isDynamic = true          // двигается (мяч, герой, враг)
body.isDynamic = false         // стоит на месте (стена, пол, платформа)

// --- Гравитация и движение ---
body.affectedByGravity = true  // падает вниз
body.allowsRotation = false    // запретить вращение при столкновениях

// --- Физические свойства ---
body.friction    = 0.2         // трение (0 = скользит, 1 = не скользит)
body.restitution = 0.6         // упругость — насколько отскакивает (0 = не прыгает, 1 = идеальный прыжок)
body.mass        = 1.0         // масса в кг
body.linearDamping  = 0.1     // сопротивление движению (воздух)
body.angularDamping = 0.1     // сопротивление вращению

// --- Скорость ---
body.velocity = CGVector(dx: 0, dy: -200)    // задать скорость напрямую
body.applyImpulse(CGVector(dx: 0, dy: 500))  // дать толчок (одиночный удар)
body.applyForce(CGVector(dx: 100, dy: 0))    // постоянная сила (пока действует)
```

---

### Гравитация сцены

```swift
override func didMove(to view: SKView) {
    // По умолчанию гравитация = -9.8 (земная, направлена вниз)
    physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)

    // Слабая гравитация (как на луне)
    physicsWorld.gravity = CGVector(dx: 0, dy: -2.0)

    // Без гравитации (космос, вид сверху)
    physicsWorld.gravity = CGVector(dx: 0, dy: 0)

    // Гравитация в сторону (необычная механика)
    physicsWorld.gravity = CGVector(dx: -5.0, dy: 0)
}
```

---

### Категории — кто с кем сталкивается

Категория — это метка объекта. Через неё SpriteKit понимает: «этот объект — мяч, тот — корзина, нужно сообщить когда они касаются».

```swift
// Определяем категории — каждая следующая в 2 раза больше
struct PhysicsCategory {
    static let ball:     UInt32 = 0b0001   // = 1
    static let platform: UInt32 = 0b0010   // = 2
    static let basket:   UInt32 = 0b0100   // = 4
    static let wall:     UInt32 = 0b1000   // = 8
    static let none:     UInt32 = 0b0000   // = 0
}
```

> **Объясни ребёнку:** Это как номера команд в игре. У мяча номер 1, у платформы — 2, у корзины — 4. Мы говорим системе: «когда объект №1 касается объекта №4 — скажи мне». Числа степени двойки потому что их можно комбинировать.

```swift
// Назначаем категории объектам
ball.physicsBody?.categoryBitMask    = PhysicsCategory.ball
ball.physicsBody?.collisionBitMask   = PhysicsCategory.platform | PhysicsCategory.wall
ball.physicsBody?.contactTestBitMask = PhysicsCategory.basket
//                                     ↑ от чего отталкивается    ↑ о касании с кем сообщать
```

| Маска | Смысл |
|---|---|
| `categoryBitMask` | Кто этот объект |
| `collisionBitMask` | От кого физически отталкивается |
| `contactTestBitMask` | О касании с кем уведомлять нас |

---

### Обнаружение столкновений

```swift
// Шаг 1 — подключить протокол
class GameScene: SKScene, SKPhysicsContactDelegate {

    override func didMove(to view: SKView) {
        // Шаг 2 — назначить делегата
        physicsWorld.contactDelegate = self
    }

    // Шаг 3 — этот метод вызывается при КАЖДОМ касании
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB

        // Узнаём кто с кем столкнулся
        if bodyA.categoryBitMask == PhysicsCategory.ball &&
           bodyB.categoryBitMask == PhysicsCategory.basket {
            ballInBasket()
        }
    }

    // Этот метод вызывается когда объекты РАЗДЕЛЯЮТСЯ
    func didEnd(_ contact: SKPhysicsContact) {
        // обычно не нужен, но иногда полезен
    }
}
```

> **Важно:** SpriteKit не гарантирует порядок `bodyA` и `bodyB`. Мяч может оказаться как в `bodyA` так и в `bodyB`. Поэтому обычно проверяют обе комбинации или сортируют по категории.

```swift
func didBegin(_ contact: SKPhysicsContact) {
    // Сортируем: меньший categoryBitMask всегда в bodyA
    let (bodyA, bodyB) = contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask
        ? (contact.bodyA, contact.bodyB)
        : (contact.bodyB, contact.bodyA)

    if bodyA.categoryBitMask == PhysicsCategory.ball &&
       bodyB.categoryBitMask == PhysicsCategory.basket {
        ballInBasket()
    }
}
```

---

### Края экрана как стены

```swift
// Сделать края экрана непроходимыми
physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
```

Одна строка — и мяч не выйдет за пределы экрана!

---

## Часть 3 — Проект «Мяч в ловушке» (20 минут)

### Что делает проект

- Тёмный фон с градиентом
- Слева и справа — невидимые стены
- По центру внизу — корзина (две стенки)
- Мяч падает сверху в случайном месте
- Отскакивает от стен и корзины
- Если попал внутрь корзины — счёт +1, мяч исчезает и появляется новый
- Скорость падения увеличивается с каждым попаданием

---

### Шаг 1 — Создать проект и скелет

```
File → New → Project → iOS → Game → BasketBall
```

Заменить `GameViewController.swift`, очистить `GameScene.swift`.

```swift
import SpriteKit

extension SKColor {
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> SKColor {
        return SKColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
}

struct PhysicsCategory {
    static let ball:   UInt32 = 0b0001
    static let basket: UInt32 = 0b0010
    static let wall:   UInt32 = 0b0100
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    var ball: SKShapeNode!
    var scoreLabel: SKLabelNode!
    var score = 0
    var ballSpeed = 4.0    // скорость падения в секундах (меньше = быстрее)

    override func didMove(to view: SKView) {
        setupBackground()
        setupPhysics()
        setupWalls()
        setupBasket()
        setupScoreLabel()
        spawnBall()
    }
}
```

---

### Шаг 2 — Фон и физика мира

```swift
func setupBackground() {
    backgroundColor = .rgb(15, 20, 40)

    // Несколько светящихся точек для атмосферы
    for _ in 0..<40 {
        let dot = SKShapeNode(circleOfRadius: CGFloat.random(in: 0.5...3))
        dot.fillColor = .rgb(100, 150, 255)
        dot.strokeColor = .clear
        dot.alpha = CGFloat.random(in: 0.1...0.4)
        dot.position = CGPoint(
            x: CGFloat.random(in: 0...size.width),
            y: CGFloat.random(in: 0...size.height)
        )
        addChild(dot)
    }
}

func setupPhysics() {
    // Гравитация — чуть слабее земной чтобы игра была интереснее
    physicsWorld.gravity = CGVector(dx: 0, dy: -6.0)
    physicsWorld.contactDelegate = self

    // Края экрана — стены (мяч не вылетит за экран)
    physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    physicsBody?.categoryBitMask = PhysicsCategory.wall
    physicsBody?.friction = 0.1
}
```

▶ **Запустить** — фон с точками. Физика настроена.

---

### Шаг 3 — Корзина

Корзина — это две вертикальные стенки с промежутком. Мяч должен пролететь в промежуток чтобы засчитать очко.

```swift
func setupBasket() {
    let basketY: CGFloat = 140           // высота корзины от низа
    let basketWidth: CGFloat = 90        // ширина отверстия
    let wallHeight: CGFloat = 50         // высота стенок
    let wallThickness: CGFloat = 10      // толщина стенок
    let centerX = size.width / 2

    // Левая стенка корзины
    let leftWall = SKSpriteNode(color: .rgb(255, 140, 0), size: CGSize(width: wallThickness, height: wallHeight))
    leftWall.position = CGPoint(x: centerX - basketWidth / 2 - wallThickness / 2, y: basketY)
    leftWall.physicsBody = SKPhysicsBody(rectangleOf: leftWall.size)
    leftWall.physicsBody?.isDynamic = false   // стена не двигается
    leftWall.physicsBody?.categoryBitMask = PhysicsCategory.wall
    leftWall.physicsBody?.friction = 0.1
    leftWall.physicsBody?.restitution = 0.3
    addChild(leftWall)

    // Правая стенка корзины
    let rightWall = SKSpriteNode(color: .rgb(255, 140, 0), size: CGSize(width: wallThickness, height: wallHeight))
    rightWall.position = CGPoint(x: centerX + basketWidth / 2 + wallThickness / 2, y: basketY)
    rightWall.physicsBody = SKPhysicsBody(rectangleOf: rightWall.size)
    rightWall.physicsBody?.isDynamic = false
    rightWall.physicsBody?.categoryBitMask = PhysicsCategory.wall
    rightWall.physicsBody?.friction = 0.1
    rightWall.physicsBody?.restitution = 0.3
    addChild(rightWall)

    // Дно корзины — НЕВИДИМЫЙ СЕНСОР для обнаружения попадания
    let sensor = SKSpriteNode(color: .clear, size: CGSize(width: basketWidth, height: 5))
    sensor.position = CGPoint(x: centerX, y: basketY - wallHeight / 2)
    sensor.name = "basket"
    sensor.physicsBody = SKPhysicsBody(rectangleOf: sensor.size)
    sensor.physicsBody?.isDynamic = false
    sensor.physicsBody?.categoryBitMask  = PhysicsCategory.basket
    sensor.physicsBody?.contactTestBitMask = PhysicsCategory.ball
    sensor.physicsBody?.collisionBitMask = 0   // 0 = ни с чем не сталкивается (только сенсор!)
    addChild(sensor)

    // Визуальная сетка корзины
    let net = SKShapeNode()
    let netPath = CGMutablePath()
    netPath.move(to: CGPoint(x: centerX - basketWidth / 2, y: basketY - wallHeight / 2))
    netPath.addLine(to: CGPoint(x: centerX, y: basketY - wallHeight / 2 - 30))
    netPath.addLine(to: CGPoint(x: centerX + basketWidth / 2, y: basketY - wallHeight / 2))
    net.path = netPath
    net.strokeColor = .rgb(255, 200, 100)
    net.lineWidth = 2
    net.alpha = 0.6
    addChild(net)
}
```

▶ **Запустить** — должны появиться оранжевые стенки корзины внизу.

> **Объясни ребёнку:** `collisionBitMask = 0` — это «сенсор». Физически мяч проходит сквозь него, но SpriteKit всё равно сообщает нам о касании. Это классический приём в играх — невидимые триггеры.

---

### Шаг 4 — Мяч

```swift
func spawnBall() {
    // Случайный X в верхней части экрана
    let randomX = CGFloat.random(in: 60...(size.width - 60))

    // Случайный цвет мяча
    let colors: [SKColor] = [
        .rgb(255, 80, 80),   // красный
        .rgb(80, 200, 255),  // синий
        .rgb(100, 255, 100), // зелёный
        .rgb(255, 220, 0),   // жёлтый
        .rgb(200, 100, 255)  // фиолетовый
    ]
    let ballColor = colors.randomElement()!

    // Создаём мяч
    ball = SKShapeNode(circleOfRadius: 20)
    ball.fillColor = ballColor
    ball.strokeColor = ballColor.withAlphaComponent(0.5)
    ball.lineWidth = 3
    ball.position = CGPoint(x: randomX, y: size.height - 60)
    ball.name = "ball"
    ball.zPosition = 5

    // Блик на мяче
    let glare = SKShapeNode(circleOfRadius: 6)
    glare.fillColor = .white
    glare.strokeColor = .clear
    glare.alpha = 0.4
    glare.position = CGPoint(x: -7, y: 7)
    ball.addChild(glare)

    // Физика мяча
    ball.physicsBody = SKPhysicsBody(circleOfRadius: 20)
    ball.physicsBody?.restitution = 0.5           // немного отскакивает
    ball.physicsBody?.friction = 0.2
    ball.physicsBody?.linearDamping = 0.1
    ball.physicsBody?.allowsRotation = true
    ball.physicsBody?.categoryBitMask    = PhysicsCategory.ball
    ball.physicsBody?.collisionBitMask   = PhysicsCategory.wall
    ball.physicsBody?.contactTestBitMask = PhysicsCategory.basket

    addChild(ball)

    // Появляется с анимацией
    ball.setScale(0)
    ball.run(SKAction.scale(to: 1.0, duration: 0.2))
}
```

▶ **Запустить** — мяч должен появляться сверху и падать вниз, отскакивая от стен.

> **Объясни ребёнку:** `restitution = 0.5` — это «коэффициент упругости». 0 = мяч как камень, 1 = мяч как суперпрыгун. 0.5 — как обычный резиновый мяч.

---

### Шаг 5 — Счёт и сообщения

```swift
func setupScoreLabel() {
    scoreLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
    scoreLabel.text = "Попаданий: 0"
    scoreLabel.fontSize = 24
    scoreLabel.fontColor = .white
    scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 60)
    scoreLabel.horizontalAlignmentMode = .center
    scoreLabel.zPosition = 10
    addChild(scoreLabel)
}

func showMessage(_ text: String, color: SKColor = .white) {
    let msg = SKLabelNode(fontNamed: "Helvetica-Bold")
    msg.text = text
    msg.fontSize = 36
    msg.fontColor = color
    msg.position = CGPoint(x: size.width / 2, y: size.height / 2)
    msg.zPosition = 20
    msg.setScale(0)
    addChild(msg)

    msg.run(SKAction.sequence([
        SKAction.scale(to: 1.2, duration: 0.15),
        SKAction.scale(to: 1.0, duration: 0.1),
        SKAction.wait(forDuration: 0.6),
        SKAction.fadeOut(withDuration: 0.3),
        SKAction.removeFromParent()
    ]))
}
```

---

### Шаг 6 — Обнаружение попадания в корзину

```swift
func didBegin(_ contact: SKPhysicsContact) {
    // Определяем кто с кем столкнулся
    let (bodyA, bodyB) = contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask
        ? (contact.bodyA, contact.bodyB)
        : (contact.bodyB, contact.bodyA)

    // Мяч коснулся сенсора корзины
    if bodyA.categoryBitMask == PhysicsCategory.ball &&
       bodyB.categoryBitMask == PhysicsCategory.basket {
        ballInBasket()
    }
}

func ballInBasket() {
    // Защита от двойного срабатывания
    guard ball.parent != nil else { return }
    guard ball.action(forKey: "falling") == nil else { return }

    score += 1
    scoreLabel.text = "Попаданий: \(score)"

    // Каждые 3 попадания — ускоряем
    if score % 3 == 0 {
        ballSpeed = max(1.5, ballSpeed - 0.3)
        showMessage("БЫСТРЕЕ! ⚡", color: .rgb(255, 200, 0))
    } else {
        showMessage("ГОЛ! 🏀", color: .rgb(255, 140, 0))
    }

    // Мяч исчезает и появляется новый
    let shrink = SKAction.scale(to: 0, duration: 0.2)
    let remove = SKAction.removeFromParent()
    let spawn  = SKAction.run { self.spawnBall() }

    ball.run(SKAction.sequence([shrink, remove]), withKey: "falling")
    run(SKAction.sequence([
        SKAction.wait(forDuration: 0.3),
        spawn
    ]))
}
```

▶ **Запустить** — если мяч попадает в корзину, должно появиться сообщение и счёт увеличится.

---

### Шаг 7 — Касание: толкнуть мяч пальцем

```swift
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)

    // Считаем направление от мяча к точке касания
    let dx = location.x - ball.position.x
    let dy = location.y - ball.position.y

    // Нормализуем и умножаем на силу удара
    let length = sqrt(dx * dx + dy * dy)
    let force: CGFloat = 180
    let impulse = CGVector(dx: dx / length * force, dy: dy / length * force)

    // Даём мячу импульс в сторону касания
    ball.physicsBody?.applyImpulse(impulse)
}
```

▶ **Запустить** — при нажатии на экран мяч должен получать толчок в сторону пальца.

> **Объясни ребёнку:** мы считаем вектор от мяча к пальцу, «нормализуем» его (делаем длину = 1) и умножаем на силу 180. Так мяч летит именно в сторону пальца, с одинаковой силой вне зависимости от расстояния.

---

### Полный код GameScene.swift

```swift
import SpriteKit

extension SKColor {
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> SKColor {
        return SKColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
}

struct PhysicsCategory {
    static let ball:   UInt32 = 0b0001
    static let basket: UInt32 = 0b0010
    static let wall:   UInt32 = 0b0100
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    var ball: SKShapeNode!
    var scoreLabel: SKLabelNode!
    var score = 0
    var ballSpeed = 4.0

    override func didMove(to view: SKView) {
        setupBackground()
        setupPhysics()
        setupWalls()
        setupBasket()
        setupScoreLabel()
        spawnBall()
    }

    // MARK: - Фон

    func setupBackground() {
        backgroundColor = .rgb(15, 20, 40)
        for _ in 0..<40 {
            let dot = SKShapeNode(circleOfRadius: CGFloat.random(in: 0.5...3))
            dot.fillColor = .rgb(100, 150, 255)
            dot.strokeColor = .clear
            dot.alpha = CGFloat.random(in: 0.1...0.4)
            dot.position = CGPoint(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: 0...size.height)
            )
            addChild(dot)
        }
    }

    // MARK: - Физика

    func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0, dy: -6.0)
        physicsWorld.contactDelegate = self
        physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        physicsBody?.categoryBitMask = PhysicsCategory.wall
        physicsBody?.friction = 0.1
    }

    // MARK: - Стены (невидимые, боковые)

    func setupWalls() {
        // edgeLoopFrom уже создал стены из краёв экрана в setupPhysics
        // Здесь можно добавить дополнительные платформы если нужно
    }

    // MARK: - Корзина

    func setupBasket() {
        let basketY: CGFloat = 140
        let basketWidth: CGFloat = 90
        let wallHeight: CGFloat = 50
        let wallThickness: CGFloat = 10
        let centerX = size.width / 2

        // Левая стенка
        let leftWall = SKSpriteNode(color: .rgb(255, 140, 0),
                                     size: CGSize(width: wallThickness, height: wallHeight))
        leftWall.position = CGPoint(x: centerX - basketWidth / 2 - wallThickness / 2, y: basketY)
        leftWall.physicsBody = SKPhysicsBody(rectangleOf: leftWall.size)
        leftWall.physicsBody?.isDynamic = false
        leftWall.physicsBody?.categoryBitMask = PhysicsCategory.wall
        leftWall.physicsBody?.friction = 0.1
        leftWall.physicsBody?.restitution = 0.3
        addChild(leftWall)

        // Правая стенка
        let rightWall = SKSpriteNode(color: .rgb(255, 140, 0),
                                      size: CGSize(width: wallThickness, height: wallHeight))
        rightWall.position = CGPoint(x: centerX + basketWidth / 2 + wallThickness / 2, y: basketY)
        rightWall.physicsBody = SKPhysicsBody(rectangleOf: rightWall.size)
        rightWall.physicsBody?.isDynamic = false
        rightWall.physicsBody?.categoryBitMask = PhysicsCategory.wall
        rightWall.physicsBody?.friction = 0.1
        rightWall.physicsBody?.restitution = 0.3
        addChild(rightWall)

        // Невидимый сенсор — дно корзины
        let sensor = SKSpriteNode(color: .clear, size: CGSize(width: basketWidth, height: 5))
        sensor.position = CGPoint(x: centerX, y: basketY - wallHeight / 2)
        sensor.name = "basket"
        sensor.physicsBody = SKPhysicsBody(rectangleOf: sensor.size)
        sensor.physicsBody?.isDynamic = false
        sensor.physicsBody?.categoryBitMask    = PhysicsCategory.basket
        sensor.physicsBody?.contactTestBitMask = PhysicsCategory.ball
        sensor.physicsBody?.collisionBitMask   = 0
        addChild(sensor)

        // Сетка — визуал
        let net = SKShapeNode()
        let netPath = CGMutablePath()
        netPath.move(to: CGPoint(x: centerX - basketWidth / 2, y: basketY - wallHeight / 2))
        netPath.addLine(to: CGPoint(x: centerX, y: basketY - wallHeight / 2 - 30))
        netPath.addLine(to: CGPoint(x: centerX + basketWidth / 2, y: basketY - wallHeight / 2))
        net.path = netPath
        net.strokeColor = .rgb(255, 200, 100)
        net.lineWidth = 2
        net.alpha = 0.6
        addChild(net)
    }

    // MARK: - Мяч

    func spawnBall() {
        let randomX = CGFloat.random(in: 60...(size.width - 60))
        let colors: [SKColor] = [
            .rgb(255, 80, 80), .rgb(80, 200, 255),
            .rgb(100, 255, 100), .rgb(255, 220, 0), .rgb(200, 100, 255)
        ]

        ball = SKShapeNode(circleOfRadius: 20)
        ball.fillColor = colors.randomElement()!
        ball.strokeColor = ball.fillColor.withAlphaComponent(0.5)
        ball.lineWidth = 3
        ball.position = CGPoint(x: randomX, y: size.height - 60)
        ball.name = "ball"
        ball.zPosition = 5

        let glare = SKShapeNode(circleOfRadius: 6)
        glare.fillColor = .white
        glare.strokeColor = .clear
        glare.alpha = 0.4
        glare.position = CGPoint(x: -7, y: 7)
        ball.addChild(glare)

        ball.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        ball.physicsBody?.restitution = 0.5
        ball.physicsBody?.friction = 0.2
        ball.physicsBody?.linearDamping = 0.1
        ball.physicsBody?.allowsRotation = true
        ball.physicsBody?.categoryBitMask    = PhysicsCategory.ball
        ball.physicsBody?.collisionBitMask   = PhysicsCategory.wall
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.basket

        addChild(ball)

        ball.setScale(0)
        ball.run(SKAction.scale(to: 1.0, duration: 0.2))
    }

    // MARK: - Счёт

    func setupScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        scoreLabel.text = "Попаданий: 0"
        scoreLabel.fontSize = 24
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 60)
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.zPosition = 10
        addChild(scoreLabel)
    }

    func showMessage(_ text: String, color: SKColor = .white) {
        let msg = SKLabelNode(fontNamed: "Helvetica-Bold")
        msg.text = text
        msg.fontSize = 36
        msg.fontColor = color
        msg.position = CGPoint(x: size.width / 2, y: size.height / 2)
        msg.zPosition = 20
        msg.setScale(0)
        addChild(msg)
        msg.run(SKAction.sequence([
            SKAction.scale(to: 1.2, duration: 0.15),
            SKAction.scale(to: 1.0, duration: 0.1),
            SKAction.wait(forDuration: 0.6),
            SKAction.fadeOut(withDuration: 0.3),
            SKAction.removeFromParent()
        ]))
    }

    // MARK: - Столкновения

    func didBegin(_ contact: SKPhysicsContact) {
        let (bodyA, bodyB) = contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask
            ? (contact.bodyA, contact.bodyB)
            : (contact.bodyB, contact.bodyA)

        if bodyA.categoryBitMask == PhysicsCategory.ball &&
           bodyB.categoryBitMask == PhysicsCategory.basket {
            ballInBasket()
        }
    }

    func ballInBasket() {
        guard ball.parent != nil else { return }
        guard ball.action(forKey: "falling") == nil else { return }

        score += 1
        scoreLabel.text = "Попаданий: \(score)"

        if score % 3 == 0 {
            ballSpeed = max(1.5, ballSpeed - 0.3)
            showMessage("БЫСТРЕЕ! ⚡", color: .rgb(255, 200, 0))
        } else {
            showMessage("ГОЛ! 🏀", color: .rgb(255, 140, 0))
        }

        let shrink = SKAction.scale(to: 0, duration: 0.2)
        let remove = SKAction.removeFromParent()
        ball.run(SKAction.sequence([shrink, remove]), withKey: "falling")

        run(SKAction.sequence([
            SKAction.wait(forDuration: 0.3),
            SKAction.run { self.spawnBall() }
        ]))
    }

    // MARK: - Касание

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        let dx = location.x - ball.position.x
        let dy = location.y - ball.position.y
        let length = sqrt(dx * dx + dy * dy)
        guard length > 0 else { return }

        let force: CGFloat = 180
        let impulse = CGVector(dx: dx / length * force, dy: dy / length * force)
        ball.physicsBody?.applyImpulse(impulse)
    }
}
```

---

## Частые ошибки на этом уроке

| Ошибка | Причина | Решение |
|---|---|---|
| `didBegin` не вызывается | Забыли `physicsWorld.contactDelegate = self` | Добавить в `setupPhysics()` |
| `didBegin` не вызывается (2) | Не подключили протокол `SKPhysicsContactDelegate` | Добавить после `SKScene` |
| Мяч падает сквозь стены | Не назначены `collisionBitMask` у мяча | Установить `PhysicsCategory.wall` |
| Сенсор отталкивает мяч | `collisionBitMask` сенсора не равен 0 | Установить `collisionBitMask = 0` |
| `ballInBasket` срабатывает дважды | Нет защитного `guard` | Добавить `guard ball.parent != nil` |
| Мяч улетает за экран | Нет `edgeLoopFrom` | Добавить в `setupPhysics()` |
| Краш при нажатии | `ball` равен nil (ещё не создан) | Добавить `guard ball != nil else { return }` в `touchesBegan` |

---

## Домашнее задание

### Задание

Добавить платформу которая двигается влево-вправо и мешает мячу попасть в корзину.

**Конкретно:**
1. Создать горизонтальную платформу посередине экрана
2. Платформа двигается влево-вправо через `SKAction.repeatForever` + `sequence`
3. Мяч должен отскакивать от платформы (добавить `PhysicsCategory.platform`)
4. ⭐ **Бонус:** скорость платформы увеличивается вместе с `ballSpeed`

### Подсказка

```swift
// Добавить в PhysicsCategory:
static let platform: UInt32 = 0b1000

// Создать платформу:
func setupPlatform() {
    let platform = SKSpriteNode(color: .rgb(100, 200, 100),
                                 size: CGSize(width: 120, height: 15))
    platform.position = CGPoint(x: size.width / 2, y: size.height / 2)
    platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
    platform.physicsBody?.isDynamic = false
    platform.physicsBody?.categoryBitMask  = PhysicsCategory.platform
    platform.physicsBody?.restitution = 0.4
    addChild(platform)

    // Движение влево-вправо
    let moveLeft  = SKAction.moveTo(x: 80, duration: 1.5)
    let moveRight = SKAction.moveTo(x: size.width - 80, duration: 1.5)
    moveLeft.timingMode  = .easeInEaseOut
    moveRight.timingMode = .easeInEaseOut
    platform.run(SKAction.repeatForever(
        SKAction.sequence([moveLeft, moveRight])
    ))
}

// Не забудь добавить platform в collisionBitMask мяча:
ball.physicsBody?.collisionBitMask = PhysicsCategory.wall | PhysicsCategory.platform
```
