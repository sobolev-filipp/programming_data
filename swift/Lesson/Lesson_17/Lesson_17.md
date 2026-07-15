# Урок 17 — Враги, счёт и жизни
**Полный план для учителя · 45 минут · Возраст 12 лет**

---

## Цель урока

Ребёнок собирает законченную аркадную игру: волны врагов с нарастающей сложностью, система очков с бонусами, жизни, экран Game Over с рестартом. Это урок-сборка — здесь объединяется всё что прошли: спрайты, действия, физика, управление. Проект «Защита базы» — сверху летят враги, игрок сбивает их и защищает базу.

---

## Таймлайн урока

| Время | Что делаем |
|---|---|
| 0–5 мин | Разминка — вспоминаем прошлый урок |
| 5–18 мин | Теория: волны врагов, система очков, состояния игры |
| 18–40 мин | Пишем проект «Защита базы» |
| 40–45 мин | Запускаем, объясняем домашнее задание |

---

## Часть 1 — Разминка (5 минут)

**Спроси ребёнка:**
- Как перебрать все касания? (`for touch in touches`)
- Как создать врага который сам появляется каждые N секунд? (`SKAction.repeatForever` + `wait` + `run`)
- Как проверить нажатие на кнопку? (`nodes(at:)` + проверка `name`)
- Что делает `isGameOver`? (флаг — игра закончена, блокирует действия)
- Покажи домашнее задание — как сделал щит

---

## Часть 2 — Теория: устройство аркадной игры (13 минут)

### Состояния игры

В любой игре есть несколько состояний. Мы отслеживаем их через переменные-флаги.

```swift
var isGameOver = false    // игра закончена?
var isPaused = false      // на паузе?
var currentWave = 1       // текущая волна
var enemiesDefeated = 0   // сколько врагов побили в этой волне
```

> **Аналогия с Godot:** это как машина состояний (State Machine). Игра может быть в состоянии «играем», «пауза», «конец». Флаги говорят в каком мы сейчас.

---

### Волны врагов с нарастающей сложностью

Вместо бесконечного однообразного спавна — делим игру на волны. Каждая волна сложнее.

```swift
var currentWave = 1
var enemiesPerWave = 5      // врагов в текущей волне
var enemiesSpawned = 0      // сколько уже создали
var enemySpeed = 4.0        // скорость врагов

func startWave() {
    enemiesSpawned = 0
    showMessage("Волна \(currentWave)", color: .yellow)

    // Спавним enemiesPerWave врагов
    let spawn = SKAction.run { self.spawnEnemy() }
    let wait  = SKAction.wait(forDuration: 1.0)
    let sequence = SKAction.sequence([wait, spawn])

    run(SKAction.repeat(sequence, count: enemiesPerWave))
}

func nextWave() {
    currentWave += 1
    enemiesPerWave += 2         // на 2 врага больше
    enemySpeed = max(1.5, enemySpeed - 0.3)   // быстрее
    startWave()
}
```

---

### Система очков с бонусами

Разные враги — разные очки. Быстрое уничтожение — бонус.

```swift
var score = 0
var combo = 0            // сколько подряд без промаха
var lastHitTime = 0.0    // время последнего попадания

func addScore(base: Int) {
    // Комбо-множитель: чем больше подряд — тем больше очков
    combo += 1
    let multiplier = min(combo, 5)   // максимум x5
    let points = base * multiplier

    score += points
    scoreLabel.text = "Счёт: \(score)"

    if combo >= 3 {
        showFloatingText("x\(multiplier)!", at: ...)
    }
}

func resetCombo() {
    combo = 0   // промах или пропустил врага — комбо сбрасывается
}
```

---

### Разные типы врагов

```swift
enum EnemyType {
    case normal    // обычный — 1 очко, средняя скорость
    case fast      // быстрый — 2 очка, быстрый но слабый
    case tank      // танк — 3 очка, медленный но нужно 2 попадания
}

func spawnEnemy() {
    // Случайный тип с разной вероятностью
    let roll = Int.random(in: 0...100)
    let type: EnemyType
    if roll < 60 {
        type = .normal
    } else if roll < 85 {
        type = .fast
    } else {
        type = .tank
    }

    createEnemy(type: type)
}
```

> **Объясни ребёнку:** `enum` (перечисление) — это способ дать имена вариантам. Вместо чисел 0, 1, 2 мы пишем понятные `.normal`, `.fast`, `.tank`. Код становится читаемым.

---

### Летающий текст очков

Когда враг уничтожен — над ним всплывает и тает надпись «+10».

```swift
func showFloatingText(_ text: String, at position: CGPoint, color: SKColor) {
    let label = SKLabelNode(fontNamed: "Helvetica-Bold")
    label.text = text
    label.fontSize = 24
    label.fontColor = color
    label.position = position
    label.zPosition = 20
    addChild(label)

    // Всплывает вверх и тает
    let moveUp  = SKAction.moveBy(x: 0, y: 50, duration: 0.6)
    let fadeOut = SKAction.fadeOut(withDuration: 0.6)
    let group   = SKAction.group([moveUp, fadeOut])
    label.run(SKAction.sequence([group, SKAction.removeFromParent()]))
}
```

---

### База со здоровьем

У игрока есть база внизу экрана. Если враг долетел до неё — база теряет прочность.

```swift
var baseHealth = 100
var baseHealthBar: SKShapeNode!

func damageBase(_ amount: Int) {
    baseHealth -= amount
    updateBaseHealthBar()
    resetCombo()   // пропустил врага — комбо сброшено

    // Мигание экрана красным
    flashScreen(color: .red)

    if baseHealth <= 0 {
        gameOver()
    }
}
```

---

## Часть 3 — Проект «Защита базы» (22 минуты)

### Что делает проект

- База внизу экрана с полоской здоровья
- Пушка по центру — поворачивается к месту касания и стреляет
- Три типа врагов летят сверху: обычные, быстрые, танки
- Уничтожил врага — очки (с комбо-множителем) и летающий текст «+10»
- Враг долетел до базы — база теряет здоровье
- Волны: каждая следующая сложнее
- Game Over когда здоровье базы = 0

---

### Шаг 1 — Создать проект, категории, свойства

```
File → New → Project → iOS → Game → BaseDefense
```

```swift
import SpriteKit

extension SKColor {
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> SKColor {
        return SKColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
}

struct PhysicsCategory {
    static let bullet: UInt32 = 0b0001
    static let enemy:  UInt32 = 0b0010
    static let base:   UInt32 = 0b0100
}

enum EnemyType {
    case normal, fast, tank
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    var cannon: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var waveLabel: SKLabelNode!
    var baseHealthBar: SKShapeNode!

    var score = 0
    var combo = 0
    var baseHealth = 100
    var maxBaseHealth = 100

    var currentWave = 1
    var enemiesPerWave = 5
    var enemiesRemaining = 0
    var enemySpeed = 5.0

    var isGameOver = false

    override func didMove(to view: SKView) {
        setupBackground()
        setupPhysics()
        setupBase()
        setupCannon()
        setupHUD()
        startWave()
    }
}
```

---

### Шаг 2 — Фон и физика

```swift
func setupBackground() {
    backgroundColor = .rgb(10, 12, 30)
    for _ in 0..<100 {
        let star = SKShapeNode(circleOfRadius: CGFloat.random(in: 0.5...2))
        star.fillColor = .white
        star.strokeColor = .clear
        star.alpha = CGFloat.random(in: 0.2...0.9)
        star.position = CGPoint(
            x: CGFloat.random(in: 0...size.width),
            y: CGFloat.random(in: 0...size.height)
        )
        addChild(star)
    }
}

func setupPhysics() {
    physicsWorld.gravity = .zero
    physicsWorld.contactDelegate = self
}
```

---

### Шаг 3 — База с полоской здоровья

```swift
func setupBase() {
    // Земля-платформа
    let ground = SKSpriteNode(color: .rgb(40, 60, 40), size: CGSize(width: size.width, height: 60))
    ground.position = CGPoint(x: size.width / 2, y: 30)
    ground.zPosition = 2
    ground.name = "base"
    ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
    ground.physicsBody?.isDynamic = false
    ground.physicsBody?.categoryBitMask    = PhysicsCategory.base
    ground.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
    ground.physicsBody?.collisionBitMask   = 0
    addChild(ground)

    // Фон полоски здоровья базы
    let barBg = SKShapeNode(rectOf: CGSize(width: 204, height: 16), cornerRadius: 6)
    barBg.fillColor = .rgb(50, 20, 20)
    barBg.strokeColor = .white
    barBg.lineWidth = 1
    barBg.position = CGPoint(x: size.width / 2, y: 68)
    barBg.zPosition = 5
    addChild(barBg)

    // Заливка здоровья
    baseHealthBar = SKShapeNode(rectOf: CGSize(width: 200, height: 12), cornerRadius: 4)
    baseHealthBar.fillColor = .rgb(80, 220, 80)
    baseHealthBar.strokeColor = .clear
    baseHealthBar.position = CGPoint(x: size.width / 2, y: 68)
    baseHealthBar.zPosition = 6
    addChild(baseHealthBar)
}

func updateBaseHealthBar() {
    let ratio = max(0, CGFloat(baseHealth) / CGFloat(maxBaseHealth))
    let width = 200 * ratio

    let newBar = SKShapeNode(rectOf: CGSize(width: max(1, width), height: 12), cornerRadius: 4)
    // Цвет: зелёный → жёлтый → красный
    if ratio > 0.5 {
        newBar.fillColor = .rgb(80, 220, 80)
    } else if ratio > 0.25 {
        newBar.fillColor = .rgb(255, 200, 0)
    } else {
        newBar.fillColor = .rgb(255, 60, 60)
    }
    newBar.strokeColor = .clear
    newBar.position = CGPoint(x: size.width / 2 - 100 + width / 2, y: 68)
    newBar.zPosition = 6

    baseHealthBar.removeFromParent()
    baseHealthBar = newBar
    addChild(baseHealthBar)
}
```

▶ **Запустить** — база внизу с зелёной полоской здоровья.

---

### Шаг 4 — Пушка

```swift
func setupCannon() {
    cannon = SKSpriteNode(color: .clear, size: CGSize(width: 40, height: 50))
    cannon.position = CGPoint(x: size.width / 2, y: 70)
    cannon.zPosition = 4

    // Основание
    let base = SKShapeNode(circleOfRadius: 22)
    base.fillColor = .rgb(80, 90, 120)
    base.strokeColor = .rgb(150, 160, 200)
    base.lineWidth = 2
    cannon.addChild(base)

    // Ствол
    let barrel = SKShapeNode(rectOf: CGSize(width: 12, height: 40), cornerRadius: 4)
    barrel.fillColor = .rgb(120, 130, 160)
    barrel.strokeColor = .rgb(180, 190, 220)
    barrel.lineWidth = 1.5
    barrel.position = CGPoint(x: 0, y: 18)
    cannon.addChild(barrel)

    addChild(cannon)
}
```

▶ **Запустить** — пушка на базе.

---

### Шаг 5 — Прицеливание и стрельба

```swift
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if isGameOver {
        for touch in touches {
            let location = touch.location(in: self)
            for node in nodes(at: location) {
                if (node.name ?? node.parent?.name) == "restartButton" {
                    restartGame()
                }
            }
        }
        return
    }

    guard let touch = touches.first else { return }
    let location = touch.location(in: self)

    aimCannon(at: location)
    shoot(at: location)
}

func aimCannon(at target: CGPoint) {
    // Считаем угол от пушки к цели
    let dx = target.x - cannon.position.x
    let dy = target.y - cannon.position.y
    let angle = atan2(dy, dx) - .pi / 2   // -90° потому что ствол смотрит вверх
    cannon.run(SKAction.rotate(toAngle: angle, duration: 0.1, shortestUnitArc: true))
}

func shoot(at target: CGPoint) {
    let bullet = SKShapeNode(circleOfRadius: 6)
    bullet.fillColor = .rgb(0, 255, 200)
    bullet.strokeColor = .rgb(150, 255, 230)
    bullet.lineWidth = 1
    bullet.position = cannon.position
    bullet.zPosition = 3
    bullet.name = "bullet"

    bullet.physicsBody = SKPhysicsBody(circleOfRadius: 6)
    bullet.physicsBody?.affectedByGravity = false
    bullet.physicsBody?.categoryBitMask    = PhysicsCategory.bullet
    bullet.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
    bullet.physicsBody?.collisionBitMask   = 0

    addChild(bullet)

    // Направление к цели
    let dx = target.x - cannon.position.x
    let dy = target.y - cannon.position.y
    let length = sqrt(dx * dx + dy * dy)
    let speed: CGFloat = 700
    let velocity = CGVector(dx: dx / length * speed, dy: dy / length * speed)
    bullet.physicsBody?.velocity = velocity

    // Удалить через 2 секунды если ни во что не попал
    bullet.run(SKAction.sequence([
        SKAction.wait(forDuration: 2.0),
        SKAction.removeFromParent()
    ]))
}
```

▶ **Запустить** — пушка поворачивается к касанию и стреляет пулей.

---

### Шаг 6 — Враги трёх типов

```swift
func spawnEnemy() {
    guard !isGameOver else { return }

    // Выбираем тип
    let roll = Int.random(in: 0...100)
    let type: EnemyType = roll < 60 ? .normal : (roll < 85 ? .fast : .tank)

    let enemy = SKSpriteNode(color: .clear, size: CGSize(width: 44, height: 44))
    enemy.name = "enemy"

    // Настройки по типу
    var color: SKColor
    var radius: CGFloat
    var speedMultiplier: Double
    var hp: Int
    var points: Int

    switch type {
    case .normal:
        color = .rgb(220, 80, 80); radius = 20; speedMultiplier = 1.0; hp = 1; points = 10
    case .fast:
        color = .rgb(255, 200, 0); radius = 15; speedMultiplier = 1.7; hp = 1; points = 20
    case .tank:
        color = .rgb(150, 80, 220); radius = 26; speedMultiplier = 0.6; hp = 2; points = 30
    }

    // Тело
    let body = SKShapeNode(circleOfRadius: radius)
    body.fillColor = color
    body.strokeColor = .white
    body.lineWidth = 2
    enemy.addChild(body)

    // Глаз
    let eye = SKShapeNode(circleOfRadius: radius / 3)
    eye.fillColor = .white
    eye.strokeColor = .black
    eye.lineWidth = 1
    eye.position = CGPoint(x: 0, y: -radius / 4)
    enemy.addChild(eye)

    // Сохраняем данные врага в userData
    enemy.userData = NSMutableDictionary()
    enemy.userData?["hp"] = hp
    enemy.userData?["points"] = points

    // Позиция сверху
    let x = CGFloat.random(in: 40...(size.width - 40))
    enemy.position = CGPoint(x: x, y: size.height + 40)
    enemy.zPosition = 3

    // Физика
    enemy.physicsBody = SKPhysicsBody(circleOfRadius: radius)
    enemy.physicsBody?.affectedByGravity = false
    enemy.physicsBody?.categoryBitMask    = PhysicsCategory.enemy
    enemy.physicsBody?.contactTestBitMask = PhysicsCategory.bullet | PhysicsCategory.base
    enemy.physicsBody?.collisionBitMask   = 0

    addChild(enemy)

    // Летит вниз к базе
    let duration = enemySpeed * speedMultiplier
    enemy.run(SKAction.moveTo(y: 70, duration: duration), withKey: "move")

    // Лёгкое покачивание
    enemy.run(SKAction.repeatForever(SKAction.sequence([
        SKAction.rotate(byAngle: 0.2, duration: 0.4),
        SKAction.rotate(byAngle: -0.2, duration: 0.4)
    ])))
}
```

> **Объясни ребёнку:** `userData` — это «карман» объекта. Мы прячем туда HP и очки конкретного врага. Так каждый враг помнит сколько у него здоровья. Это удобно когда врагов много.

---

### Шаг 7 — Волны

```swift
func startWave() {
    enemiesRemaining = enemiesPerWave
    showMessage("Волна \(currentWave)", color: .rgb(255, 220, 0))

    // Спавним врагов с интервалом
    let spawn = SKAction.run { self.spawnEnemy() }
    let wait  = SKAction.wait(forDuration: 1.2, withRange: 0.6)
    run(SKAction.repeat(SKAction.sequence([wait, spawn]), count: enemiesPerWave),
        withKey: "spawning")
}

func enemyGone() {
    enemiesRemaining -= 1
    if enemiesRemaining <= 0 && !isGameOver {
        // Волна пройдена — следующая через 2 сек
        run(SKAction.sequence([
            SKAction.wait(forDuration: 2.0),
            SKAction.run { self.nextWave() }
        ]))
    }
}

func nextWave() {
    currentWave += 1
    enemiesPerWave += 2
    enemySpeed = max(2.5, enemySpeed - 0.4)
    waveLabel.text = "Волна: \(currentWave)"
    startWave()
}
```

---

### Шаг 8 — Столкновения

```swift
func didBegin(_ contact: SKPhysicsContact) {
    guard !isGameOver else { return }

    let (bodyA, bodyB) = contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask
        ? (contact.bodyA, contact.bodyB)
        : (contact.bodyB, contact.bodyA)

    // Пуля попала во врага
    if bodyA.categoryBitMask == PhysicsCategory.bullet &&
       bodyB.categoryBitMask == PhysicsCategory.enemy {
        bulletHitEnemy(bullet: bodyA.node, enemy: bodyB.node)
    }

    // Враг долетел до базы
    if bodyA.categoryBitMask == PhysicsCategory.enemy &&
       bodyB.categoryBitMask == PhysicsCategory.base {
        enemyHitBase(enemy: bodyA.node)
    }
}

func bulletHitEnemy(bullet: SKNode?, enemy: SKNode?) {
    guard let bullet = bullet, let enemy = enemy else { return }
    guard bullet.parent != nil, enemy.parent != nil else { return }

    bullet.removeFromParent()

    // Уменьшаем HP врага
    var hp = enemy.userData?["hp"] as? Int ?? 1
    hp -= 1
    enemy.userData?["hp"] = hp

    if hp > 0 {
        // Враг ранен но жив — мигает
        enemy.run(SKAction.sequence([
            SKAction.fadeAlpha(to: 0.4, duration: 0.05),
            SKAction.fadeAlpha(to: 1.0, duration: 0.05)
        ]))
        return
    }

    // Враг уничтожен
    let points = enemy.userData?["points"] as? Int ?? 10
    let enemyPos = enemy.position

    enemy.removeAction(forKey: "move")
    enemy.run(SKAction.sequence([
        SKAction.group([
            SKAction.scale(to: 1.8, duration: 0.12),
            SKAction.fadeOut(withDuration: 0.12)
        ]),
        SKAction.removeFromParent()
    ]))

    addScore(base: points, at: enemyPos)
    enemyGone()
}

func enemyHitBase(enemy: SKNode?) {
    guard let enemy = enemy else { return }
    guard enemy.parent != nil else { return }

    enemy.removeFromParent()
    damageBase(15)
    enemyGone()
}
```

---

### Шаг 9 — Очки, урон базе, сообщения

```swift
func addScore(base points: Int, at position: CGPoint) {
    combo += 1
    let multiplier = min(combo, 5)
    let total = points * multiplier

    score += total
    scoreLabel.text = "Счёт: \(score)"

    // Летающий текст
    let text = multiplier > 1 ? "+\(total) x\(multiplier)" : "+\(total)"
    showFloatingText(text, at: position, color: .rgb(0, 255, 180))
}

func damageBase(_ amount: Int) {
    baseHealth -= amount
    updateBaseHealthBar()
    combo = 0   // пропустил врага — комбо сброшено

    flashScreen(color: .red)

    if baseHealth <= 0 {
        gameOver()
    }
}

func flashScreen(color: SKColor) {
    let flash = SKShapeNode(rectOf: size)
    flash.fillColor = color
    flash.strokeColor = .clear
    flash.alpha = 0.4
    flash.position = CGPoint(x: size.width / 2, y: size.height / 2)
    flash.zPosition = 30
    addChild(flash)
    flash.run(SKAction.sequence([
        SKAction.fadeOut(withDuration: 0.3),
        SKAction.removeFromParent()
    ]))
}

func showFloatingText(_ text: String, at position: CGPoint, color: SKColor) {
    let label = SKLabelNode(fontNamed: "Helvetica-Bold")
    label.text = text
    label.fontSize = 22
    label.fontColor = color
    label.position = position
    label.zPosition = 20
    addChild(label)
    label.run(SKAction.sequence([
        SKAction.group([
            SKAction.moveBy(x: 0, y: 50, duration: 0.6),
            SKAction.fadeOut(withDuration: 0.6)
        ]),
        SKAction.removeFromParent()
    ]))
}

func showMessage(_ text: String, color: SKColor) {
    let msg = SKLabelNode(fontNamed: "Helvetica-Bold")
    msg.text = text
    msg.fontSize = 40
    msg.fontColor = color
    msg.position = CGPoint(x: size.width / 2, y: size.height / 2)
    msg.zPosition = 25
    msg.setScale(0.3)
    addChild(msg)
    msg.run(SKAction.sequence([
        SKAction.scale(to: 1.0, duration: 0.2),
        SKAction.wait(forDuration: 0.9),
        SKAction.fadeOut(withDuration: 0.3),
        SKAction.removeFromParent()
    ]))
}
```

---

### Шаг 10 — HUD и Game Over

```swift
func setupHUD() {
    scoreLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
    scoreLabel.text = "Счёт: 0"
    scoreLabel.fontSize = 22
    scoreLabel.fontColor = .white
    scoreLabel.position = CGPoint(x: 20, y: size.height - 55)
    scoreLabel.horizontalAlignmentMode = .left
    scoreLabel.zPosition = 10
    addChild(scoreLabel)

    waveLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
    waveLabel.text = "Волна: 1"
    waveLabel.fontSize = 22
    waveLabel.fontColor = .rgb(255, 220, 0)
    waveLabel.position = CGPoint(x: size.width - 20, y: size.height - 55)
    waveLabel.horizontalAlignmentMode = .right
    waveLabel.zPosition = 10
    addChild(waveLabel)
}

func gameOver() {
    isGameOver = true
    removeAllActions()
    // Удаляем всех врагов
    enumerateChildNodes(withName: "enemy") { node, _ in
        node.removeFromParent()
    }

    let overlay = SKShapeNode(rectOf: size)
    overlay.fillColor = .black
    overlay.strokeColor = .clear
    overlay.alpha = 0
    overlay.position = CGPoint(x: size.width / 2, y: size.height / 2)
    overlay.zPosition = 40
    addChild(overlay)
    overlay.run(SKAction.fadeAlpha(to: 0.7, duration: 0.4))

    let title = SKLabelNode(fontNamed: "Helvetica-Bold")
    title.text = "БАЗА ПАЛА"
    title.fontSize = 46
    title.fontColor = .red
    title.position = CGPoint(x: size.width / 2, y: size.height / 2 + 60)
    title.zPosition = 41
    title.setScale(0)
    addChild(title)
    title.run(SKAction.scale(to: 1.0, duration: 0.3))

    let stats = SKLabelNode(fontNamed: "Helvetica-Bold")
    stats.text = "Счёт: \(score)  •  Волна: \(currentWave)"
    stats.fontSize = 22
    stats.fontColor = .white
    stats.position = CGPoint(x: size.width / 2, y: size.height / 2)
    stats.zPosition = 41
    addChild(stats)

    let restart = SKShapeNode(rectOf: CGSize(width: 220, height: 55), cornerRadius: 14)
    restart.fillColor = .rgb(50, 150, 50)
    restart.strokeColor = .white
    restart.lineWidth = 1.5
    restart.position = CGPoint(x: size.width / 2, y: size.height / 2 - 70)
    restart.name = "restartButton"
    restart.zPosition = 41
    addChild(restart)

    let restartLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
    restartLabel.text = "Защищать снова"
    restartLabel.fontSize = 20
    restartLabel.fontColor = .white
    restartLabel.verticalAlignmentMode = .center
    restart.addChild(restartLabel)
}

func restartGame() {
    let scene = GameScene(size: self.size)
    scene.scaleMode = .resizeFill
    view?.presentScene(scene, transition: .fade(withDuration: 0.5))
}
```

▶ **Запустить финальную версию** — полноценная игра с волнами, тремя типами врагов, комбо и защитой базы!

---

## Частые ошибки на этом уроке

| Ошибка | Причина | Решение |
|---|---|---|
| Враг не получает урон | `userData` не создан | Добавить `enemy.userData = NSMutableDictionary()` |
| HP не сохраняется | Читают `userData` до записи | Записать `hp` и `points` сразу после создания |
| Волна не сменяется | `enemiesRemaining` не уменьшается | Вызывать `enemyGone()` и при уничтожении, и при уроне базе |
| Комбо не растёт | Сбрасывается не там | `combo = 0` только в `damageBase`, не в `addScore` |
| Пушка крутится не туда | Забыли `- .pi / 2` | Ствол смотрит вверх, нужна поправка на 90° |
| Game Over повисает | Враги продолжают спавниться | `enumerateChildNodes` + `removeAllActions()` |

---

## Домашнее задание

### Задание

Добавить бонус-цель: летящая звезда, которая при попадании даёт +50 очков и восстанавливает 20 здоровья базе.

**Конкретно:**
1. Раз в 10 секунд сбоку пролетает золотая звезда
2. Звезда движется горизонтально через экран
3. При попадании пули — +50 очков, +20 здоровья базе, летающий текст
4. Если не попал — звезда просто улетает
5. ⭐ **Бонус:** звезда покачивается вверх-вниз пока летит (сложнее попасть)

### Подсказка

```swift
func spawnBonusStar() {
    let star = SKShapeNode(circleOfRadius: 18)
    star.fillColor = .rgb(255, 220, 0)
    star.strokeColor = .white
    star.lineWidth = 2
    star.name = "bonusStar"
    star.position = CGPoint(x: -30, y: size.height * 0.7)

    star.physicsBody = SKPhysicsBody(circleOfRadius: 18)
    star.physicsBody?.affectedByGravity = false
    star.physicsBody?.categoryBitMask    = PhysicsCategory.enemy   // или новую категорию
    star.physicsBody?.contactTestBitMask = PhysicsCategory.bullet
    star.physicsBody?.collisionBitMask   = 0
    addChild(star)

    // Летит через экран
    star.run(SKAction.sequence([
        SKAction.moveTo(x: size.width + 30, duration: 4.0),
        SKAction.removeFromParent()
    ]))
}

// Запускать раз в 10 секунд:
run(SKAction.repeatForever(SKAction.sequence([
    SKAction.wait(forDuration: 10.0),
    SKAction.run { self.spawnBonusStar() }
])))
```
