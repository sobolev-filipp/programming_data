import SpriteKit

// MARK: - Общие помощники проекта
// Объявлены здесь ОДИН раз — видны во всём проекте (и в GameScene тоже).

extension SKColor {
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> SKColor {
        return SKColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
}

let bestScoreKey = "bestScore"   // ключ, под которым храним рекорд в UserDefaults

// MARK: - Экран меню

class MenuScene: SKScene {

    override func didMove(to view: SKView) {
        backgroundColor = .rgb(12, 14, 35)
        setupStars()
        setupTitle()
        setupBest()
        setupPlayButton()
    }

    // Декоративные звёзды на фоне
    func setupStars() {
        for _ in 0..<70 {
            let star = SKShapeNode(circleOfRadius: CGFloat.random(in: 0.5...1.8))
            star.fillColor = .white
            star.strokeColor = .clear
            star.alpha = CGFloat.random(in: 0.2...0.8)
            star.position = CGPoint(x: CGFloat.random(in: 0...size.width),
                                    y: CGFloat.random(in: 0...size.height))
            addChild(star)
        }
    }

    // Заголовок игры (с лёгкой пульсацией)
    func setupTitle() {
        let title = SKLabelNode(fontNamed: "AvenirNext-Bold")
        title.text = "ЛОВЕЦ ЗВЁЗД"
        title.fontSize = 42
        title.fontColor = .rgb(255, 220, 90)
        title.position = CGPoint(x: size.width / 2, y: size.height * 0.66)
        addChild(title)

        title.run(.repeatForever(.sequence([
            .scale(to: 1.06, duration: 0.8),
            .scale(to: 1.0, duration: 0.8)
        ])))
    }

    // Рекорд из UserDefaults
    func setupBest() {
        let best = UserDefaults.standard.integer(forKey: bestScoreKey)
        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.text = "🏆 Рекорд: \(best)"
        label.fontSize = 24
        label.fontColor = .white
        label.position = CGPoint(x: size.width / 2, y: size.height * 0.55)
        addChild(label)
    }

    // Кнопка «Играть»
    func setupPlayButton() {
        let button = SKShapeNode(rectOf: CGSize(width: 200, height: 64), cornerRadius: 18)
        button.fillColor = .rgb(80, 180, 90)
        button.strokeColor = .white
        button.lineWidth = 2
        button.position = CGPoint(x: size.width / 2, y: size.height * 0.38)
        button.name = "playButton"
        addChild(button)

        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.text = "▶ ИГРАТЬ"
        label.fontSize = 26
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        button.addChild(label)   // текст внутри кнопки → имени нет, ищем имя родителя
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        for node in nodes(at: location) {
            if (node.name ?? node.parent?.name) == "playButton" {
                startGame()
            }
        }
    }

    // Переход на игровую сцену
    func startGame() {
        let game = GameScene(size: size)
        game.scaleMode = .resizeFill
        view?.presentScene(game, transition: .doorway(withDuration: 0.6))
    }
}
