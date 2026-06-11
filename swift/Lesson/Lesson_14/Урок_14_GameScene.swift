import SpriteKit

// MARK: - Расширение для удобных RGB цветов
extension SKColor {
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> SKColor {
        return SKColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
}

class GameScene: SKScene {

    // MARK: - Свойства

    var asteroid: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var destroyCount = 0
    var asteroidSpeed = 4.0   // секунды на пролёт экрана

    // MARK: - Загрузка сцены

    override func didMove(to view: SKView) {
        setupBackground()
        setupAsteroid()
        setupScoreLabel()
        startFlying()
    }

    // MARK: - Фон со звёздами

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

    // MARK: - Астероид из фигур

    func setupAsteroid() {
        asteroid = SKSpriteNode(color: .clear, size: CGSize(width: 60, height: 60))

        // Тело — серый круг
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

        // Стартовая позиция — за правым краем (не виден)
        asteroid.position = CGPoint(x: size.width + 50, y: size.height / 2)
        asteroid.name = "asteroid"
        addChild(asteroid)
    }

    // MARK: - Счётчик

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

    // MARK: - Запуск полёта и вращения

    func startFlying() {
        flyAcrossScreen()
        spinAsteroid()
    }

    // Бесконечное вращение — repeatForever
    func spinAsteroid() {
        let spin = SKAction.repeatForever(
            SKAction.rotate(byAngle: .pi * 2, duration: 3.0)  // полный оборот за 3 сек
        )
        asteroid.run(spin, withKey: "spin")
    }

    // Полёт через экран — каждый раз на новой высоте
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

        // nodes(at:) возвращает все спрайты в точке касания
        for node in nodes(at: location) {
            // Проверяем сам астероид или его дочерние элементы (кратеры)
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

        // Каждые 5 взрывов — ускоряем астероид
        if destroyCount % 5 == 0 {
            asteroidSpeed = max(1.5, asteroidSpeed - 0.5)
            showSpeedUpMessage()
        }

        // Останавливаем полёт (вращение продолжается)
        asteroid.removeAction(forKey: "fly")

        // Анимация взрыва: вырасти и исчезнуть одновременно
        let grow    = SKAction.scale(to: 3.0, duration: 0.15)
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        let explode = SKAction.group([grow, fadeOut])

        // После взрыва — сбросить состояние и полететь снова
        let reset = SKAction.run {
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

        // Появляется, ждёт, исчезает, удаляется — sequence
        let appear  = SKAction.scale(from: 0.5, to: 1.0, duration: 0.2)
        let wait    = SKAction.wait(forDuration: 0.8)
        let fadeOut = SKAction.fadeOut(withDuration: 0.4)
        let remove  = SKAction.removeFromParent()
        msg.run(SKAction.sequence([appear, wait, fadeOut, remove]))
    }
}
