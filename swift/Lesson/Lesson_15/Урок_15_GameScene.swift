import SpriteKit

// MARK: - Расширение RGB

extension SKColor {
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> SKColor {
        return SKColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
}

// MARK: - Категории физики

struct PhysicsCategory {
    static let ball:   UInt32 = 0b0001   // 1
    static let basket: UInt32 = 0b0010   // 2
    static let wall:   UInt32 = 0b0100   // 4
}

// MARK: - Сцена

class GameScene: SKScene, SKPhysicsContactDelegate {

    var ball: SKShapeNode!
    var scoreLabel: SKLabelNode!
    var score = 0
    var ballSpeed = 4.0

    // MARK: - Загрузка

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

    // MARK: - Физика мира

    func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0, dy: -6.0)
        physicsWorld.contactDelegate = self

        // Края экрана — стены (мяч не вылетит за экран)
        physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        physicsBody?.categoryBitMask = PhysicsCategory.wall
        physicsBody?.friction = 0.1
    }

    // MARK: - Стены (пустая функция — стены уже есть через edgeLoopFrom)

    func setupWalls() {
        // Дополнительные платформы можно добавить здесь
    }

    // MARK: - Корзина

    func setupBasket() {
        let basketY: CGFloat = 140
        let basketWidth: CGFloat = 90
        let wallHeight: CGFloat = 50
        let wallThickness: CGFloat = 10
        let centerX = size.width / 2

        // Левая стенка
        let leftWall = SKSpriteNode(
            color: .rgb(255, 140, 0),
            size: CGSize(width: wallThickness, height: wallHeight)
        )
        leftWall.position = CGPoint(x: centerX - basketWidth / 2 - wallThickness / 2, y: basketY)
        leftWall.physicsBody = SKPhysicsBody(rectangleOf: leftWall.size)
        leftWall.physicsBody?.isDynamic = false
        leftWall.physicsBody?.categoryBitMask = PhysicsCategory.wall
        leftWall.physicsBody?.friction = 0.1
        leftWall.physicsBody?.restitution = 0.3
        addChild(leftWall)

        // Правая стенка
        let rightWall = SKSpriteNode(
            color: .rgb(255, 140, 0),
            size: CGSize(width: wallThickness, height: wallHeight)
        )
        rightWall.position = CGPoint(x: centerX + basketWidth / 2 + wallThickness / 2, y: basketY)
        rightWall.physicsBody = SKPhysicsBody(rectangleOf: rightWall.size)
        rightWall.physicsBody?.isDynamic = false
        rightWall.physicsBody?.categoryBitMask = PhysicsCategory.wall
        rightWall.physicsBody?.friction = 0.1
        rightWall.physicsBody?.restitution = 0.3
        addChild(rightWall)

        // Невидимый сенсор — засчитывает попадание
        let sensor = SKSpriteNode(color: .clear, size: CGSize(width: basketWidth, height: 5))
        sensor.position = CGPoint(x: centerX, y: basketY - wallHeight / 2)
        sensor.name = "basket"
        sensor.physicsBody = SKPhysicsBody(rectangleOf: sensor.size)
        sensor.physicsBody?.isDynamic = false
        sensor.physicsBody?.categoryBitMask    = PhysicsCategory.basket
        sensor.physicsBody?.contactTestBitMask = PhysicsCategory.ball
        sensor.physicsBody?.collisionBitMask   = 0   // сенсор — мяч проходит сквозь него
        addChild(sensor)

        // Визуальная сетка
        let net = SKShapeNode()
        let path = CGMutablePath()
        path.move(to: CGPoint(x: centerX - basketWidth / 2, y: basketY - wallHeight / 2))
        path.addLine(to: CGPoint(x: centerX, y: basketY - wallHeight / 2 - 30))
        path.addLine(to: CGPoint(x: centerX + basketWidth / 2, y: basketY - wallHeight / 2))
        net.path = path
        net.strokeColor = .rgb(255, 200, 100)
        net.lineWidth = 2
        net.alpha = 0.6
        addChild(net)
    }

    // MARK: - Мяч

    func spawnBall() {
        let randomX = CGFloat.random(in: 60...(size.width - 60))

        let colors: [SKColor] = [
            .rgb(255, 80, 80),
            .rgb(80, 200, 255),
            .rgb(100, 255, 100),
            .rgb(255, 220, 0),
            .rgb(200, 100, 255)
        ]

        ball = SKShapeNode(circleOfRadius: 20)
        ball.fillColor = colors.randomElement()!
        ball.strokeColor = ball.fillColor.withAlphaComponent(0.5)
        ball.lineWidth = 3
        ball.position = CGPoint(x: randomX, y: size.height - 60)
        ball.name = "ball"
        ball.zPosition = 5

        // Блик
        let glare = SKShapeNode(circleOfRadius: 6)
        glare.fillColor = .white
        glare.strokeColor = .clear
        glare.alpha = 0.4
        glare.position = CGPoint(x: -7, y: 7)
        ball.addChild(glare)

        // Физика
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        ball.physicsBody?.restitution = 0.5
        ball.physicsBody?.friction = 0.2
        ball.physicsBody?.linearDamping = 0.1
        ball.physicsBody?.allowsRotation = true
        ball.physicsBody?.categoryBitMask    = PhysicsCategory.ball
        ball.physicsBody?.collisionBitMask   = PhysicsCategory.wall
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.basket

        addChild(ball)

        // Анимация появления
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
        // Сортируем: меньший categoryBitMask всегда в bodyA
        let (bodyA, bodyB) = contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask
            ? (contact.bodyA, contact.bodyB)
            : (contact.bodyB, contact.bodyA)

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

        if score % 3 == 0 {
            ballSpeed = max(1.5, ballSpeed - 0.3)
            showMessage("БЫСТРЕЕ! ⚡", color: .rgb(255, 200, 0))
        } else {
            showMessage("ГОЛ! 🏀", color: .rgb(255, 140, 0))
        }

        // Анимация исчезновения
        ball.run(SKAction.sequence([
            SKAction.scale(to: 0, duration: 0.2),
            SKAction.removeFromParent()
        ]), withKey: "falling")

        // Новый мяч через 0.3 сек
        run(SKAction.sequence([
            SKAction.wait(forDuration: 0.3),
            SKAction.run { self.spawnBall() }
        ]))
    }

    // MARK: - Касание: толкнуть мяч

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        guard ball != nil, ball.parent != nil else { return }

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
