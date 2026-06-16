# Урок 14 — Движение и анимация спрайтов

---

## Цель урока

Ребёнок понимает как работают `SKAction` — действия в SpriteKit. Умеет двигать, вращать, масштабировать спрайты, комбинировать действия и запускать их по очереди и одновременно. Делает проект «Летящий астероид с боссом» — обычный астероид уничтожается за одно нажатие, босс выдерживает 50 ударов, останавливается при каждом попадании и имеет полоску здоровья.

---

## Таймлайн урока

| Время | Что делаем |
|---|---|
| 0–5 мин | Разминка — вспоминаем прошлый урок |
| 5–20 мин | Теория: SKAction и все его виды |
| 20–38 мин | Пишем проект — астероид + босс по шагам |
| 38–45 мин | Запускаем, объясняем домашнее задание |

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

## Часть 3 — Проект «Летящий астероид с боссом» (18 минут)

### Что делает проект

- Космический фон со звёздами
- Обычный астероид летит справа налево, крутится, уничтожается за **1 нажатие**
- Через 5 секунд появляется **БОСС** — огромный красный метеорит с глазами
- Босс летает вверх-вниз по правой части экрана
- При каждом нажатии на босса — он **останавливается**, мигает и трясётся
- Через 0.6 секунды продолжает движение
- Нужно **50 попаданий** чтобы уничтожить босса
- Полоска здоровья меняет цвет: зелёный → жёлтый → красный
- После победы — конфетти и босс возвращается через 15 секунд

---

### Шаг 1 — Создать проект

Создаём новый проект **или** продолжаем проект с урока 13.

Если новый:
```
File → New → Project → iOS → Game → SpaceAsteroid
```

Заменить `GameViewController.swift` (как в уроке 13) и очистить `GameScene.swift`.

> **Совет:** если ребёнок хочет продолжить проект урока 13 — отлично! Просто добавляем босса в уже знакомый проект. Это хорошая практика.

---

### Шаг 2 — Скелет, расширение RGB и фон

```swift
import SpriteKit

// Расширение пишем ВНЕ класса — один раз на весь проект
extension SKColor {
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> SKColor {
        return SKColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
}

class GameScene: SKScene {

    // --- Обычный астероид ---
    var asteroid: SKSpriteNode!
    var asteroidSpeed = 4.0

    // --- Босс ---
    var boss: SKSpriteNode!
    var bossHP = 50
    var bossMaxHP = 50
    var bossHPLabel: SKLabelNode!
    var bossHPFill: SKShapeNode!
    var bossActive = false

    // --- Счёт ---
    var destroyCount = 0
    var scoreLabel: SKLabelNode!

    override func didMove(to view: SKView) {
        setupBackground()
        setupScoreLabel()
        setupAsteroid()
        setupBoss()
        startFlying()

        // Босс появляется через 5 секунд
        run(SKAction.sequence([
            SKAction.wait(forDuration: 5.0),
            SKAction.run { self.spawnBoss() }
        ]))
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
```

▶ **Запустить** — тёмный фон со звёздами, чёрный экран без объектов.

> **Объясни ребёнку:** мы сразу объявляем все переменные вверху — так удобнее. `bossActive` — это флаг, который говорит «босс сейчас на экране или нет».

---

### Шаг 3 — Обычный астероид (повторение урока 13)

```swift
func setupAsteroid() {
    asteroid = SKSpriteNode(color: .clear, size: CGSize(width: 60, height: 60))
    asteroid.name = "asteroid"

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

    asteroid.position = CGPoint(x: size.width / 2, y: size.height + 50)
    addChild(asteroid)
}

func startFlying() {
    flyAcrossScreen()
    asteroid.run(SKAction.repeatForever(
        SKAction.rotate(byAngle: .pi * 2, duration: 3.0)
    ), withKey: "spin")
}

func flyAcrossScreen() {
    // Случайная позиция по X, стартуем сверху
    let randomX = CGFloat.random(in: 40...(size.width - 40))
    asteroid.position = CGPoint(x: randomX, y: size.height + 50)

    // Летим вниз за пределы экрана
    let fly   = SKAction.moveTo(y: -50, duration: asteroidSpeed)
    let reset = SKAction.run { self.flyAcrossScreen() }
    asteroid.run(SKAction.sequence([fly, reset]), withKey: "fly")
}
```

▶ **Запустить** — астероид летит и крутится.

---

### Шаг 4 — Создаём босса

Босс — большой тёмно-красный метеорит в 3 раза больше обычного (160pt), со злыми глазами и надписью BOSS.

```swift
func setupBoss() {
    boss = SKSpriteNode(color: .clear, size: CGSize(width: 160, height: 160))
    boss.name = "boss"
    boss.alpha = 0   // пока скрыт

    // Большое красное тело
    let body = SKShapeNode(circleOfRadius: 75)
    body.fillColor = .rgb(160, 30, 30)
    body.strokeColor = .rgb(255, 80, 80)
    body.lineWidth = 3
    boss.addChild(body)

    // Внутреннее кольцо
    let inner = SKShapeNode(circleOfRadius: 50)
    inner.fillColor = .rgb(120, 20, 20)
    inner.strokeColor = .rgb(200, 60, 60)
    inner.lineWidth = 2
    boss.addChild(inner)

    // Злые глаза
    for (x, y) in [(-22.0, 18.0), (22.0, 18.0)] {
        let eye = SKShapeNode(circleOfRadius: 12)
        eye.fillColor = .rgb(255, 50, 50)
        eye.strokeColor = .clear
        eye.position = CGPoint(x: x, y: y)
        boss.addChild(eye)

        let pupil = SKShapeNode(circleOfRadius: 5)
        pupil.fillColor = .black
        pupil.position = CGPoint(x: x, y: y)
        boss.addChild(pupil)
    }

    // Кратеры
    for (x, y, r) in [(-30.0, 20.0, 14.0), (28.0, -18.0, 10.0), (-10.0, -35.0, 8.0)] {
        let crater = SKShapeNode(circleOfRadius: CGFloat(r))
        crater.fillColor = .rgb(100, 15, 15)
        crater.strokeColor = .clear
        crater.position = CGPoint(x: x, y: y)
        boss.addChild(crater)
    }

    // Надпись BOSS
    let label = SKLabelNode(fontNamed: "Helvetica-Bold")
    label.text = "BOSS"
    label.fontSize = 18
    label.fontColor = .rgb(255, 200, 0)
    label.verticalAlignmentMode = .center
    label.position = CGPoint(x: 0, y: -10)
    boss.addChild(label)

    boss.position = CGPoint(x: size.width + 100, y: size.height / 2)
    boss.zPosition = 5
    addChild(boss)

    setupBossHealthBar()
}
```

▶ **Запустить** — ничего нового не видно (босс скрыт). Убедимся что нет ошибок компиляции.

> **Объясни ребёнку:** мы создаём босса сразу при старте, но делаем его невидимым (`alpha = 0`). Это быстрее чем создавать его «на лету» — объект уже готов, просто ждёт своего момента.

---

### Шаг 5 — Полоска здоровья босса

```swift
func setupBossHealthBar() {
    let barY = size.height - 90

    // Фон полоски
    let bg = SKShapeNode(rectOf: CGSize(width: 204, height: 18), cornerRadius: 7)
    bg.fillColor = .rgb(40, 10, 10)
    bg.strokeColor = .rgb(255, 80, 80)
    bg.lineWidth = 1.5
    bg.position = CGPoint(x: size.width / 2, y: barY)
    bg.zPosition = 10
    bg.alpha = 0
    bg.name = "bossHPBg"
    addChild(bg)

    // Заливка (здоровье)
    bossHPFill = SKShapeNode(rectOf: CGSize(width: 200, height: 14), cornerRadius: 5)
    bossHPFill.fillColor = .rgb(80, 220, 80)
    bossHPFill.strokeColor = .clear
    bossHPFill.position = CGPoint(x: size.width / 2, y: barY)
    bossHPFill.zPosition = 11
    bossHPFill.alpha = 0
    addChild(bossHPFill)

    // Текст HP
    bossHPLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
    bossHPLabel.text = "BOSS HP: 50/50"
    bossHPLabel.fontSize = 14
    bossHPLabel.fontColor = .rgb(255, 200, 200)
    bossHPLabel.position = CGPoint(x: size.width / 2, y: barY - 22)
    bossHPLabel.horizontalAlignmentMode = .center
    bossHPLabel.zPosition = 11
    bossHPLabel.alpha = 0
    addChild(bossHPLabel)
}
```

---

### Шаг 6 — Появление босса и его движение

```swift
func spawnBoss() {
    guard !bossActive else { return }
    bossActive = true
    bossHP = bossMaxHP

    // Прячем обычный астероид
    asteroid.removeAction(forKey: "fly")
    asteroid.run(SKAction.fadeOut(withDuration: 0.5))

    showMessage("⚠️ BOSS ИДЁТ!", color: .rgb(255, 50, 50))

    // Показываем полоску здоровья
    childNode(withName: "bossHPBg")?.run(SKAction.fadeIn(withDuration: 0.5))
    bossHPFill.run(SKAction.fadeIn(withDuration: 0.5))
    bossHPLabel.run(SKAction.fadeIn(withDuration: 0.5))
    updateBossHealthBar()

    // Босс влетает справа и вырастает
    boss.alpha = 1
    boss.position = CGPoint(x: size.width + 100, y: size.height / 2)
    boss.setScale(0.3)

    let flyIn = SKAction.group([
        SKAction.moveTo(x: size.width * 0.75, duration: 1.2),
        SKAction.scale(to: 1.0, duration: 1.2)
    ])
    boss.run(flyIn) { self.startBossMovement() }

    // Медленное вращение
    boss.run(SKAction.repeatForever(
        SKAction.rotate(byAngle: .pi * 2, duration: 6.0)
    ), withKey: "spin")
}

func startBossMovement() {
    guard bossActive else { return }

    // Патруль вверх-вниз
    let down = SKAction.moveTo(y: 120, duration: 2.0)
    let up   = SKAction.moveTo(y: size.height - 120, duration: 2.0)
    down.timingMode = .easeInEaseOut
    up.timingMode   = .easeInEaseOut
    boss.run(SKAction.repeatForever(SKAction.sequence([down, up])), withKey: "patrol")
}
```

▶ **Запустить** — через 5 секунд должен прилететь босс, появиться полоска здоровья, он начнёт патрулировать вверх-вниз.

> **Объясни ребёнку:** `guard !bossActive else { return }` — защита от двойного запуска. Если босс уже активен — функция сразу выходит. Это важно: без этой проверки босс мог бы появиться дважды.

---

### Шаг 7 — Удар по боссу: останавливается и получает урон

Это главная механика урока — при каждом нажатии босс **останавливает патруль**, получает удар, и через 0.6 секунды продолжает движение.

```swift
func hitBoss() {
    guard bossActive else { return }
    guard boss.action(forKey: "explode") == nil else { return }  // не бить во время взрыва

    bossHP -= 1
    updateBossHealthBar()

    // ОСТАНАВЛИВАЕМ патруль
    boss.removeAction(forKey: "patrol")

    // Вспышка белым
    let flash  = SKAction.colorize(with: .white, colorBlendFactor: 0.8, duration: 0.05)
    let normal = SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.1)

    // Потряхивание
    let shake = SKAction.sequence([
        SKAction.moveBy(x:  6, y: 0, duration: 0.04),
        SKAction.moveBy(x: -6, y: 0, duration: 0.04),
        SKAction.moveBy(x:  6, y: 0, duration: 0.04),
        SKAction.moveBy(x: -6, y: 0, duration: 0.04)
    ])

    boss.run(SKAction.group([
        SKAction.sequence([flash, normal]),
        shake
    ]))

    // Через 0.6 сек — возобновляем движение
    boss.removeAction(forKey: "resumeTimer")
    boss.run(SKAction.sequence([
        SKAction.wait(forDuration: 0.6),
        SKAction.run { self.startBossMovement() }
    ]), withKey: "resumeTimer")

    // Проверяем — победили?
    if bossHP <= 0 {
        defeatBoss()
    }
}
```

> **Объясни ребёнку:** `boss.removeAction(forKey: "resumeTimer")` перед новым запуском — это сброс таймера. Если игрок бьёт быстро, каждый удар сдвигает момент возобновления движения на 0.6 сек вперёд. То есть пока бьёшь — босс стоит!

---

### Шаг 8 — Обновление полоски здоровья

```swift
func updateBossHealthBar() {
    let barWidth: CGFloat = 200
    let ratio = CGFloat(bossHP) / CGFloat(bossMaxHP)
    let fillWidth = max(0, barWidth * ratio)

    // Пересоздаём заливку с новой шириной
    let newFill = SKShapeNode(
        rectOf: CGSize(width: fillWidth, height: 14),
        cornerRadius: 5
    )
    newFill.fillColor = bossHPColor()
    newFill.strokeColor = .clear
    // Прижимаем заливку к левому краю полоски
    newFill.position = CGPoint(
        x: size.width / 2 - barWidth / 2 + fillWidth / 2,
        y: bossHPFill.position.y
    )
    newFill.zPosition = 11
    newFill.alpha = bossHPFill.alpha

    bossHPFill.removeFromParent()
    bossHPFill = newFill
    addChild(bossHPFill)

    bossHPLabel.text = "BOSS HP: \(bossHP)/\(bossMaxHP)"
    bossHPLabel.fontColor = bossHPColor()
}

// Цвет зависит от оставшегося здоровья
func bossHPColor() -> SKColor {
    let ratio = Double(bossHP) / Double(bossMaxHP)
    if ratio > 0.5 { return .rgb(80, 220, 80)  }   // > 50% — зелёный
    if ratio > 0.25 { return .rgb(255, 200, 0) }    // > 25% — жёлтый
    return .rgb(255, 60, 60)                          // < 25% — красный
}
```

▶ **Запустить** — нажимай на босса и смотри как полоска убывает и меняет цвет.

---

### Шаг 9 — Победа над боссом

```swift
func defeatBoss() {
    bossActive = false
    boss.removeAllActions()

    // Большой взрыв
    boss.run(SKAction.group([
        SKAction.scale(to: 4.0, duration: 0.3),
        SKAction.fadeOut(withDuration: 0.3)
    ])) {
        self.boss.alpha = 0
        self.boss.setScale(1.0)
        self.bossDefeatedCelebration()
    }
}

func bossDefeatedCelebration() {
    // Прячем полоску здоровья
    childNode(withName: "bossHPBg")?.run(SKAction.fadeOut(withDuration: 0.5))
    bossHPFill.run(SKAction.fadeOut(withDuration: 0.5))
    bossHPLabel.run(SKAction.fadeOut(withDuration: 0.5))

    showMessage("💥 BOSS УНИЧТОЖЕН!", color: .rgb(255, 220, 0))

    destroyCount += 1
    scoreLabel.text = "Уничтожено: \(destroyCount)"

    // Конфетти
    let colors: [SKColor] = [.rgb(255,80,80), .rgb(80,255,80), .rgb(80,150,255), .rgb(255,220,0)]
    for _ in 0..<20 {
        let dot = SKShapeNode(circleOfRadius: CGFloat.random(in: 3...8))
        dot.fillColor = colors.randomElement()!
        dot.strokeColor = .clear
        dot.position = CGPoint(
            x: CGFloat.random(in: 60...(size.width - 60)),
            y: CGFloat.random(in: size.height * 0.3...size.height * 0.8)
        )
        dot.zPosition = 15
        addChild(dot)
        dot.run(SKAction.sequence([
            SKAction.moveBy(x: CGFloat.random(in: -60...60), y: -size.height * 0.5,
                            duration: Double.random(in: 1.0...2.5)),
            SKAction.removeFromParent()
        ]))
    }

    // Возвращаем астероид через 3 сек, босс снова через 15 сек
    run(SKAction.sequence([
        SKAction.wait(forDuration: 3.0),
        SKAction.run {
            self.asteroid.run(SKAction.fadeIn(withDuration: 0.5))
            self.flyAcrossScreen()
            self.run(SKAction.sequence([
                SKAction.wait(forDuration: 15.0),
                SKAction.run { self.spawnBoss() }
            ]))
        }
    ]))
}
```

---

### Шаг 10 — Касания и вспомогательные функции

```swift
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)

    for node in nodes(at: location) {
        if node.name == "boss" || node.parent?.name == "boss" {
            hitBoss()
            return
        }
        if node.name == "asteroid" || node.parent?.name == "asteroid" {
            explodeAsteroid()
            return
        }
    }
}

func explodeAsteroid() {
    destroyCount += 1
    scoreLabel.text = "Уничтожено: \(destroyCount)"

    if destroyCount % 5 == 0 {
        asteroidSpeed = max(1.5, asteroidSpeed - 0.5)
        showMessage("БЫСТРЕЕ! 🔥", color: .rgb(255, 150, 0))
    }

    asteroid.removeAction(forKey: "fly")
    asteroid.run(SKAction.sequence([
        SKAction.group([
            SKAction.scale(to: 3.0, duration: 0.15),
            SKAction.fadeOut(withDuration: 0.3)
        ]),
        SKAction.run {
            self.asteroid.setScale(1.0)
            self.asteroid.alpha = 1.0
            self.flyAcrossScreen()
        }
    ]))
}

func setupScoreLabel() {
    scoreLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
    scoreLabel.text = "Уничтожено: 0"
    scoreLabel.fontSize = 20
    scoreLabel.fontColor = .white
    scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 55)
    scoreLabel.horizontalAlignmentMode = .center
    scoreLabel.zPosition = 10
    addChild(scoreLabel)
}

func showMessage(_ text: String, color: SKColor) {
    let msg = SKLabelNode(fontNamed: "Helvetica-Bold")
    msg.text = text
    msg.fontSize = 30
    msg.fontColor = color
    msg.position = CGPoint(x: size.width / 2, y: size.height / 2)
    msg.zPosition = 20
    msg.setScale(0.5)
    addChild(msg)
    msg.run(SKAction.sequence([
        SKAction.scale(to: 1.0, duration: 0.2),
        SKAction.wait(forDuration: 1.0),
        SKAction.fadeOut(withDuration: 0.4),
        SKAction.removeFromParent()
    ]))
}
```

▶ **Запустить финальную версию** — полная игра с астероидом и боссом!

---

## Частые ошибки на этом уроке

| Ошибка | Причина | Решение |
|---|---|---|
| Босс появляется дважды | Нет `guard !bossActive` | Добавить проверку флага в `spawnBoss()` |
| Нажатие на кратер босса не считается | Проверяем только `node.name` | Добавить `node.parent?.name == "boss"` |
| Полоска не убывает | `bossHPFill` не обновляется | Убедиться что `bossHPFill` пересоздаётся в `updateBossHealthBar()` |
| Босс не останавливается при ударе | Забыли `removeAction(forKey: "patrol")` | Добавить в начало `hitBoss()` |
| Астероид не возвращается после босса | Забыли `fadeIn` и `flyAcrossScreen()` | Добавить в `bossDefeatedCelebration()` |
| Вращение останавливается при взрыве | `removeAllActions()` убивает spin | Использовать конкретный ключ или запускать spin заново |
| Потряхивание смещает босса навсегда | `moveBy` меняет позицию | Это нормально для маленьких значений — `x: 6` почти незаметно |

---

## Домашнее задание

### Задание

Сделать несколько обычных астероидов разного размера которые летят одновременно пока нет босса.

**Конкретно:**
1. Создать массив `var asteroids: [SKSpriteNode] = []`
2. Написать функцию `createAsteroid(size: CGFloat) -> SKSpriteNode`
3. При старте создать **3 астероида** разного размера (40, 60, 80) и запустить каждый
4. При появлении босса — все астероиды исчезают, после победы — возвращаются
5. ⭐ **Бонус:** маленькие астероиды летят быстрее больших

### Подсказка

```swift
// Скрыть все астероиды
for asteroid in asteroids {
    asteroid.removeAction(forKey: "fly")
    asteroid.run(SKAction.fadeOut(withDuration: 0.5))
}

// Показать все астероиды
for asteroid in asteroids {
    asteroid.run(SKAction.fadeIn(withDuration: 0.5))
    flyAsteroid(asteroid)
}
```