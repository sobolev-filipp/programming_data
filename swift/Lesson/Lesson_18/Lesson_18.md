# Урок 18 — Звуки и частицы в игре
**Полный план для учителя · 45 минут · Возраст 12 лет**

> **Как устроен урок.** Тема — эффекты, поэтому перед проектом идёт раздел **«🔍 Разбор новых команд»**: там разобрана каждая новая команда (частицы `SKEmitterNode`, звук `playSoundFileNamed`, музыка `SKAudioNode`). После каждого шага проекта — блок **«🔍 Разбор кода»**: что за что отвечает. В конце — **полный код** с секциями `// MARK:`. Рядом держим открытым [Справочник](../../Справочник.md) для быстрого поиска.

---

## Цель урока

Ребёнок делает **новый проект «Салют»** — самый зрелищный из всего курса. Касание запускает ракету со светящимся хвостом; наверху она взрывается облаком разлетающихся частиц; играют звуки запуска и взрыва, фоном идёт музыка. За урок ребёнок понимает систему частиц `SKEmitterNode` (главный инструмент для взрывов, огня, дыма) и как добавлять звук в игру.

---

## Таймлайн урока

| Время | Что делаем |
|---|---|
| 0–5 мин | Разминка — вспоминаем прошлый урок |
| 5–18 мин | Теория: частицы и звук в SpriteKit |
| 18–40 мин | Пишем проект «Салют» |
| 40–45 мин | Запускаем, объясняем домашнее задание |

---

## Часть 1 — Разминка (5 минут)

**Спроси ребёнка (по уроку 17 «Защита базы»):**
- Как спрятать данные внутрь объекта? (`userData` — «карман» узла)
- Как узнать, что лежит под пальцем? (`nodes(at: location)`)
- Как перебрать все объекты с именем? (`enumerateChildNodes(withName:)`)
- Что делает `enum` и `switch`? (именованные варианты + выбор по варианту)
- Покажи домашнее задание — как сделал бонус-звезду

---

## Часть 2 — Теория: частицы и звук (13 минут)

### Что такое частицы (SKEmitterNode)

Частицы — это **много маленьких объектов**, которые «фабрика частиц» создаёт сама: взрыв, огонь, дым, дождь, снег, искры. Ты не создаёшь сотни спрайтов вручную — ты настраиваешь **одну фабрику** (`SKEmitterNode`) и говоришь: «сыпь такие-то частицы вот так». Дальше SpriteKit делает всё сам.

> **Аналогия с Godot:** `SKEmitterNode` — это как `GPUParticles2D` / `CPUParticles2D` в Godot. Задал параметры (сколько, куда, как быстро, какого цвета) — и получил эффект.

---

### Два способа создать частицы

**Способ 1 — визуальный редактор (как в Godot).** В Xcode: `File → New → File → SpriteKit Particle File`, выбрать шаблон (`Fire`, `Smoke`, `Spark`, `Rain`, `Snow`), назвать, например `Explosion.sks`. Потом покрутить ползунки в правой панели и загрузить в коде:

```swift
if let explosion = SKEmitterNode(fileNamed: "Explosion") {
    explosion.position = point
    addChild(explosion)
}
```

**Способ 2 — прямо в коде (мы будем так).** Создаём `SKEmitterNode()` и настраиваем свойства кодом. Плюс: всё видно в одном месте, легко менять цвет «на лету» (у нас салюты разного цвета), проект работает без лишних файлов.

> **Для урока выбираем код** — так ребёнок понимает, что означает каждый параметр. Про редактор `.sks` расскажи как бонус: «то же самое можно крутить мышкой».

---

### Главные параметры частиц

| Свойство | Что делает |
|---|---|
| `particleBirthRate` | сколько частиц рождается в секунду |
| `numParticlesToEmit` | всего частиц (`0` = бесконечно; число = разовый залп) |
| `particleLifetime` | сколько секунд живёт каждая частица |
| `emissionAngle` | направление вылета (в радианах) |
| `emissionAngleRange` | разброс направления (`.pi * 2` = во все стороны) |
| `particleSpeed` | скорость частиц |
| `particleScale` | размер частиц |
| `particleScaleSpeed` | как меняется размер (минус = уменьшаются) |
| `particleAlpha` / `particleAlphaSpeed` | прозрачность и как гаснут |
| `particleColor` | цвет (нужен `particleColorSequence = nil`!) |
| `yAcceleration` | «гравитация» частиц (минус = падают вниз) |

---

### Звук в SpriteKit

Два инструмента:

- **Короткий звук-эффект** (выстрел, взрыв) — `SKAction.playSoundFileNamed`.
- **Фоновая музыка** (играет по кругу) — `SKAudioNode`.

```swift
// Разовый звук
run(SKAction.playSoundFileNamed("boom.wav", waitForCompletion: false))

// Зацикленная музыка
let music = SKAudioNode(fileNamed: "music.m4a")
music.autoplayLooped = true
addChild(music)
```

> **Важно:** звук играет, только если **файл добавлен в проект**. В шаге про звук разберём, как это сделать. И сделаем так, чтобы игра не падала, даже если файлов пока нет.

---

## 🔍 Разбор новых команд, которые встретятся в проекте

> Частицы описываются десятком свойств — разберём их на двух примерах: **шлейф** (сыплется бесконечно, пока летит ракета) и **взрыв** (один залп во все стороны).

---

### 1. `SKEmitterNode` — фабрика частиц

Создаём фабрику и настраиваем:

```swift
let burst = SKEmitterNode()
burst.particleTexture = dotTexture       // как выглядит одна частица (кружок)
burst.numParticlesToEmit = 120           // всего 120 частиц — и стоп
burst.particleBirthRate = 4000           // рождаются почти разом → залп
burst.particleLifetime = 1.2             // живут 1.2 секунды
burst.emissionAngle = 0
burst.emissionAngleRange = .pi * 2       // летят во ВСЕ стороны (полный круг)
burst.particleSpeed = 180                // скорость разлёта
burst.particleColor = color
burst.particleColorBlendFactor = 1.0
burst.particleColorSequence = nil        // ← без этого цвет не применится!
burst.position = point
addChild(burst)
```

**Разбор ключевых свойств:**

| Свойство | Смысл на примере взрыва |
|---|---|
| `numParticlesToEmit = 120` | ровно 120 искр (для шлейфа поставим `0` = бесконечно) |
| `particleBirthRate = 4000` | 4000 в секунду → все 120 вылетают за ~0.03 сек = «бах» |
| `emissionAngleRange = .pi * 2` | разброс на полный круг → шар искр |
| `particleSpeed = 180` | как далеко разлетаются |
| `particleScaleSpeed = -0.3` | искры уменьшаются со временем |
| `particleAlphaSpeed = -0.8` | искры гаснут (прозрачнеют) |

> **Объясни ребёнку:** одна фабрика заменяет 120 спрайтов. Ты не создаёшь каждую искру — ты описываешь «правила», а SpriteKit делает искры сам. `.pi * 2` — это полный круг в радианах (мы их проходили в уроке 17 для поворота пушки).

---

### 2. `particleColorSequence = nil` — частая ловушка

У `SKEmitterNode` есть «цветовая дорожка» (`particleColorSequence`) — она может менять цвет частиц по времени. **Пока она задана, свойство `particleColor` игнорируется.** Чтобы наш цвет применился, дорожку надо обнулить:

```swift
burst.particleColor = color
burst.particleColorBlendFactor = 1.0
burst.particleColorSequence = nil   // теперь частицы будут нужного цвета
```

> **Запомни правило:** задаёшь `particleColor` вручную — обязательно `particleColorSequence = nil`. Иначе частицы получатся не того цвета (обычно белёсые). Это ошибка №1 новичков с частицами.

---

### 3. `targetNode` — чтобы хвост «оставался в воздухе»

Шлейф — это фабрика частиц, которую мы вешаем **на ракету** (`rocket.addChild(trail)`). Но если ничего не сделать, уже вылетевшие искры будут тянуться за ракетой, как приклеенные. Нам нужно, чтобы искра, родившись, **осталась на месте** в небе, а ракета летела дальше.

```swift
trail.targetNode = self   // рождённые частицы живут в сцене, а не внутри ракеты
```

> **Объясни ребёнку:** без `targetNode` хвост двигается вместе с ракетой — как будто искры нарисованы на ней. С `targetNode = self` каждая искра «отрывается» и остаётся в небе — получается настоящий след.

---

### 4. `numParticlesToEmit` — залп или поток

Одно свойство решает, какой это эффект:

```swift
burst.numParticlesToEmit = 120   // РОВНО 120 частиц и стоп → взрыв (разовый залп)
trail.numParticlesToEmit = 0     // 0 = бесконечно → поток (хвост, огонь, дым)
```

- **Взрыв** — залп: `numParticlesToEmit` = число.
- **Хвост / огонь / дым** — поток: `numParticlesToEmit = 0` (сыплет, пока фабрика жива).

---

### 5. `yAcceleration` — «гравитация» частиц

Чтобы искры салюта красиво **опадали вниз**, а не разлетались по прямой, добавляем ускорение вниз:

```swift
burst.yAcceleration = -120   // частицы тянет вниз, как настоящие искры
```

Минус — значит вниз (Y растёт вверх, помнишь из урока 13). Есть и `xAcceleration` — тянуть вбок (например, «ветер»).

---

### 6. `SKAction.playSoundFileNamed` — короткий звук

```swift
run(SKAction.playSoundFileNamed("boom.wav", waitForCompletion: false))
```

- Проигрывает звуковой файл один раз.
- `waitForCompletion: false` — «не жди конца звука, играй дальше». Если `true` — действие будет длиться, пока звук не доиграет (нужно редко).
- Файл (`boom.wav`) должен быть **добавлен в проект**.

---

### 7. `SKAudioNode` — фоновая музыка по кругу

```swift
let music = SKAudioNode(fileNamed: "music.m4a")
music.autoplayLooped = true   // играть по кругу, без конца
addChild(music)
```

`SKAudioNode` — это узел-«колонка». Добавили на сцену — музыка заиграла. `autoplayLooped = true` зацикливает её.

> **Разница:** `playSoundFileNamed` — для коротких «бах/пиу» (можно запускать сотни раз). `SKAudioNode` — для одной длинной фоновой музыки.

---

### 8. Текстура-точка из фигуры + `Bundle.main.url`

**Своя «картинка» для частицы.** По умолчанию частицы — блёклые квадратики. Чтобы искры были красивыми кружками, нарисуем кружок и превратим его в текстуру:

```swift
func makeDotTexture() -> SKTexture {
    let dot = SKShapeNode(circleOfRadius: 5)
    dot.fillColor = .white
    dot.strokeColor = .clear
    dot.glowWidth = 2                          // лёгкое свечение
    return SKView().texture(from: dot) ?? SKTexture()   // фигуру → в картинку
}
```

`SKView().texture(from:)` «фотографирует» фигуру и отдаёт готовую текстуру. Делаем один раз и переиспользуем (через `lazy var` — свойство посчитается при первом обращении).

**Проверка наличия файла.** Чтобы игра не падала, если звук ещё не добавлен, сначала спросим, есть ли файл:

```swift
func playSound(_ fileName: String) {
    if Bundle.main.url(forResource: fileName, withExtension: nil) != nil {
        run(SKAction.playSoundFileNamed(fileName, waitForCompletion: false))
    }
}
```

`Bundle.main.url(forResource:withExtension:)` — «есть ли такой файл в проекте?». Есть → играем, нет → просто пропускаем. Так игру можно запустить и без звуков.

---

## Часть 3 — Проект «Салют» (22 минуты)

### Что делает проект

- Ночное небо со звёздами и силуэтом города внизу
- Касание в любом месте → снизу взлетает ракета со **светящимся хвостом**
- Наверху ракета **взрывается** облаком разлетающихся искр (частицы)
- Искры нужного цвета, красиво **опадают вниз**
- Играют звуки **запуска** и **взрыва**, фоном — музыка
- Несколько пальцев = несколько салютов сразу; счётчик запусков

---

### Шаг 1 — Проект и скелет

```
File → New → Project → iOS → Game → Fireworks
```

Заменить `GameViewController.swift`, очистить `GameScene.swift`:

```swift
import SpriteKit

extension SKColor {
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> SKColor {
        return SKColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
}

class GameScene: SKScene {

    var countLabel: SKLabelNode!
    var launched = 0

    // Палитра цветов салютов
    let fireColors: [SKColor] = [
        .rgb(255, 80, 80), .rgb(255, 200, 0), .rgb(80, 200, 255),
        .rgb(120, 255, 120), .rgb(220, 120, 255), .rgb(255, 140, 0)
    ]

    // Текстура-точка для частиц (создаётся один раз)
    lazy var dotTexture: SKTexture = makeDotTexture()

    override func didMove(to view: SKView) {
        setupSky()
    }
}
```

**🔍 Разбор кода — что за что отвечает:**

- `extension SKColor { rgb }` — привычные числа 0–255 для цветов.
- `countLabel`, `launched` — метка и счётчик запущенных салютов.
- `fireColors` — массив цветов; для каждого салюта возьмём случайный (`.randomElement()`).
- `lazy var dotTexture` — картинка-кружок для частиц. `lazy` значит «посчитается при первом обращении, а не сразу» — потому что для неё нужен `SKView`, которого в момент создания класса ещё нет.
- `didMove` пока зовёт только `setupSky()` — будем добавлять по шагам.

---

### Шаг 2 — Небо, звёзды и город

```swift
func setupSky() {
    backgroundColor = .rgb(8, 10, 30)
    for _ in 0..<80 {
        let star = SKShapeNode(circleOfRadius: CGFloat.random(in: 0.5...1.8))
        star.fillColor = .white
        star.strokeColor = .clear
        star.alpha = CGFloat.random(in: 0.2...0.8)
        star.position = CGPoint(
            x: CGFloat.random(in: 0...size.width),
            y: CGFloat.random(in: size.height * 0.4...size.height)  // звёзды только вверху
        )
        addChild(star)
    }
}

func setupCity() {
    var x: CGFloat = 0
    while x < size.width {
        let w = CGFloat.random(in: 30...70)
        let h = CGFloat.random(in: 40...150)

        let house = SKSpriteNode(color: .rgb(14, 16, 38), size: CGSize(width: w, height: h))
        house.anchorPoint = CGPoint(x: 0, y: 0)   // отсчёт от левого нижнего угла
        house.position = CGPoint(x: x, y: 0)
        house.zPosition = 1
        addChild(house)

        // Пара светящихся окошек
        for _ in 0..<Int.random(in: 1...4) {
            let win = SKSpriteNode(color: .rgb(255, 220, 120), size: CGSize(width: 4, height: 4))
            win.position = CGPoint(x: CGFloat.random(in: 6...(w - 6)),
                                   y: CGFloat.random(in: 10...(h - 6)))
            win.alpha = CGFloat.random(in: 0.4...0.9)
            house.addChild(win)
        }

        x += w + CGFloat.random(in: 2...10)
    }
}
```

Добавить вызов в `didMove`:

```swift
override func didMove(to view: SKView) {
    setupSky()
    setupCity()     // ← добавили
}
```

▶ **Запустить** — тёмное небо со звёздами и силуэт города с окошками внизу.

**🔍 Разбор кода — что за что отвечает:**

- `setupSky` — тёмный фон + 80 звёзд. Звёзды ставим только в верхних 60% экрана (`size.height * 0.4...size.height`), чтобы не залезали в город.
- `setupCity` — рисуем дома в цикле `while x < size.width`, двигаясь слева направо.
  - `anchorPoint = (0, 0)` — «якорь» дома в левом нижнем углу, поэтому дом «стоит на земле» (y = 0), а не висит центром.
  - у каждого дома 1–4 жёлтых окошка (маленькие спрайты, добавлены **к дому** — поедут вместе с ним).
  - `x += w + случайный зазор` — сдвигаемся к следующему дому.

> **Почему `anchorPoint = (0, 0)`?** По умолчанию якорь спрайта в центре (0.5, 0.5), и `position` — это где центр. Сдвинув якорь в угол, удобно «ставить» дома на пол: их низ ровно на y = 0.

---

### Шаг 3 — Текстура частицы и счётчик

```swift
func makeDotTexture() -> SKTexture {
    let dot = SKShapeNode(circleOfRadius: 5)
    dot.fillColor = .white
    dot.strokeColor = .clear
    dot.glowWidth = 2
    return SKView().texture(from: dot) ?? SKTexture()
}

func setupHUD() {
    countLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
    countLabel.text = "Салютов: 0"
    countLabel.fontSize = 22
    countLabel.fontColor = .white
    countLabel.position = CGPoint(x: size.width / 2, y: size.height - 60)
    countLabel.zPosition = 10
    addChild(countLabel)
}
```

Добавить в `didMove`:

```swift
setupHUD()   // ← добавили
```

**🔍 Разбор кода — что за что отвечает:**

- `makeDotTexture` — рисуем белый кружок с лёгким свечением (`glowWidth`) и «фотографируем» его в текстуру через `SKView().texture(from:)`. Эту картинку дадим частицам, чтобы искры были круглыми и светящимися (разбирали выше).
- `?? SKTexture()` — если вдруг не получилось, вернём пустую текстуру (страховка от `nil`).
- `setupHUD` — надпись «Салютов: 0» сверху по центру.

---

### Шаг 4 — Запуск ракеты по касанию

Сначала — только полёт ракеты вверх (без хвоста и взрыва, их добавим следом).

```swift
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {                       // каждый палец — свой салют
        let target = touch.location(in: self)
        launchFirework(to: target)
    }
}

func launchFirework(to target: CGPoint) {
    let color = fireColors.randomElement()!

    // Салют всегда поднимается достаточно высоко
    let apex = CGPoint(x: target.x, y: max(target.y, size.height * 0.35))

    // Ракета — маленький светящийся кружок
    let rocket = SKShapeNode(circleOfRadius: 4)
    rocket.fillColor = color
    rocket.strokeColor = .white
    rocket.glowWidth = 3
    rocket.position = CGPoint(x: apex.x, y: 0)   // старт снизу
    rocket.zPosition = 5
    addChild(rocket)

    // Летит вверх и исчезает
    let duration = TimeInterval(apex.y / 500)    // скорость подъёма
    let moveUp = SKAction.move(to: apex, duration: max(0.3, duration))
    moveUp.timingMode = .easeOut

    rocket.run(SKAction.sequence([
        moveUp,
        SKAction.removeFromParent()
    ]))

    launched += 1
    countLabel.text = "Салютов: \(launched)"
}
```

▶ **Запустить** — при касании снизу взлетает светящаяся точка и исчезает. Пальцами можно запускать сразу несколько.

**🔍 Разбор кода — что за что отвечает:**

- `for touch in touches` — перебираем **все** касания, поэтому несколькими пальцами запускаем несколько ракет разом.
- `let color = fireColors.randomElement()!` — случайный цвет салюта.
- `apex` — «вершина», куда взлетит ракета. `max(target.y, size.height * 0.35)` гарантирует, что даже если ткнуть низко, ракета поднимется хотя бы на 35% высоты.
- `rocket` — светящийся кружок; стартует внизу под точкой касания (`y: 0`).
- `duration = apex.y / 500` — время подъёма зависит от высоты (скорость ≈ 500 точек/сек), `timingMode = .easeOut` — ракета плавно тормозит к вершине.
- `sequence([moveUp, removeFromParent])` — взлетела и исчезла (взрыв добавим на следующем шаге).
- обновляем счётчик.

---

### Шаг 5 — Светящийся хвост (частицы-поток)

Добавляем фабрику частиц и вешаем её на ракету.

```swift
func makeTrail(color: SKColor) -> SKEmitterNode {
    let trail = SKEmitterNode()
    trail.particleTexture = dotTexture
    trail.particleBirthRate = 120
    trail.numParticlesToEmit = 0            // 0 = бесконечно, пока живёт ракета
    trail.particleLifetime = 0.4
    trail.particleLifetimeRange = 0.2
    trail.particlePositionRange = CGVector(dx: 3, dy: 3)
    trail.emissionAngle = -.pi / 2          // сыплется вниз
    trail.emissionAngleRange = .pi / 4
    trail.particleSpeed = 10
    trail.particleSpeedRange = 10
    trail.particleScale = 0.25
    trail.particleScaleRange = 0.1
    trail.particleScaleSpeed = -0.4         // частицы уменьшаются
    trail.particleAlpha = 0.9
    trail.particleAlphaSpeed = -2.0         // и быстро гаснут
    trail.particleColor = color
    trail.particleColorBlendFactor = 1.0
    trail.particleColorSequence = nil       // ВАЖНО: иначе цвет не применится
    trail.targetNode = self                 // искры остаются в небе, не тянутся за ракетой
    trail.zPosition = 4
    return trail
}
```

Подключить хвост в `launchFirework` — сразу после `addChild(rocket)`:

```swift
addChild(rocket)
rocket.addChild(makeTrail(color: color))   // ← добавили хвост
```

▶ **Запустить** — за ракетой тянется светящийся след её цвета.

**🔍 Разбор кода — что за что отвечает:**

- `numParticlesToEmit = 0` — поток без конца: сыплет искры, пока хвост существует (а он живёт вместе с ракетой).
- `emissionAngle = -.pi/2` + `emissionAngleRange = .pi/4` — искры летят **вниз** с небольшим разбросом (ракета вверх — хвост вниз).
- `particleScaleSpeed = -0.4` и `particleAlphaSpeed = -2.0` — искры на лету уменьшаются и гаснут → красивый затухающий след.
- `particleColorSequence = nil` — чтобы искры были цвета ракеты (та самая ловушка из разбора).
- `targetNode = self` — **самое важное:** родившаяся искра остаётся на месте в небе, а ракета летит дальше. Без этого след «прилип» бы к ракете.
- `rocket.addChild(makeTrail(...))` — хвост едет за ракетой; когда ракета исчезнет, фабрика тоже исчезнет, а уже вылетевшие искры (благодаря `targetNode`) спокойно догорят.

---

### Шаг 6 — Взрыв (частицы-залп)

```swift
func explode(at position: CGPoint, color: SKColor) {
    let burst = SKEmitterNode()
    burst.particleTexture = dotTexture
    burst.numParticlesToEmit = 120          // разовый залп
    burst.particleBirthRate = 4000          // все частицы почти разом
    burst.particleLifetime = 1.2
    burst.particleLifetimeRange = 0.5
    burst.emissionAngle = 0
    burst.emissionAngleRange = .pi * 2      // во все стороны — круг
    burst.particleSpeed = 180
    burst.particleSpeedRange = 80
    burst.yAcceleration = -120              // искры плавно падают
    burst.particleScale = 0.4
    burst.particleScaleRange = 0.2
    burst.particleScaleSpeed = -0.3
    burst.particleAlpha = 1.0
    burst.particleAlphaSpeed = -0.8
    burst.particleColor = color
    burst.particleColorBlendFactor = 1.0
    burst.particleColorSequence = nil
    burst.position = position
    burst.zPosition = 6
    addChild(burst)

    // Короткая вспышка света
    let flash = SKShapeNode(circleOfRadius: 30)
    flash.fillColor = color
    flash.strokeColor = .clear
    flash.alpha = 0.6
    flash.position = position
    flash.zPosition = 5
    addChild(flash)
    flash.run(SKAction.sequence([
        SKAction.group([
            SKAction.scale(to: 2.5, duration: 0.3),
            SKAction.fadeOut(withDuration: 0.3)
        ]),
        SKAction.removeFromParent()
    ]))

    // Убрать фабрику, когда искры догорят
    burst.run(SKAction.sequence([
        SKAction.wait(forDuration: 2.0),
        SKAction.removeFromParent()
    ]))
}
```

Вызвать взрыв в вершине полёта. Меняем `sequence` ракеты в `launchFirework`:

```swift
rocket.run(SKAction.sequence([
    moveUp,
    SKAction.run { [weak self] in
        self?.explode(at: apex, color: color)   // ← взрыв наверху
    },
    SKAction.removeFromParent()
]))
```

▶ **Запустить** — наверху ракета взрывается облаком искр своего цвета, которые разлетаются и опадают. Готовый салют!

**🔍 Разбор кода — что за что отвечает:**

- `numParticlesToEmit = 120` + `particleBirthRate = 4000` → все 120 искр вылетают за миг = «бах».
- `emissionAngleRange = .pi * 2` — искры летят во все стороны (шар).
- `yAcceleration = -120` — искры опадают вниз, как настоящий салют.
- `particleScaleSpeed`, `particleAlphaSpeed` (минусовые) — искры уменьшаются и гаснут.
- `flash` — короткая яркая вспышка в момент взрыва (растёт и тает) — добавляет «мощи».
- `burst.run(wait 2 сек → removeFromParent)` — убираем фабрику, когда искры догорели (иначе пустые фабрики копились бы на сцене).
- `SKAction.run { [weak self] in self?.explode(...) }` — в середине полёта вызываем взрыв. `[weak self]` — чтобы сцена не «зависла» в памяти (безопасная ссылка на себя внутри замыкания).

> **Почему взрыв — отдельная функция?** Её удобно вызывать откуда угодно (в домашке — из «финала»), и код читается: «долетел → `explode` → исчез».

---

### Шаг 7 — Звуки запуска и взрыва

**Сначала добавь звуковые файлы в проект:**
1. Возьми три коротких файла: `launch.wav` (свист запуска), `boom.wav` (хлопок взрыва), и по желанию `music.m4a` (фоновая музыка). Подойдут любые короткие бесплатные звуки.
2. Перетащи их в левую панель Xcode (в список файлов проекта).
3. В появившемся окне поставь галочку **«Copy items if needed»** и убедись, что стоит галочка у твоего проекта в **«Add to targets»**. Нажми **Finish**.

Теперь добавь безопасный проигрыватель и вызовы:

```swift
func playSound(_ fileName: String) {
    if Bundle.main.url(forResource: fileName, withExtension: nil) != nil {
        run(SKAction.playSoundFileNamed(fileName, waitForCompletion: false))
    }
}
```

- В `launchFirework` — после `addChild(rocket)`:

```swift
playSound("launch.wav")   // свист запуска
```

- В `explode` — после `addChild(burst)`:

```swift
playSound("boom.wav")     // хлопок взрыва
```

▶ **Запустить** — теперь салют со звуком! (Если файлы не добавил — игра всё равно работает, просто без звука.)

**🔍 Разбор кода — что за что отвечает:**

- `playSound(_:)` — наша обёртка над `playSoundFileNamed`. Сначала проверяет `Bundle.main.url(...)` — есть ли файл в проекте. Есть → играет, нет → тихо пропускает.
- `waitForCompletion: false` — «играй и не жди, пока доиграет» (нам не нужно, чтобы ракета «ждала» звук).

> **Зачем проверка файла?** `playSoundFileNamed` с несуществующим файлом может уронить приложение. Обёртка `playSound` защищает: ребёнок запустит игру и увидит салют даже до того, как разберётся со звуками.

---

### Шаг 8 — Фоновая музыка

```swift
func startMusic() {
    if let url = Bundle.main.url(forResource: "music", withExtension: "m4a") {
        let music = SKAudioNode(url: url)
        music.autoplayLooped = true
        addChild(music)
    }
}
```

Добавить в `didMove`:

```swift
startMusic()   // ← добавили
```

▶ **Запустить** — если добавил `music.m4a`, фоном заиграет зацикленная музыка.

**🔍 Разбор кода — что за что отвечает:**

- `Bundle.main.url(forResource: "music", withExtension: "m4a")` — ищем файл музыки; `if let` войдёт внутрь, только если он есть (снова защита от падения).
- `SKAudioNode(url:)` — узел-«колонка».
- `autoplayLooped = true` — играть по кругу.
- `addChild(music)` — добавили на сцену → музыка пошла.

---

### Полный код GameScene.swift

> Ниже — весь проект целиком, с секциями `// MARK:` (появляются в списке над редактором Xcode) и подсказками на хитрых строках.

```swift
import SpriteKit

// MARK: - RGB расширение (привычные числа 0–255)

extension SKColor {
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> SKColor {
        return SKColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
}

// MARK: - Сцена

class GameScene: SKScene {

    var countLabel: SKLabelNode!
    var launched = 0

    // Палитра цветов салютов
    let fireColors: [SKColor] = [
        .rgb(255, 80, 80), .rgb(255, 200, 0), .rgb(80, 200, 255),
        .rgb(120, 255, 120), .rgb(220, 120, 255), .rgb(255, 140, 0)
    ]

    // Текстура-точка для частиц (создаётся один раз и переиспользуется)
    lazy var dotTexture: SKTexture = makeDotTexture()

    // MARK: - Загрузка

    override func didMove(to view: SKView) {
        setupSky()
        setupCity()
        setupHUD()
        startMusic()
    }

    // MARK: - Небо и звёзды

    func setupSky() {
        backgroundColor = .rgb(8, 10, 30)
        for _ in 0..<80 {
            let star = SKShapeNode(circleOfRadius: CGFloat.random(in: 0.5...1.8))
            star.fillColor = .white
            star.strokeColor = .clear
            star.alpha = CGFloat.random(in: 0.2...0.8)
            star.position = CGPoint(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: size.height * 0.4...size.height)
            )
            addChild(star)
        }
    }

    // MARK: - Силуэт города

    func setupCity() {
        var x: CGFloat = 0
        while x < size.width {
            let w = CGFloat.random(in: 30...70)
            let h = CGFloat.random(in: 40...150)

            let house = SKSpriteNode(color: .rgb(14, 16, 38), size: CGSize(width: w, height: h))
            house.anchorPoint = CGPoint(x: 0, y: 0)     // отсчёт от левого нижнего угла
            house.position = CGPoint(x: x, y: 0)
            house.zPosition = 1
            addChild(house)

            for _ in 0..<Int.random(in: 1...4) {        // светящиеся окошки
                let win = SKSpriteNode(color: .rgb(255, 220, 120), size: CGSize(width: 4, height: 4))
                win.position = CGPoint(x: CGFloat.random(in: 6...(w - 6)),
                                       y: CGFloat.random(in: 10...(h - 6)))
                win.alpha = CGFloat.random(in: 0.4...0.9)
                house.addChild(win)
            }

            x += w + CGFloat.random(in: 2...10)
        }
    }

    // MARK: - Счётчик

    func setupHUD() {
        countLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        countLabel.text = "Салютов: 0"
        countLabel.fontSize = 22
        countLabel.fontColor = .white
        countLabel.position = CGPoint(x: size.width / 2, y: size.height - 60)
        countLabel.zPosition = 10
        addChild(countLabel)
    }

    // MARK: - Текстура частицы (кружок → картинка)

    func makeDotTexture() -> SKTexture {
        let dot = SKShapeNode(circleOfRadius: 5)
        dot.fillColor = .white
        dot.strokeColor = .clear
        dot.glowWidth = 2
        return SKView().texture(from: dot) ?? SKTexture()
    }

    // MARK: - Звук (безопасно: не падаем, если файла нет)

    func playSound(_ fileName: String) {
        if Bundle.main.url(forResource: fileName, withExtension: nil) != nil {
            run(SKAction.playSoundFileNamed(fileName, waitForCompletion: false))
        }
    }

    // MARK: - Фоновая музыка (зациклена)

    func startMusic() {
        if let url = Bundle.main.url(forResource: "music", withExtension: "m4a") {
            let music = SKAudioNode(url: url)
            music.autoplayLooped = true
            addChild(music)
        }
    }

    // MARK: - Касание — запускаем салют

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {                       // каждый палец — свой салют
            let target = touch.location(in: self)
            launchFirework(to: target)
        }
    }

    // MARK: - Запуск ракеты

    func launchFirework(to target: CGPoint) {
        let color = fireColors.randomElement()!

        // Салют всегда поднимается достаточно высоко
        let apex = CGPoint(x: target.x, y: max(target.y, size.height * 0.35))

        let rocket = SKShapeNode(circleOfRadius: 4)  // светящаяся ракета
        rocket.fillColor = color
        rocket.strokeColor = .white
        rocket.glowWidth = 3
        rocket.position = CGPoint(x: apex.x, y: 0)   // старт снизу
        rocket.zPosition = 5
        addChild(rocket)

        rocket.addChild(makeTrail(color: color))     // хвост
        playSound("launch.wav")                      // свист

        let duration = TimeInterval(apex.y / 500)    // скорость подъёма
        let moveUp = SKAction.move(to: apex, duration: max(0.3, duration))
        moveUp.timingMode = .easeOut

        rocket.run(SKAction.sequence([
            moveUp,
            SKAction.run { [weak self] in            // наверху — взрыв
                self?.explode(at: apex, color: color)
            },
            SKAction.removeFromParent()
        ]))

        launched += 1
        countLabel.text = "Салютов: \(launched)"
    }

    // MARK: - Шлейф ракеты (поток частиц)

    func makeTrail(color: SKColor) -> SKEmitterNode {
        let trail = SKEmitterNode()
        trail.particleTexture = dotTexture
        trail.particleBirthRate = 120
        trail.numParticlesToEmit = 0            // 0 = бесконечно, пока живёт ракета
        trail.particleLifetime = 0.4
        trail.particleLifetimeRange = 0.2
        trail.particlePositionRange = CGVector(dx: 3, dy: 3)
        trail.emissionAngle = -.pi / 2          // сыплется вниз
        trail.emissionAngleRange = .pi / 4
        trail.particleSpeed = 10
        trail.particleSpeedRange = 10
        trail.particleScale = 0.25
        trail.particleScaleRange = 0.1
        trail.particleScaleSpeed = -0.4         // уменьшаются
        trail.particleAlpha = 0.9
        trail.particleAlphaSpeed = -2.0         // и гаснут
        trail.particleColor = color
        trail.particleColorBlendFactor = 1.0
        trail.particleColorSequence = nil       // иначе particleColor игнорируется
        trail.targetNode = self                 // искры остаются в небе
        trail.zPosition = 4
        return trail
    }

    // MARK: - Взрыв (залп частиц)

    func explode(at position: CGPoint, color: SKColor) {
        let burst = SKEmitterNode()
        burst.particleTexture = dotTexture
        burst.numParticlesToEmit = 120          // разовый залп
        burst.particleBirthRate = 4000          // все частицы почти разом
        burst.particleLifetime = 1.2
        burst.particleLifetimeRange = 0.5
        burst.emissionAngle = 0
        burst.emissionAngleRange = .pi * 2      // во все стороны — круг
        burst.particleSpeed = 180
        burst.particleSpeedRange = 80
        burst.yAcceleration = -120              // искры плавно падают
        burst.particleScale = 0.4
        burst.particleScaleRange = 0.2
        burst.particleScaleSpeed = -0.3
        burst.particleAlpha = 1.0
        burst.particleAlphaSpeed = -0.8
        burst.particleColor = color
        burst.particleColorBlendFactor = 1.0
        burst.particleColorSequence = nil
        burst.position = position
        burst.zPosition = 6
        addChild(burst)

        playSound("boom.wav")                   // хлопок

        let flash = SKShapeNode(circleOfRadius: 30)   // вспышка света
        flash.fillColor = color
        flash.strokeColor = .clear
        flash.alpha = 0.6
        flash.position = position
        flash.zPosition = 5
        addChild(flash)
        flash.run(SKAction.sequence([
            SKAction.group([
                SKAction.scale(to: 2.5, duration: 0.3),
                SKAction.fadeOut(withDuration: 0.3)
            ]),
            SKAction.removeFromParent()
        ]))

        burst.run(SKAction.sequence([           // убрать фабрику, когда искры догорят
            SKAction.wait(forDuration: 2.0),
            SKAction.removeFromParent()
        ]))
    }
}
```

---

## Частые ошибки на этом уроке

| Ошибка | Причина | Решение |
|---|---|---|
| Частицы белёсые, не того цвета | Не обнулили `particleColorSequence` | Добавить `particleColorSequence = nil` |
| Хвост «прилип» к ракете | Нет `targetNode` | Поставить `trail.targetNode = self` |
| Частиц не видно вообще | `particleBirthRate = 0` или нет `particleTexture` | Задать birthRate > 0 и текстуру |
| Взрыв «сыплет» без конца | `numParticlesToEmit = 0` у взрыва | Для залпа поставить число (напр. 120) |
| Приложение падает при выстреле | Звукового файла нет в проекте | Проверять файл (`Bundle.main.url`) перед `playSoundFileNamed` |
| Музыка не играет | Файл не добавлен или не в target | Перетащить в проект, галочка «Add to targets» |
| Искры разлетаются по прямой | Нет `yAcceleration` | Добавить `yAcceleration = -120` |

---

## Домашнее задание

### Задание

Добавить в «Салют» **праздничный финал** и **особый золотой салют**.

**Конкретно:**
1. Внизу экрана — кнопка **«ФИНАЛ»**. При нажатии запускаются **8 салютов подряд** в случайных местах верхней половины (с интервалом 0.2 сек).
2. Каждый **10-й** салют — **золотой**: крупнее обычного и с особым цветом.
3. ⭐ **Бонус:** у золотого салюта взрыв — **кольцо** (все частицы летят с одинаковой скоростью → `particleSpeedRange = 0`).

### Подсказка

```swift
// Кнопка (в setupFinaleButton), проверка нажатия — как в уроке 17:
for node in nodes(at: location) {
    if (node.name ?? node.parent?.name) == "finaleButton" {
        launchFinale()
    }
}

// Золотой каждый 10-й:
let isGolden = (launched + 1) % 10 == 0

// Кольцо у золотого взрыва:
burst.particleSpeedRange = isGolden ? 0 : 80
```

### Решение (для учителя — не показывать раньше времени)

Полное решение — в файле **`Урок_18_GameScene_homework_solution.swift`** (кнопка «ФИНАЛ», `launchFinale()` с 8 салютами через `wait`, флаг `isGolden` в `launchFirework`, кольцевой взрыв в `explode(..., golden:)`).
