import UIKit
import SpriteKit

// Экран приложения: создаёт игровую сцену и показывает её.
class GameViewController: UIViewController {

    /// Вызывается, когда экран загрузился: создаём и показываем GameScene.
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.view as? SKView {        // холст SpriteKit
            let scene = GameScene(size: view.bounds.size)   // сцена во весь экран
            scene.scaleMode = .resizeFill
            view.presentScene(scene)                // показать сцену
            view.ignoresSiblingOrder = true

            // Раскомментируй для отладки:
            // view.showsFPS = true
            // view.showsNodeCount = true
        }
    }

    /// Разрешаем только вертикальную ориентацию (портрет).
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    /// Прячем системную строку состояния (время/батарея) — игре нужен весь экран.
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
