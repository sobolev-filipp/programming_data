import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.view as? SKView {
            // Создаём сцену по размеру экрана — работает на любом iPhone
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .resizeFill

            view.presentScene(scene)
            view.ignoresSiblingOrder = true

            // Можно включить для отладки:
            // view.showsFPS = true
            // view.showsNodeCount = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
