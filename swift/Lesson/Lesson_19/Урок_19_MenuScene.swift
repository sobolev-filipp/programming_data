import SpriteKit

// MARK: - Общие помощники проекта
// Объявлены здесь ОДИН раз — видны во всём проекте (и в GameScene тоже).

extension SKColor {
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> SKColor {
        return SKColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
}

let bestScoreKey = "bestTower"   // ключ, под которым храним рекорд (высоту) в UserDefaults

// MARK: - Экран меню

class MenuScene: SKScene {

    override func didMove(to view: SKView) {
        backgroundColor = .rgb(18, 20, 46)   // запасной цвет, если фото не добавили
        setupBackground()
        setupDecorTower()
        setupTitle()
        setupBest()
        setupPlayButton()
    }

    // Фоновое ФОТО (картинка "background" из Assets.xcassets), растянутое на весь экран
    func setupBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)  // по центру экрана
        background.size = self.size          // растянуть ровно под размер экрана
        background.zPosition = -100          // далеко позади всего остального
        addChild(background)
    }

    // Декоративная мини-башня внизу
    func setupDecorTower() {
        for i in 0..<4 {
            let hue = (0.55 + CGFloat(i) * 0.05).truncatingRemainder(dividingBy: 1.0)
            let color = SKColor(hue: hue, saturation: 0.65, brightness: 0.98, alpha: 1.0)
            let block = SKSpriteNode(color: color, size: CGSize(width: 130 - CGFloat(i) * 12, height: 32))
            block.position = CGPoint(x: size.width / 2, y: size.height * 0.15 + CGFloat(i) * 32)
            addChild(block)
        }
    }

    // Заголовок (с лёгкой пульсацией)
    func setupTitle() {
        let title = SKLabelNode(fontNamed: "AvenirNext-Bold")
        title.text = "🏗 БАШНЯ"
        title.fontSize = 46
        title.fontColor = .rgb(255, 220, 90)
        title.position = CGPoint(x: size.width / 2, y: size.height * 0.72)
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
        label.text = "🏆 Рекорд: \(best) этажей"
        label.fontSize = 24
        label.fontColor = .white
        label.position = CGPoint(x: size.width / 2, y: size.height * 0.6)
        addChild(label)
    }

    // Кнопка «Играть»
    func setupPlayButton() {
        let button = SKShapeNode(rectOf: CGSize(width: 200, height: 64), cornerRadius: 18)
        button.fillColor = .rgb(80, 180, 90)
        button.strokeColor = .white
        button.lineWidth = 2
        button.position = CGPoint(x: size.width / 2, y: size.height * 0.46)
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
