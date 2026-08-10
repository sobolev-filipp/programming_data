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

    // Текстура-точка для частиц (создаём один раз и переиспользуем)
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

        // Ракета — маленький светящийся кружок
        let rocket = SKShapeNode(circleOfRadius: 4)
        rocket.fillColor = color
        rocket.strokeColor = .white
        rocket.glowWidth = 3
        rocket.position = CGPoint(x: apex.x, y: 0)   // старт снизу
        rocket.zPosition = 5
        addChild(rocket)

        // Хвост-шлейф из частиц
        rocket.addChild(makeTrail(color: color))

        // Звук запуска
        playSound("launch.wav")

        // Летит вверх, наверху — взрыв, затем ракета исчезает
        let duration = TimeInterval(apex.y / 500)    // скорость подъёма
        let moveUp = SKAction.move(to: apex, duration: max(0.3, duration))
        moveUp.timingMode = .easeOut

        rocket.run(SKAction.sequence([
            moveUp,
            SKAction.run { [weak self] in
                self?.explode(at: apex, color: color)
            },
            SKAction.removeFromParent()
        ]))

        launched += 1
        countLabel.text = "Салютов: \(launched)"
    }

    // MARK: - Шлейф ракеты

    func makeTrail(color: SKColor) -> SKEmitterNode {
        let trail = SKEmitterNode()
        trail.particleTexture = dotTexture
        trail.particleBirthRate = 120
        trail.numParticlesToEmit = 0            // 0 = бесконечно (пока живёт ракета)
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
        trail.particleAlphaSpeed = -2.0         // и гаснут
        trail.particleColor = color
        trail.particleColorBlendFactor = 1.0
        trail.particleColorSequence = nil       // ВАЖНО: иначе particleColor игнорируется
        trail.targetNode = self                 // частицы остаются в мире, не тянутся за ракетой
        trail.zPosition = 4
        return trail
    }

    // MARK: - Взрыв

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
        burst.yAcceleration = -120              // частицы плавно падают (как настоящий салют)
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

        // Звук взрыва
        playSound("boom.wav")

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

        // Убрать эмиттер, когда частицы догорят
        burst.run(SKAction.sequence([
            SKAction.wait(forDuration: 2.0),
            SKAction.removeFromParent()
        ]))
    }
}
