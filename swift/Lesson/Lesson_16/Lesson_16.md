# Урок 16 — Управление игроком
**Полный план для учителя · 45 минут · Возраст 12 лет**

---

## Цель урока

Ребёнок умеет обрабатывать касания в SpriteKit разными способами: двигать персонажа за пальцем, стрелять по нажатию, добавлять кнопки управления прямо в игровую сцену. Делает проект «Космический корабль» — корабль движется за пальцем и стреляет лазерами по нажатию кнопки.

---

## Таймлайн урока

| Время | Что делаем |
|---|---|
| 0–5 мин | Разминка — вспоминаем прошлый урок |
| 5–20 мин | Теория: три способа управления |
| 20–40 мин | Пишем проект «Космический корабль» |
| 40–45 мин | Запускаем, объясняем домашнее задание |

---

## Часть 1 — Разминка (5 минут)

**Спроси ребёнка:**
- Как добавить физику объекту? (`sprite.physicsBody = SKPhysicsBody(...)`)
- Чем `isDynamic = false` отличается от `isDynamic = true`? (стоит на месте / двигается)
- Что такое `contactTestBitMask`? (о касании с кем сообщать)
- Что такое сенсор? (`collisionBitMask = 0` — проходим сквозь, но событие приходит)
- Зачем сортируют `bodyA` и `bodyB` в `didBegin`? (порядок не гарантирован)

---

## Часть 2 — Теория: управление касаниями (15 минут)

### Три метода касания

```swift
// Палец коснулся экрана
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { }

// Палец движется по экрану
override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { }

// Палец убрали с экрана
override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { }

// Касание прервалось (звонок, уведомление)
override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) { }
```

> **Аналогия с Godot:** `touchesBegan` = `INPUT_ACTION_PRESSED`, `touchesEnded` = `INPUT_ACTION_RELEASED`, `touchesMoved` = нет прямого аналога но похоже на `_input` с `MOUSE_MOTION`.

---

### Способ 1 — Переместить объект мгновенно

```swift
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)

    // Объект мгновенно перепрыгивает в точку касания
    hero.position = location
}
```

---

### Способ 2 — Тянуть объект за пальцем

```swift
override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)

    // Объект следует за пальцем пока он движется
    hero.position = location
}
```

---

### Способ 3 — Плавно двигать к точке касания

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

---

### Ограничение движения — не выйти за края

```swift
func clamp(_ value: CGFloat, min minVal: CGFloat, max maxVal: CGFloat) -> CGFloat {
    return max(minVal, min(maxVal, value))
}

// Применяем при движении
let clampedX = clamp(location.x, min: 40, max: size.width - 40)
let clampedY = clamp(location.y, min: 40, max: size.height - 40)
hero.position = CGPoint(x: clampedX, y: clampedY)
```

---

### Кнопки управления в игровой сцене

```swift
func addButton(name: String, text: String, position: CGPoint, color: SKColor) {
    let button = SKShapeNode(rectOf: CGSize(width: 90, height: 55), cornerRadius: 14)
    button.fillColor = color
    button.strokeColor = .white
    button.lineWidth = 1.5
    button.position = position
    button.name = name
    button.zPosition = 10
    addChild(button)

    let label = SKLabelNode(fontNamed: "Helvetica-Bold")
    label.text = text
    label.fontSize = 20
    label.fontColor = .white
    label.verticalAlignmentMode = .center
    button.addChild(label)
}

// Проверка нажатия — сам узел или его ребёнок (текст)
let name = node.name ?? node.parent?.name ?? ""
switch name {
case "fireButton": fire()
case "leftButton": moveLeft()
default: break
}
```

---

### Два касания одновременно — движение + стрельба

По умолчанию iOS обрабатывает несколько касаний. Чтобы различать их — нужно смотреть на все касания в `touches`, а не только на первое.

```swift
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {   // перебираем ВСЕ касания, не только первое
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)

        var hitButton = false
        for node in tappedNodes {
            let name = node.name ?? node.parent?.name ?? ""
            if name == "fireButton" {
                fire()
                hitButton = true
            }
        }

        // Если не попали в кнопку — двигаем корабль
        if !hitButton {
            moveShip(to: location)
        }
    }
}
```

---

### Направление объекта в сторону движения

```swift
// Повернуть спрайт в сторону куда движется
func rotateTowards(point: CGPoint) {
    let dx = point.x - ship.position.x
    let dy = point.y - ship.position.y
    let angle = atan2(dy, dx) - .pi / 2   // -π/2 потому что спрайт смотрит вверх
    ship.run(SKAction.rotate(toAngle: angle, duration: 0.15, shortestUnitArc: true))
}
```

> **Объясни ребёнку:** `atan2(dy, dx)` — это математическая функция которая по разнице координат говорит нам угол. `shortestUnitArc: true` — разворачиваться по кратчайшему пути (не крутить 270° когда можно повернуть на 90°).

---

## Часть 3 — Проект «Космический корабль» (20 минут)

### Что делает проект

- Звёздный фон (из урока 13 — повторение)
- Корабль внизу экрана — движется за пальцем только по оси X
- Кнопка «ОГОНЬ» справа внизу — стреляет лазером вверх
- Лазер летит вверх и исчезает за краем экрана
- Враги (астероиды) падают сверху в случайных местах
- При попадании лазера в астероид — оба исчезают, счёт +1
- Астероиды ускоряются каждые 5 очков

---

### Шаг 1 — Создать проект

```
File → New → Project → iOS → Game → SpaceShooter
```

Заменить `GameViewController.swift`, очистить `GameScene.swift`.

---

### Шаг 2 — Скелет, категории физики и фон

```swift
import SpriteKit

extension SKColor {
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> SKColor {
        return SKColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
}

struct PhysicsCategory {
    static let laser:    UInt32 = 0b0001
    static let asteroid: UInt32 = 0b0010
    static let ship:     UInt32 = 0b0100
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    var ship: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var lifeBar: SKSpriteNode!      // картинка полоски жизни
    var score = 0
    var lives = 3.0                 // дробные жизни — теряем по 0.5
    var maxLives = 3.0
    var asteroidSpeed = 3.5
    var isGameOver = false

    override func didMove(to view: SKView) {
        setupBackground()
        setupPhysics()
        setupShip()
        setupHUD()
        setupFireButton()
        startSpawning()
    }

    func setupBackground() {
        backgroundColor = .rgb(5, 5, 20)
        for _ in 0..<120 {
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

    func setupPhysics() {
        physicsWorld.gravity = .zero   // без гравитации — космос!
        physicsWorld.contactDelegate = self
    }
}
```

▶ **Запустить** — тёмный фон со звёздами.

---

### Шаг 3 — Корабль

```swift
func setupShip() {
    ship = SKSpriteNode(color: .clear, size: CGSize(width: 60, height: 70))
    ship.name = "ship"
    ship.position = CGPoint(x: size.width / 2, y: 100)
    ship.zPosition = 5

    // Корпус — треугольник
    let body = SKShapeNode()
    let bodyPath = CGMutablePath()
    bodyPath.move(to: CGPoint(x: 0, y: 35))       // нос
    bodyPath.addLine(to: CGPoint(x: -25, y: -30)) // левый край
    bodyPath.addLine(to: CGPoint(x: 25, y: -30))  // правый край
    bodyPath.closeSubpath()
    body.path = bodyPath
    body.fillColor = .rgb(50, 180, 255)
    body.strokeColor = .rgb(100, 220, 255)
    body.lineWidth = 2
    ship.addChild(body)

    // Кабина — маленький круг
    let cockpit = SKShapeNode(circleOfRadius: 10)
    cockpit.fillColor = .rgb(150, 230, 255)
    cockpit.strokeColor = .clear
    cockpit.alpha = 0.7
    cockpit.position = CGPoint(x: 0, y: 10)
    ship.addChild(cockpit)

    // Левое крыло
    let leftWing = SKShapeNode()
    let leftPath = CGMutablePath()
    leftPath.move(to: CGPoint(x: -20, y: -10))
    leftPath.addLine(to: CGPoint(x: -40, y: -30))
    leftPath.addLine(to: CGPoint(x: -15, y: -30))
    leftPath.closeSubpath()
    leftWing.path = leftPath
    leftWing.fillColor = .rgb(30, 120, 200)
    leftWing.strokeColor = .clear
    ship.addChild(leftWing)

    // Правое крыло
    let rightWing = SKShapeNode()
    let rightPath = CGMutablePath()
    rightPath.move(to: CGPoint(x: 20, y: -10))
    rightPath.addLine(to: CGPoint(x: 40, y: -30))
    rightPath.addLine(to: CGPoint(x: 15, y: -30))
    rightPath.closeSubpath()
    rightWing.path = rightPath
    rightWing.fillColor = .rgb(30, 120, 200)
    rightWing.strokeColor = .clear
    ship.addChild(rightWing)

    // Двигатель — мигающее пламя
    let flame = SKShapeNode(ellipseOf: CGSize(width: 16, height: 24))
    flame.fillColor = .rgb(255, 140, 0)
    flame.strokeColor = .clear
    flame.position = CGPoint(x: 0, y: -38)
    ship.addChild(flame)

    // Анимация пламени
    let flicker = SKAction.repeatForever(SKAction.sequence([
        SKAction.fadeAlpha(to: 0.5, duration: 0.1),
        SKAction.fadeAlpha(to: 1.0, duration: 0.1)
    ]))
    flame.run(flicker)

    // Физика корабля
    ship.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 44, height: 60))
    ship.physicsBody?.isDynamic = false   // двигаем сами через position
    ship.physicsBody?.categoryBitMask    = PhysicsCategory.ship
    ship.physicsBody?.contactTestBitMask = PhysicsCategory.asteroid
    ship.physicsBody?.collisionBitMask   = 0

    addChild(ship)
}
```

▶ **Запустить** — корабль с мигающим пламенем внизу экрана.

---

### Шаг 4 — Интерфейс (HUD) и кнопка огня

```swift
func setupHUD() {
    // Счёт
    scoreLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
    scoreLabel.text = "Счёт: 0"
    scoreLabel.fontSize = 22
    scoreLabel.fontColor = .white
    scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 55)
    scoreLabel.horizontalAlignmentMode = .center
    scoreLabel.zPosition = 10
    addChild(scoreLabel)

    // Жизни
    // Полоска жизни — картинка (см. раздел «Полоска жизни через картинку»)
    setupLifeBar()
}

func setupLifeBar() {
    lifeBar = SKSpriteNode(imageNamed: lifeImageName())
    lifeBar.size = CGSize(width: 120, height: 40)
    lifeBar.position = CGPoint(x: 80, y: size.height - 55)
    lifeBar.zPosition = 10
    addChild(lifeBar)
}

func lifeImageName() -> String {
    let safe = max(0, min(maxLives, lives))
    if safe == safe.rounded() {
        return "\(Int(safe))"      // 3.0 → "3"
    } else {
        return "\(safe)"           // 2.5 → "2.5"
    }
}

func updateLifeBar() {
    lifeBar.texture = SKTexture(imageNamed: lifeImageName())
    lifeBar.run(SKAction.sequence([
        SKAction.scale(to: 1.15, duration: 0.08),
        SKAction.scale(to: 1.0, duration: 0.08)
    ]))
}

func setupFireButton() {
    let button = SKShapeNode(rectOf: CGSize(width: 90, height: 90), cornerRadius: 45)
    button.fillColor = .rgb(200, 50, 50)
    button.strokeColor = .rgb(255, 100, 100)
    button.lineWidth = 2
    button.position = CGPoint(x: size.width - 65, y: 90)
    button.name = "fireButton"
    button.zPosition = 10
    button.alpha = 0.85
    addChild(button)

    let label = SKLabelNode(fontNamed: "Helvetica-Bold")
    label.text = "🔥"
    label.fontSize = 36
    label.verticalAlignmentMode = .center
    button.addChild(label)
}
```

▶ **Запустить** — счёт, жизни и красная кнопка огня справа внизу.

---

### Шаг 5 — Управление кораблём и стрельба

```swift
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard !isGameOver else { return }

    for touch in touches {
        let location = touch.location(in: self)

        var hitButton = false
        for node in nodes(at: location) {
            let name = node.name ?? node.parent?.name ?? ""
            if name == "fireButton" {
                fire()
                hitButton = true
                animateButton()
            }
        }

        // Если не кнопка — двигаем корабль
        if !hitButton {
            moveShip(to: location)
        }
    }
}

override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard !isGameOver else { return }

    for touch in touches {
        let location = touch.location(in: self)

        // Проверяем — не на кнопке ли этот палец
        var onButton = false
        for node in nodes(at: location) {
            let name = node.name ?? node.parent?.name ?? ""
            if name == "fireButton" { onButton = true }
        }

        if !onButton {
            moveShip(to: location)
        }
    }
}

func moveShip(to location: CGPoint) {
    // Двигаем только по X — корабль не выходит за края
    let clampedX = max(40, min(size.width - 40, location.x))
    ship.position.x = clampedX
}

func animateButton() {
    guard let button = childNode(withName: "fireButton") else { return }
    let press   = SKAction.scale(to: 0.88, duration: 0.07)
    let release = SKAction.scale(to: 1.0,  duration: 0.07)
    button.run(SKAction.sequence([press, release]))
}
```

▶ **Запустить** — корабль должен двигаться за пальцем по горизонтали.

> **Объясни ребёнку:** мы перебираем `for touch in touches` а не берём `touches.first` — потому что игрок может держать один палец для движения и нажимать другим на кнопку. Если брать только первый — второй палец игнорируется.

---

### Шаг 6 — Лазер

```swift
func fire() {
    let laser = SKSpriteNode(color: .clear, size: CGSize(width: 6, height: 30))
    laser.name = "laser"
    laser.position = CGPoint(x: ship.position.x, y: ship.position.y + 40)
    laser.zPosition = 4

    // Лазерный луч
    let beam = SKShapeNode(rectOf: CGSize(width: 4, height: 28), cornerRadius: 2)
    beam.fillColor = .rgb(0, 255, 200)
    beam.strokeColor = .rgb(100, 255, 230)
    beam.lineWidth = 1
    laser.addChild(beam)

    // Свечение
    let glow = SKShapeNode(rectOf: CGSize(width: 8, height: 32), cornerRadius: 4)
    glow.fillColor = .rgb(0, 255, 200)
    glow.strokeColor = .clear
    glow.alpha = 0.2
    laser.addChild(glow)

    // Физика лазера
    laser.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 4, height: 28))
    laser.physicsBody?.isDynamic = true
    laser.physicsBody?.affectedByGravity = false
    laser.physicsBody?.categoryBitMask    = PhysicsCategory.laser
    laser.physicsBody?.contactTestBitMask = PhysicsCategory.asteroid
    laser.physicsBody?.collisionBitMask   = 0

    addChild(laser)

    // Летит вверх и удаляется
    let fly    = SKAction.moveTo(y: size.height + 20, duration: 0.6)
    let remove = SKAction.removeFromParent()
    laser.run(SKAction.sequence([fly, remove]))
}
```

▶ **Запустить** — при нажатии на кнопку 🔥 должен вылетать зелёный лазерный луч.

---

### Шаг 7 — Враги (астероиды)

```swift
func startSpawning() {
    let wait  = SKAction.wait(forDuration: 1.2)
    let spawn = SKAction.run { self.spawnAsteroid() }
    run(SKAction.repeatForever(SKAction.sequence([wait, spawn])))
}

func spawnAsteroid() {
    guard !isGameOver else { return }

    let size = CGFloat.random(in: 20...45)
    let asteroid = SKSpriteNode(color: .clear,
                                 size: CGSize(width: size * 2, height: size * 2))
    asteroid.name = "asteroid"

    let body = SKShapeNode(circleOfRadius: size)
    body.fillColor = .rgb(
        CGFloat.random(in: 100...160),
        CGFloat.random(in: 80...130),
        CGFloat.random(in: 60...100)
    )
    body.strokeColor = .rgb(70, 60, 50)
    body.lineWidth = 1.5
    asteroid.addChild(body)

    // Кратер
    let crater = SKShapeNode(circleOfRadius: size / 4)
    crater.fillColor = .rgb(70, 55, 40)
    crater.strokeColor = .clear
    crater.position = CGPoint(x: -size * 0.2, y: size * 0.2)
    asteroid.addChild(crater)

    let randomX = CGFloat.random(in: 30...(self.size.width - 30))
    asteroid.position = CGPoint(x: randomX, y: self.size.height + size)
    asteroid.zPosition = 3

    // Физика
    asteroid.physicsBody = SKPhysicsBody(circleOfRadius: size)
    asteroid.physicsBody?.isDynamic = true
    asteroid.physicsBody?.affectedByGravity = false
    asteroid.physicsBody?.categoryBitMask    = PhysicsCategory.asteroid
    asteroid.physicsBody?.contactTestBitMask = PhysicsCategory.laser | PhysicsCategory.ship
    asteroid.physicsBody?.collisionBitMask   = 0

    addChild(asteroid)

    // Падает вниз + вращается
    let fall   = SKAction.moveTo(y: -size, duration: asteroidSpeed)
    let remove = SKAction.run { asteroid.removeFromParent() }
    asteroid.run(SKAction.sequence([fall, remove]))

    asteroid.run(SKAction.repeatForever(
        SKAction.rotate(byAngle: .pi * 2, duration: Double.random(in: 1.5...3.0))
    ))
}
```

▶ **Запустить** — сверху должны падать вращающиеся астероиды разного размера.

---

### Шаг 8 — Столкновения: лазер попал в астероид

```swift
func didBegin(_ contact: SKPhysicsContact) {
    guard !isGameOver else { return }

    let (bodyA, bodyB) = contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask
        ? (contact.bodyA, contact.bodyB)
        : (contact.bodyB, contact.bodyA)

    // Лазер попал в астероид
    if bodyA.categoryBitMask == PhysicsCategory.laser &&
       bodyB.categoryBitMask == PhysicsCategory.asteroid {
        laserHitAsteroid(laser: bodyA.node, asteroid: bodyB.node)
    }

    // Астероид попал в корабль
    if bodyA.categoryBitMask == PhysicsCategory.ship &&
       bodyB.categoryBitMask == PhysicsCategory.asteroid {
        shipHitAsteroid(asteroid: bodyB.node)
    }
}

func laserHitAsteroid(laser: SKNode?, asteroid: SKNode?) {
    guard let laser = laser, let asteroid = asteroid else { return }
    guard laser.parent != nil, asteroid.parent != nil else { return }

    // Удаляем оба объекта
    laser.removeFromParent()

    // Взрыв астероида
    let explode = SKAction.group([
        SKAction.scale(to: 2.0, duration: 0.15),
        SKAction.fadeOut(withDuration: 0.15)
    ])
    asteroid.run(SKAction.sequence([explode, SKAction.removeFromParent()]))

    // Счёт
    score += 1
    scoreLabel.text = "Счёт: \(score)"

    // Каждые 5 очков — ускорение
    if score % 5 == 0 {
        asteroidSpeed = max(1.0, asteroidSpeed - 0.3)
        showMessage("БЫСТРЕЕ! ⚡", color: .rgb(255, 220, 0))
    }
}

func shipHitAsteroid(asteroid: SKNode?) {
    guard let asteroid = asteroid else { return }
    guard asteroid.parent != nil else { return }

    asteroid.removeFromParent()

    // Теряем полсердца
    lives -= 0.5
    updateLifeBar()

    // Мигание корабля
    let flash = SKAction.repeat(SKAction.sequence([
        SKAction.fadeOut(withDuration: 0.1),
        SKAction.fadeIn(withDuration: 0.1)
    ]), count: 4)
    ship.run(flash)

    if lives <= 0 {
        gameOver()
    }
}
```

---

### Шаг 9 — Game Over

```swift
func gameOver() {
    isGameOver = true
    removeAllActions()

    // Затемнение
    let overlay = SKShapeNode(rectOf: size)
    overlay.fillColor = .black
    overlay.strokeColor = .clear
    overlay.alpha = 0
    overlay.position = CGPoint(x: size.width / 2, y: size.height / 2)
    overlay.zPosition = 15
    addChild(overlay)
    overlay.run(SKAction.fadeAlpha(to: 0.6, duration: 0.4))

    // Надпись
    let gameOverLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
    gameOverLabel.text = "GAME OVER"
    gameOverLabel.fontSize = 48
    gameOverLabel.fontColor = .red
    gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + 40)
    gameOverLabel.zPosition = 16
    gameOverLabel.setScale(0)
    addChild(gameOverLabel)
    gameOverLabel.run(SKAction.scale(to: 1.0, duration: 0.3))

    // Итоговый счёт
    let finalScore = SKLabelNode(fontNamed: "Helvetica-Bold")
    finalScore.text = "Счёт: \(score)"
    finalScore.fontSize = 28
    finalScore.fontColor = .white
    finalScore.position = CGPoint(x: size.width / 2, y: size.height / 2 - 10)
    finalScore.zPosition = 16
    addChild(finalScore)

    // Кнопка рестарта
    let restart = SKShapeNode(rectOf: CGSize(width: 200, height: 55), cornerRadius: 14)
    restart.fillColor = .rgb(50, 150, 50)
    restart.strokeColor = .white
    restart.lineWidth = 1.5
    restart.position = CGPoint(x: size.width / 2, y: size.height / 2 - 80)
    restart.name = "restartButton"
    restart.zPosition = 16
    addChild(restart)

    let restartLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
    restartLabel.text = "Играть снова"
    restartLabel.fontSize = 22
    restartLabel.fontColor = .white
    restartLabel.verticalAlignmentMode = .center
    restart.addChild(restartLabel)
}

// Вспомогательная функция — показать сообщение
func showMessage(_ text: String, color: SKColor) {
    let msg = SKLabelNode(fontNamed: "Helvetica-Bold")
    msg.text = text
    msg.fontSize = 30
    msg.fontColor = color
    msg.position = CGPoint(x: size.width / 2, y: size.height / 2)
    msg.zPosition = 12
    msg.setScale(0.5)
    addChild(msg)
    msg.run(SKAction.sequence([
        SKAction.scale(to: 1.0, duration: 0.2),
        SKAction.wait(forDuration: 0.8),
        SKAction.fadeOut(withDuration: 0.3),
        SKAction.removeFromParent()
    ]))
}

// Рестарт по нажатию кнопки
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    // ... существующий код ...

    // Добавить в начало функции:
    if isGameOver {
        for touch in touches {
            let location = touch.location(in: self)
            for node in nodes(at: location) {
                let name = node.name ?? node.parent?.name ?? ""
                if name == "restartButton" {
                    restartGame()
                }
            }
        }
        return
    }
}

func restartGame() {
    let newScene = GameScene(size: self.size)
    newScene.scaleMode = .resizeFill
    view?.presentScene(newScene, transition: .fade(withDuration: 0.5))
}
```

▶ **Запустить финальную версию** — полная игра с управлением, стрельбой, врагами и Game Over!

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
    static let laser:    UInt32 = 0b0001
    static let asteroid: UInt32 = 0b0010
    static let ship:     UInt32 = 0b0100
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    var ship: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var lifeBar: SKSpriteNode!      // картинка полоски жизни
    var score = 0
    var lives = 3.0                 // дробные жизни — теряем по 0.5
    var maxLives = 3.0
    var asteroidSpeed = 3.5
    var isGameOver = false

    override func didMove(to view: SKView) {
        setupBackground()
        setupPhysics()
        setupShip()
        setupHUD()
        setupFireButton()
        startSpawning()
    }

    // MARK: - Фон

    func setupBackground() {
        backgroundColor = .rgb(5, 5, 20)
        for _ in 0..<120 {
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

    // MARK: - Физика

    func setupPhysics() {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
    }

    // MARK: - Корабль

    func setupShip() {
        ship = SKSpriteNode(color: .clear, size: CGSize(width: 60, height: 70))
        ship.name = "ship"
        ship.position = CGPoint(x: size.width / 2, y: 100)
        ship.zPosition = 5

        let body = SKShapeNode()
        let bodyPath = CGMutablePath()
        bodyPath.move(to: CGPoint(x: 0, y: 35))
        bodyPath.addLine(to: CGPoint(x: -25, y: -30))
        bodyPath.addLine(to: CGPoint(x: 25, y: -30))
        bodyPath.closeSubpath()
        body.path = bodyPath
        body.fillColor = .rgb(50, 180, 255)
        body.strokeColor = .rgb(100, 220, 255)
        body.lineWidth = 2
        ship.addChild(body)

        let cockpit = SKShapeNode(circleOfRadius: 10)
        cockpit.fillColor = .rgb(150, 230, 255)
        cockpit.strokeColor = .clear
        cockpit.alpha = 0.7
        cockpit.position = CGPoint(x: 0, y: 10)
        ship.addChild(cockpit)

        let leftWing = SKShapeNode()
        let leftPath = CGMutablePath()
        leftPath.move(to: CGPoint(x: -20, y: -10))
        leftPath.addLine(to: CGPoint(x: -40, y: -30))
        leftPath.addLine(to: CGPoint(x: -15, y: -30))
        leftPath.closeSubpath()
        leftWing.path = leftPath
        leftWing.fillColor = .rgb(30, 120, 200)
        leftWing.strokeColor = .clear
        ship.addChild(leftWing)

        let rightWing = SKShapeNode()
        let rightPath = CGMutablePath()
        rightPath.move(to: CGPoint(x: 20, y: -10))
        rightPath.addLine(to: CGPoint(x: 40, y: -30))
        rightPath.addLine(to: CGPoint(x: 15, y: -30))
        rightPath.closeSubpath()
        rightWing.path = rightPath
        rightWing.fillColor = .rgb(30, 120, 200)
        rightWing.strokeColor = .clear
        ship.addChild(rightWing)

        let flame = SKShapeNode(ellipseOf: CGSize(width: 16, height: 24))
        flame.fillColor = .rgb(255, 140, 0)
        flame.strokeColor = .clear
        flame.position = CGPoint(x: 0, y: -38)
        ship.addChild(flame)
        flame.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.fadeAlpha(to: 0.5, duration: 0.1),
            SKAction.fadeAlpha(to: 1.0, duration: 0.1)
        ])))

        ship.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 44, height: 60))
        ship.physicsBody?.isDynamic = false
        ship.physicsBody?.categoryBitMask    = PhysicsCategory.ship
        ship.physicsBody?.contactTestBitMask = PhysicsCategory.asteroid
        ship.physicsBody?.collisionBitMask   = 0

        addChild(ship)
    }

    // MARK: - HUD

    func setupHUD() {
        scoreLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        scoreLabel.text = "Счёт: 0"
        scoreLabel.fontSize = 22
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 55)
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.zPosition = 10
        addChild(scoreLabel)

        setupLifeBar()
    }

    func setupLifeBar() {
        lifeBar = SKSpriteNode(imageNamed: lifeImageName())
        lifeBar.size = CGSize(width: 120, height: 40)
        lifeBar.position = CGPoint(x: 80, y: size.height - 55)
        lifeBar.zPosition = 10
        addChild(lifeBar)
    }

    // Имя картинки = число жизней. Файлы: "3","2.5","2","1.5","1","0.5","0"
    func lifeImageName() -> String {
        let safe = max(0, min(maxLives, lives))
        if safe == safe.rounded() {
            return "\(Int(safe))"      // 3.0 -> "3"
        } else {
            return "\(safe)"           // 2.5 -> "2.5"
        }
    }

    func updateLifeBar() {
        lifeBar.texture = SKTexture(imageNamed: lifeImageName())
        lifeBar.run(SKAction.sequence([
            SKAction.scale(to: 1.15, duration: 0.08),
            SKAction.scale(to: 1.0, duration: 0.08)
        ]))
    }

    // MARK: - Кнопка огня

    func setupFireButton() {
        let button = SKShapeNode(rectOf: CGSize(width: 90, height: 90), cornerRadius: 45)
        button.fillColor = .rgb(200, 50, 50)
        button.strokeColor = .rgb(255, 100, 100)
        button.lineWidth = 2
        button.position = CGPoint(x: size.width - 65, y: 90)
        button.name = "fireButton"
        button.zPosition = 10
        button.alpha = 0.85
        addChild(button)

        let label = SKLabelNode(fontNamed: "Helvetica-Bold")
        label.text = "🔥"
        label.fontSize = 36
        label.verticalAlignmentMode = .center
        button.addChild(label)
    }

    // MARK: - Касания

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameOver {
            for touch in touches {
                let location = touch.location(in: self)
                for node in nodes(at: location) {
                    let name = node.name ?? node.parent?.name ?? ""
                    if name == "restartButton" { restartGame() }
                }
            }
            return
        }

        for touch in touches {
            let location = touch.location(in: self)
            var hitButton = false

            for node in nodes(at: location) {
                let name = node.name ?? node.parent?.name ?? ""
                if name == "fireButton" {
                    fire()
                    animateButton()
                    hitButton = true
                }
            }

            if !hitButton { moveShip(to: location) }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isGameOver else { return }
        for touch in touches {
            let location = touch.location(in: self)
            var onButton = false
            for node in nodes(at: location) {
                let name = node.name ?? node.parent?.name ?? ""
                if name == "fireButton" { onButton = true }
            }
            if !onButton { moveShip(to: location) }
        }
    }

    func moveShip(to location: CGPoint) {
        let clampedX = max(40, min(size.width - 40, location.x))
        ship.position.x = clampedX
    }

    func animateButton() {
        guard let button = childNode(withName: "fireButton") else { return }
        button.run(SKAction.sequence([
            SKAction.scale(to: 0.88, duration: 0.07),
            SKAction.scale(to: 1.0,  duration: 0.07)
        ]))
    }

    // MARK: - Лазер

    func fire() {
        let laser = SKSpriteNode(color: .clear, size: CGSize(width: 6, height: 30))
        laser.name = "laser"
        laser.position = CGPoint(x: ship.position.x, y: ship.position.y + 40)
        laser.zPosition = 4

        let beam = SKShapeNode(rectOf: CGSize(width: 4, height: 28), cornerRadius: 2)
        beam.fillColor = .rgb(0, 255, 200)
        beam.strokeColor = .rgb(100, 255, 230)
        beam.lineWidth = 1
        laser.addChild(beam)

        let glow = SKShapeNode(rectOf: CGSize(width: 8, height: 32), cornerRadius: 4)
        glow.fillColor = .rgb(0, 255, 200)
        glow.strokeColor = .clear
        glow.alpha = 0.2
        laser.addChild(glow)

        laser.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 4, height: 28))
        laser.physicsBody?.isDynamic = true
        laser.physicsBody?.affectedByGravity = false
        laser.physicsBody?.categoryBitMask    = PhysicsCategory.laser
        laser.physicsBody?.contactTestBitMask = PhysicsCategory.asteroid
        laser.physicsBody?.collisionBitMask   = 0

        addChild(laser)

        laser.run(SKAction.sequence([
            SKAction.moveTo(y: size.height + 20, duration: 0.6),
            SKAction.removeFromParent()
        ]))
    }

    // MARK: - Астероиды

    func startSpawning() {
        let wait  = SKAction.wait(forDuration: 1.2)
        let spawn = SKAction.run { self.spawnAsteroid() }
        run(SKAction.repeatForever(SKAction.sequence([wait, spawn])))
    }

    func spawnAsteroid() {
        guard !isGameOver else { return }

        let radius = CGFloat.random(in: 20...45)
        let asteroid = SKSpriteNode(color: .clear,
                                     size: CGSize(width: radius * 2, height: radius * 2))
        asteroid.name = "asteroid"

        let body = SKShapeNode(circleOfRadius: radius)
        body.fillColor = .rgb(
            CGFloat.random(in: 100...160),
            CGFloat.random(in: 80...130),
            CGFloat.random(in: 60...100)
        )
        body.strokeColor = .rgb(70, 60, 50)
        body.lineWidth = 1.5
        asteroid.addChild(body)

        let crater = SKShapeNode(circleOfRadius: radius / 4)
        crater.fillColor = .rgb(70, 55, 40)
        crater.strokeColor = .clear
        crater.position = CGPoint(x: -radius * 0.2, y: radius * 0.2)
        asteroid.addChild(crater)

        let randomX = CGFloat.random(in: 30...(size.width - 30))
        asteroid.position = CGPoint(x: randomX, y: size.height + radius)
        asteroid.zPosition = 3

        asteroid.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        asteroid.physicsBody?.isDynamic = true
        asteroid.physicsBody?.affectedByGravity = false
        asteroid.physicsBody?.categoryBitMask    = PhysicsCategory.asteroid
        asteroid.physicsBody?.contactTestBitMask = PhysicsCategory.laser | PhysicsCategory.ship
        asteroid.physicsBody?.collisionBitMask   = 0

        addChild(asteroid)

        asteroid.run(SKAction.sequence([
            SKAction.moveTo(y: -radius, duration: asteroidSpeed),
            SKAction.removeFromParent()
        ]))
        asteroid.run(SKAction.repeatForever(
            SKAction.rotate(byAngle: .pi * 2, duration: Double.random(in: 1.5...3.0))
        ))
    }

    // MARK: - Столкновения

    func didBegin(_ contact: SKPhysicsContact) {
        guard !isGameOver else { return }

        let (bodyA, bodyB) = contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask
            ? (contact.bodyA, contact.bodyB)
            : (contact.bodyB, contact.bodyA)

        if bodyA.categoryBitMask == PhysicsCategory.laser &&
           bodyB.categoryBitMask == PhysicsCategory.asteroid {
            laserHitAsteroid(laser: bodyA.node, asteroid: bodyB.node)
        }

        if bodyA.categoryBitMask == PhysicsCategory.ship &&
           bodyB.categoryBitMask == PhysicsCategory.asteroid {
            shipHitAsteroid(asteroid: bodyB.node)
        }
    }

    func laserHitAsteroid(laser: SKNode?, asteroid: SKNode?) {
        guard let laser = laser, let asteroid = asteroid else { return }
        guard laser.parent != nil, asteroid.parent != nil else { return }

        laser.removeFromParent()
        asteroid.run(SKAction.sequence([
            SKAction.group([
                SKAction.scale(to: 2.0, duration: 0.15),
                SKAction.fadeOut(withDuration: 0.15)
            ]),
            SKAction.removeFromParent()
        ]))

        score += 1
        scoreLabel.text = "Счёт: \(score)"

        if score % 5 == 0 {
            asteroidSpeed = max(1.0, asteroidSpeed - 0.3)
            showMessage("БЫСТРЕЕ! ⚡", color: .rgb(255, 220, 0))
        }
    }

    func shipHitAsteroid(asteroid: SKNode?) {
        guard let asteroid = asteroid else { return }
        guard asteroid.parent != nil else { return }

        asteroid.removeFromParent()
        lives -= 0.5
        updateLifeBar()

        ship.run(SKAction.repeat(SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.1),
            SKAction.fadeIn(withDuration: 0.1)
        ]), count: 4))

        if lives <= 0 { gameOver() }
    }

    // MARK: - Game Over

    func gameOver() {
        isGameOver = true
        removeAllActions()

        let overlay = SKShapeNode(rectOf: size)
        overlay.fillColor = .black
        overlay.strokeColor = .clear
        overlay.alpha = 0
        overlay.position = CGPoint(x: size.width / 2, y: size.height / 2)
        overlay.zPosition = 15
        addChild(overlay)
        overlay.run(SKAction.fadeAlpha(to: 0.6, duration: 0.4))

        let gameOverLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.fontSize = 48
        gameOverLabel.fontColor = .red
        gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + 40)
        gameOverLabel.zPosition = 16
        gameOverLabel.setScale(0)
        addChild(gameOverLabel)
        gameOverLabel.run(SKAction.scale(to: 1.0, duration: 0.3))

        let finalScore = SKLabelNode(fontNamed: "Helvetica-Bold")
        finalScore.text = "Счёт: \(score)"
        finalScore.fontSize = 28
        finalScore.fontColor = .white
        finalScore.position = CGPoint(x: size.width / 2, y: size.height / 2 - 10)
        finalScore.zPosition = 16
        addChild(finalScore)

        let restart = SKShapeNode(rectOf: CGSize(width: 200, height: 55), cornerRadius: 14)
        restart.fillColor = .rgb(50, 150, 50)
        restart.strokeColor = .white
        restart.lineWidth = 1.5
        restart.position = CGPoint(x: size.width / 2, y: size.height / 2 - 80)
        restart.name = "restartButton"
        restart.zPosition = 16
        addChild(restart)

        let restartLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        restartLabel.text = "Играть снова"
        restartLabel.fontSize = 22
        restartLabel.fontColor = .white
        restartLabel.verticalAlignmentMode = .center
        restart.addChild(restartLabel)
    }

    func restartGame() {
        let newScene = GameScene(size: self.size)
        newScene.scaleMode = .resizeFill
        view?.presentScene(newScene, transition: .fade(withDuration: 0.5))
    }

    func showMessage(_ text: String, color: SKColor) {
        let msg = SKLabelNode(fontNamed: "Helvetica-Bold")
        msg.text = text
        msg.fontSize = 30
        msg.fontColor = color
        msg.position = CGPoint(x: size.width / 2, y: size.height / 2)
        msg.zPosition = 12
        msg.setScale(0.5)
        addChild(msg)
        msg.run(SKAction.sequence([
            SKAction.scale(to: 1.0, duration: 0.2),
            SKAction.wait(forDuration: 0.8),
            SKAction.fadeOut(withDuration: 0.3),
            SKAction.removeFromParent()
        ]))
    }
}
```

---

## Дополнение — Полоска жизни через картинку

Вместо эмодзи-сердечек `❤️` можно показывать жизнь красивой картинкой которая меняется. В этом проекте используется 7 картинок для 3 жизней с шагом в полсердца.

### Подготовка картинок

В `Assets.xcassets` добавить 7 картинок с именами по количеству жизни:

`3` · `2.5` · `2` · `1.5` · `1` · `0.5` · `0`

> Имя картинки = число жизней которое она показывает. Это ключевая идея — мы будем собирать имя картинки прямо из переменной `lives`.

### Свойства

```swift
var lives = 3.0                 // жизни теперь ДРОБНЫЕ (Double), а не целые
var maxLives = 3.0
var lifeBar: SKSpriteNode!      // одна картинка, а не массив
```

> **Объясни ребёнку:** раньше жизни были целые (`Int`), и мы теряли по 1. Теперь они дробные (`Double`), теряем по 0.5 — полсердца за удар. Поэтому тип поменялся с `Int` на `Double`.

### Создание полоски

```swift
func setupLifeBar() {
    lifeBar = SKSpriteNode(imageNamed: lifeImageName())
    lifeBar.size = CGSize(width: 120, height: 40)
    lifeBar.position = CGPoint(x: 80, y: size.height - 55)
    lifeBar.zPosition = 10
    addChild(lifeBar)
}
```

### Главная хитрость — собираем имя картинки из числа

```swift
func lifeImageName() -> String {
    let safe = max(0, min(maxLives, lives))   // не выходим за 0...3

    // Проблема: Swift выводит 3.0 вместо 3, а картинка называется "3"
    // Решение: если число целое — убираем дробную часть
    if safe == safe.rounded() {
        return "\(Int(safe))"      // 3.0 → "3",  2.0 → "2"
    } else {
        return "\(safe)"           // 2.5 → "2.5", 0.5 → "0.5"
    }
}
```

> **Зачем проверка `safe == safe.rounded()`?** Если просто написать `"\(lives)"`, то для 3 жизней получится строка `"3.0"` — а картинка называется `"3"` без `.0`. Xcode не найдёт файл `3.0` и картинка не появится. Поэтому целые числа (3.0, 2.0, 1.0, 0.0) мы превращаем в `"3"`, `"2"` через `Int()`, а дробные (2.5, 1.5, 0.5) оставляем как есть.

### Обновление картинки

```swift
func updateLifeBar() {
    // texture меняет картинку у спрайта не пересоздавая его
    lifeBar.texture = SKTexture(imageNamed: lifeImageName())

    // Анимация «вздрагивания» при потере
    lifeBar.run(SKAction.sequence([
        SKAction.scale(to: 1.15, duration: 0.08),
        SKAction.scale(to: 1.0, duration: 0.08)
    ]))
}
```

### Потеря жизни при ударе

```swift
func shipHitAsteroid(asteroid: SKNode?) {
    // ...
    lives -= 0.5           // полсердца за удар (было: lives -= 1)
    updateLifeBar()        // обновляем картинку (было: updateLivesLabel())
    // ...
    if lives <= 0 { gameOver() }
}
```

> **Важно:** `SKTexture(imageNamed:)` меняет картинку у существующего спрайта — это быстро и не «дёргает» позицию. Не нужно удалять и создавать спрайт заново.

---

## Частые ошибки на этом уроке

| Ошибка | Причина | Решение |
|---|---|---|
| Корабль не двигается | Используют `touches.first` вместо `for touch in touches` | Перебирать все касания циклом |
| Нажатие на текст кнопки не работает | Проверяют только `node.name` | Добавить `node.parent?.name` |
| Лазер не исчезает при попадании | `laser.parent == nil` уже до проверки | Добавить `guard laser.parent != nil` |
| `didBegin` не вызывается | Забыли `physicsWorld.contactDelegate = self` | Добавить в `setupPhysics()` |
| Астероиды сталкиваются друг с другом | `collisionBitMask` включает asteroid | Оставить `collisionBitMask = 0` |
| Game Over срабатывает дважды | Нет флага `isGameOver` | Проверять `guard !isGameOver` в `didBegin` |
| Корабль выходит за края | Нет `clamp` в `moveShip` | Добавить `max(40, min(size.width - 40, x))` |

---

## Домашнее задание

### Задание

Добавить бонус — щит который на 3 секунды делает корабль неуязвимым.

**Конкретно:**
1. Добавить кнопку «🛡» слева внизу
2. При нажатии — вокруг корабля появляется светящийся круг (щит)
3. Пока щит активен — астероиды проходят сквозь корабль (игнорируем `shipHitAsteroid`)
4. Через 3 секунды щит исчезает
5. ⭐ **Бонус:** щит можно использовать только раз в 10 секунд (перезарядка)

### Подсказка

```swift
var shieldActive = false

func activateShield() {
    guard !shieldActive else { return }
    shieldActive = true

    // Создать визуальный щит
    let shield = SKShapeNode(circleOfRadius: 45)
    shield.strokeColor = .rgb(100, 200, 255)
    shield.fillColor = .rgb(100, 200, 255)
    shield.alpha = 0.2
    shield.lineWidth = 3
    shield.name = "shield"
    shield.zPosition = 6
    ship.addChild(shield)

    // Через 3 секунды убрать
    run(SKAction.sequence([
        SKAction.wait(forDuration: 3.0),
        SKAction.run {
            self.ship.childNode(withName: "shield")?.removeFromParent()
            self.shieldActive = false
        }
    ]))
}

// В shipHitAsteroid добавить в начало:
guard !shieldActive else {
    asteroid?.removeFromParent()
    return
}
```
