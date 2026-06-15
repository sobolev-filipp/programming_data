import SpriteKit

// MARK: - Расширение для удобных RGB цветов
extension SKColor {
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> SKColor {
        return SKColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
}

class GameScene: SKScene {

    // MARK: - Свойства — обычный астероид

    var asteroid: SKSpriteNode!
    var asteroidSpeed = 4.0

    // MARK: - Свойства — босс

    var boss: SKSpriteNode!
    var bossHP = 50                  // сколько нажатий нужно чтобы убить
    var bossMaxHP = 50
    var bossHPLabel: SKLabelNode!    // полоска здоровья цифрами
    var bossHPBar: SKShapeNode!      // визуальная полоска здоровья
    var bossHPFill: SKShapeNode!     // заливка полоски
    var bossActive = false           // босс сейчас летит?
    var bossIsStopped = false        // босс остановлен ударом?

    // MARK: - Свойства — счёт

    var destroyCount = 0
    var scoreLabel: SKLabelNode!

    // MARK: - Загрузка сцены

    override func didMove(to view: SKView) {
        setupBackground()
        setupScoreLabel()
        setupAsteroid()
        setupBoss()
        startFlying()

        // Босс появляется через 5 секунд после старта
        run(SKAction.sequence([
            SKAction.wait(forDuration: 5.0),
            SKAction.run { self.spawnBoss() }
        ]))
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

    // MARK: - Счёт уничтоженных астероидов

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

    // MARK: - Обычный астероид

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

        let crater3 = SKShapeNode(circleOfRadius: 4)
        crater3.fillColor = .rgb(100, 85, 70)
        crater3.strokeColor = .clear
        crater3.position = CGPoint(x: -5, y: -15)
        asteroid.addChild(crater3)

        asteroid.position = CGPoint(x: size.width + 50, y: size.height / 2)
        addChild(asteroid)
    }

    // MARK: - Полёт и вращение обычного астероида

    func startFlying() {
        flyAcrossScreen()
        asteroid.run(SKAction.repeatForever(
            SKAction.rotate(byAngle: .pi * 2, duration: 3.0)
        ), withKey: "spin")
    }

    func flyAcrossScreen() {
        let randomY = CGFloat.random(in: 80...(size.height - 80))
        asteroid.position = CGPoint(x: size.width + 50, y: randomY)
        let fly   = SKAction.moveTo(x: -50, duration: asteroidSpeed)
        let reset = SKAction.run { self.flyAcrossScreen() }
        asteroid.run(SKAction.sequence([fly, reset]), withKey: "fly")
    }

    // MARK: - Взрыв обычного астероида

    func explodeAsteroid() {
        destroyCount += 1
        scoreLabel.text = "Уничтожено: \(destroyCount)"

        if destroyCount % 5 == 0 {
            asteroidSpeed = max(1.5, asteroidSpeed - 0.5)
            showMessage("БЫСТРЕЕ! 🔥", color: .rgb(255, 150, 0))
        }

        asteroid.removeAction(forKey: "fly")

        let explode = SKAction.group([
            SKAction.scale(to: 3.0, duration: 0.15),
            SKAction.fadeOut(withDuration: 0.3)
        ])
        let reset = SKAction.run {
            self.asteroid.setScale(1.0)
            self.asteroid.alpha = 1.0
            self.flyAcrossScreen()
        }
        asteroid.run(SKAction.sequence([explode, reset]))
    }

    // MARK: - Босс: создание

    func setupBoss() {
        // Размер в 3 раза больше обычного астероида
        boss = SKSpriteNode(color: .clear, size: CGSize(width: 160, height: 160))
        boss.name = "boss"
        boss.alpha = 0   // пока невидимый — появится через spawnBoss()

        // Тело — большой тёмно-красный круг
        let body = SKShapeNode(circleOfRadius: 75)
        body.fillColor = .rgb(160, 30, 30)
        body.strokeColor = .rgb(255, 80, 80)
        body.lineWidth = 3
        boss.addChild(body)

        // Внутреннее кольцо — как кратер
        let innerRing = SKShapeNode(circleOfRadius: 50)
        innerRing.fillColor = .rgb(120, 20, 20)
        innerRing.strokeColor = .rgb(200, 60, 60)
        innerRing.lineWidth = 2
        boss.addChild(innerRing)

        // Кратеры — большие
        let positions: [(CGFloat, CGFloat, CGFloat)] = [
            (-30, 20, 14),
            (28, -18, 10),
            (-10, -35, 8),
            (40, 30, 6)
        ]
        for (x, y, r) in positions {
            let crater = SKShapeNode(circleOfRadius: r)
            crater.fillColor = .rgb(100, 15, 15)
            crater.strokeColor = .clear
            crater.position = CGPoint(x: x, y: y)
            boss.addChild(crater)
        }

        // Злые глаза — делают его страшным 😈
        let leftEye = SKShapeNode(circleOfRadius: 12)
        leftEye.fillColor = .rgb(255, 50, 50)
        leftEye.strokeColor = .clear
        leftEye.position = CGPoint(x: -22, y: 18)
        boss.addChild(leftEye)

        let rightEye = SKShapeNode(circleOfRadius: 12)
        rightEye.fillColor = .rgb(255, 50, 50)
        rightEye.strokeColor = .clear
        rightEye.position = CGPoint(x: 22, y: 18)
        boss.addChild(rightEye)

        // Чёрные зрачки
        let leftPupil = SKShapeNode(circleOfRadius: 5)
        leftPupil.fillColor = .black
        leftPupil.position = CGPoint(x: -22, y: 18)
        boss.addChild(leftPupil)

        let rightPupil = SKShapeNode(circleOfRadius: 5)
        rightPupil.fillColor = .black
        rightPupil.position = CGPoint(x: 22, y: 18)
        boss.addChild(rightPupil)

        // Надпись BOSS
        let bossLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        bossLabel.text = "BOSS"
        bossLabel.fontSize = 18
        bossLabel.fontColor = .rgb(255, 200, 0)
        bossLabel.verticalAlignmentMode = .center
        bossLabel.position = CGPoint(x: 0, y: -10)
        boss.addChild(bossLabel)

        boss.position = CGPoint(x: size.width + 100, y: size.height / 2)
        boss.zPosition = 5
        addChild(boss)

        // Полоска здоровья
        setupBossHealthBar()
    }

    // MARK: - Полоска здоровья босса

    func setupBossHealthBar() {
        let barWidth: CGFloat = 200
        let barHeight: CGFloat = 14
        let barX = size.width / 2
        let barY: CGFloat = size.height - 90

        // Фон полоски
        let bg = SKShapeNode(rectOf: CGSize(width: barWidth + 4, height: barHeight + 4),
                             cornerRadius: 7)
        bg.fillColor = .rgb(40, 10, 10)
        bg.strokeColor = .rgb(255, 80, 80)
        bg.lineWidth = 1.5
        bg.position = CGPoint(x: barX, y: barY)
        bg.zPosition = 10
        bg.alpha = 0
        bg.name = "bossHPBg"
        addChild(bg)

        // Заливка (здоровье)
        bossHPFill = SKShapeNode(rectOf: CGSize(width: barWidth, height: barHeight),
                                  cornerRadius: 5)
        bossHPFill.fillColor = .rgb(220, 50, 50)
        bossHPFill.strokeColor = .clear
        bossHPFill.position = CGPoint(x: barX, y: barY)
        bossHPFill.zPosition = 11
        bossHPFill.alpha = 0
        addChild(bossHPFill)

        // Текст HP
        bossHPLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        bossHPLabel.text = "BOSS HP: 50/50"
        bossHPLabel.fontSize = 14
        bossHPLabel.fontColor = .rgb(255, 200, 200)
        bossHPLabel.position = CGPoint(x: barX, y: barY - 22)
        bossHPLabel.horizontalAlignmentMode = .center
        bossHPLabel.zPosition = 11
        bossHPLabel.alpha = 0
        addChild(bossHPLabel)
    }

    // MARK: - Появление босса

    func spawnBoss() {
        guard !bossActive else { return }
        bossActive = true
        bossIsStopped = false
        bossHP = bossMaxHP

        // Останавливаем обычный астероид пока летит босс
        asteroid.removeAction(forKey: "fly")
        asteroid.run(SKAction.fadeOut(withDuration: 0.5))

        // Показываем предупреждение
        showMessage("⚠️ BOSS ИДЁТ!", color: .rgb(255, 50, 50))

        // Показываем полоску здоровья
        updateBossHealthBar()
        childNode(withName: "bossHPBg")?.run(SKAction.fadeIn(withDuration: 0.5))
        bossHPFill.run(SKAction.fadeIn(withDuration: 0.5))
        bossHPLabel.run(SKAction.fadeIn(withDuration: 0.5))

        // Босс влетает справа
        boss.alpha = 1
        boss.position = CGPoint(x: size.width + 100, y: size.height / 2)
        boss.setScale(0.3)

        // Врывается на экран с эффектом появления
        let flyIn = SKAction.group([
            SKAction.moveTo(x: size.width * 0.75, duration: 1.2),
            SKAction.scale(to: 1.0, duration: 1.2)
        ])

        boss.run(flyIn) {
            self.startBossMovement()
        }

        // Вращение босса — медленное и угрожающее
        boss.run(SKAction.repeatForever(
            SKAction.rotate(byAngle: .pi * 2, duration: 6.0)
        ), withKey: "spin")
    }

    // MARK: - Движение босса (летит туда-сюда)

    func startBossMovement() {
        guard bossActive else { return }
        bossIsStopped = false

        // Босс летает по правой половине экрана вверх-вниз
        let moveDown = SKAction.moveTo(y: 120, duration: 2.0)
        let moveUp   = SKAction.moveTo(y: size.height - 120, duration: 2.0)
        moveDown.timingMode = .easeInEaseOut
        moveUp.timingMode   = .easeInEaseOut

        let patrol = SKAction.repeatForever(SKAction.sequence([moveDown, moveUp]))
        boss.run(patrol, withKey: "patrol")
    }

    // MARK: - Нажатие на босса

    func hitBoss() {
        guard bossActive else { return }

        // Уменьшаем HP
        bossHP -= 1
        updateBossHealthBar()

        // Останавливаем босса при каждом ударе
        boss.removeAction(forKey: "patrol")
        bossIsStopped = true

        // Вспышка — босс белеет на миг
        let flashWhite  = SKAction.colorize(with: .white, colorBlendFactor: 0.8, duration: 0.05)
        let flashNormal = SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.1)
        let shake       = buildShakeAction()

        // Небольшое потряхивание при ударе
        boss.run(SKAction.group([
            SKAction.sequence([flashWhite, flashNormal]),
            shake
        ]))

        // Через 0.6 секунды босс возобновляет движение
        boss.removeAction(forKey: "resumeTimer")
        boss.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.6),
            SKAction.run { self.startBossMovement() }
        ]), withKey: "resumeTimer")

        // Босс побеждён
        if bossHP <= 0 {
            defeatBoss()
        }
    }

    // Небольшое потряхивание при ударе
    func buildShakeAction() -> SKAction {
        let d = 0.04
        let s: CGFloat = 6
        return SKAction.sequence([
            SKAction.moveBy(x:  s, y: 0, duration: d),
            SKAction.moveBy(x: -s, y: 0, duration: d),
            SKAction.moveBy(x:  s, y: 0, duration: d),
            SKAction.moveBy(x: -s, y: 0, duration: d)
        ])
    }

    // MARK: - Обновление полоски здоровья

    func updateBossHealthBar() {
        let barWidth: CGFloat = 200
        let ratio = CGFloat(bossHP) / CGFloat(bossMaxHP)

        // Ширина заливки зависит от оставшегося HP
        let fillWidth = max(0, barWidth * ratio)
        let barX = size.width / 2 - barWidth / 2 + fillWidth / 2

        // Меняем ширину и позицию заливки
        let newFill = SKShapeNode(rectOf: CGSize(width: fillWidth, height: 14), cornerRadius: 5)
        newFill.fillColor = bossHPColor()   // зелёный → жёлтый → красный
        newFill.strokeColor = .clear
        newFill.position = CGPoint(x: barX, y: bossHPFill.position.y)
        newFill.zPosition = 11
        newFill.alpha = bossHPFill.alpha

        bossHPFill.removeFromParent()
        bossHPFill = newFill
        addChild(bossHPFill)

        bossHPLabel.text = "BOSS HP: \(bossHP)/\(bossMaxHP)"

        // Цвет текста тоже меняется
        bossHPLabel.fontColor = bossHPColor()
    }

    // Цвет полоски: зелёный (много HP) → жёлтый → красный (мало HP)
    func bossHPColor() -> SKColor {
        let ratio = Double(bossHP) / Double(bossMaxHP)
        if ratio > 0.5 {
            return .rgb(80, 220, 80)
        } else if ratio > 0.25 {
            return .rgb(255, 200, 0)
        } else {
            return .rgb(255, 60, 60)
        }
    }

    // MARK: - Победа над боссом

    func defeatBoss() {
        bossActive = false
        boss.removeAllActions()

        // Большой взрыв
        let bigExplode = SKAction.group([
            SKAction.scale(to: 4.0, duration: 0.3),
            SKAction.fadeOut(withDuration: 0.3)
        ])

        boss.run(bigExplode) {
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

        // Сообщение о победе
        showMessage("💥 BOSS УНИЧТОЖЕН!", color: .rgb(255, 220, 0))

        destroyCount += 1
        scoreLabel.text = "Уничтожено: \(destroyCount)"

        // Конфетти — много ярких звёздочек
        for _ in 0..<20 {
            let confetti = SKShapeNode(circleOfRadius: CGFloat.random(in: 3...8))
            confetti.fillColor = [
                SKColor.rgb(255,80,80),
                SKColor.rgb(80,255,80),
                SKColor.rgb(80,150,255),
                SKColor.rgb(255,220,0)
            ].randomElement()!
            confetti.strokeColor = .clear
            confetti.position = CGPoint(
                x: CGFloat.random(in: 60...(size.width - 60)),
                y: CGFloat.random(in: size.height * 0.3...size.height * 0.8)
            )
            confetti.zPosition = 15
            addChild(confetti)

            let fall = SKAction.moveBy(
                x: CGFloat.random(in: -60...60),
                y: -size.height * 0.5,
                duration: Double.random(in: 1.0...2.5)
            )
            confetti.run(SKAction.sequence([
                fall,
                SKAction.removeFromParent()
            ]))
        }

        // Возвращаем обычный астероид через 3 секунды
        run(SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.run {
                self.asteroid.run(SKAction.fadeIn(withDuration: 0.5))
                self.flyAcrossScreen()

                // Босс снова появится через 15 секунд
                self.run(SKAction.sequence([
                    SKAction.wait(forDuration: 15.0),
                    SKAction.run { self.spawnBoss() }
                ]))
            }
        ]))
    }

    // MARK: - Касание

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        for node in nodes(at: location) {
            // Попали в босса или его часть?
            if node.name == "boss" || node.parent?.name == "boss" {
                hitBoss()
                return
            }
            // Попали в обычный астероид?
            if node.name == "asteroid" || node.parent?.name == "asteroid" {
                explodeAsteroid()
                return
            }
        }
    }

    // MARK: - Вспомогательное: показать сообщение

    func showMessage(_ text: String, color: SKColor) {
        let msg = SKLabelNode(fontNamed: "Helvetica-Bold")
        msg.text = text
        msg.fontSize = 30
        msg.fontColor = color
        msg.position = CGPoint(x: size.width / 2, y: size.height / 2)
        msg.zPosition = 20
        msg.setScale(0.5)
        addChild(msg)

        let appear  = SKAction.scale(to: 1.0, duration: 0.2)
        let wait    = SKAction.wait(forDuration: 1.0)
        let fadeOut = SKAction.fadeOut(withDuration: 0.4)
        let remove  = SKAction.removeFromParent()
        msg.run(SKAction.sequence([appear, wait, fadeOut, remove]))
    }
}