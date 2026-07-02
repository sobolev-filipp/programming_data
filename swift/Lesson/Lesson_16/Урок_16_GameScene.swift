import SpriteKit

// MARK: - RGB расширение

extension SKColor {
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> SKColor {
        return SKColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
}

// MARK: - Категории физики

struct PhysicsCategory {
    static let laser:    UInt32 = 0b0001
    static let asteroid: UInt32 = 0b0010
    static let ship:     UInt32 = 0b0100
}

// MARK: - Сцена

class GameScene: SKScene, SKPhysicsContactDelegate {

    var ship: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var livesLabel: SKLabelNode!
    var score = 0
    var lives = 3
    var asteroidSpeed = 3.5
    var isGameOver = false

    // MARK: - Загрузка

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

        // Корпус — треугольник
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

        // Кабина
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

        // Пламя двигателя
        let flame = SKShapeNode(ellipseOf: CGSize(width: 16, height: 24))
        flame.fillColor = .rgb(255, 140, 0)
        flame.strokeColor = .clear
        flame.position = CGPoint(x: 0, y: -38)
        ship.addChild(flame)
        flame.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.fadeAlpha(to: 0.5, duration: 0.1),
            SKAction.fadeAlpha(to: 1.0, duration: 0.1)
        ])))

        // Физика
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

        livesLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        livesLabel.fontSize = 22
        livesLabel.fontColor = .red
        livesLabel.position = CGPoint(x: 20, y: size.height - 55)
        livesLabel.horizontalAlignmentMode = .left
        livesLabel.zPosition = 10
        updateLivesLabel()
        addChild(livesLabel)
    }

    func updateLivesLabel() {
        livesLabel.text = String(repeating: "❤️", count: lives)
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
        // Game Over — только кнопка рестарта
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

        // Игра — движение + стрельба
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
        // Движение только по X, корабль не выходит за края
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

        // Луч
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

        // Физика
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
        lives -= 1
        updateLivesLabel()

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

    // MARK: - Вспомогательные

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
