import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    @IBOutlet weak var skView: SKView!
    private var gameScene: GameScene?
    private let storage = UserDefaults.standard
    public var levelModel: Levels?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGameScene()
        backToMenuComplitionHandler()
        backToLevelMenuComplitionHandler()
        openHelpComplitionHandler()
        openScoreComplitionHandler()
    }
    
    private func setGameScene() {
        if let skView = self.skView {
            let scene = GameScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            scene.scaleMode = .aspectFill
            scene.levelModel = levelModel ?? LevelsModel().levels[0]
            print("GVC scene \nwidth \(scene.size.width)\nheight \(scene.size.height)")
            print("SKVeiw scene \nwidth \(skView.frame.size.width)\nheight \(skView.frame.size.height)")

            skView.presentScene(scene)
            skView.ignoresSiblingOrder = false
            skView.showsFPS = false
            skView.showsNodeCount = false
            self.gameScene = scene
        }
    }
    
    private func setAlbumDeviceOrientation() {
        UIView.setAnimationsEnabled(false)
        AppUtility.lockOrientation(.landscapeLeft, andRotateTo: .landscapeLeft)
        UIView.setAnimationsEnabled(true)
    }
    
    private func backToMenuComplitionHandler() {
        guard let gameScene = gameScene else { return }
        gameScene.goToMainMenu = {[weak self] in
            guard let self = self else { return }
            let arrayControllers = self.navigationController!.viewControllers
            for controller in arrayControllers {
                if controller is MainMenuViewController {
                    navigationController?.popToViewController(controller, animated: false)
                }
            }
        }
    }
    
    private func backToLevelMenuComplitionHandler() {
        guard let gameScene = gameScene else { return }
        gameScene.goToLevelMenu = {[weak self] in
            guard let self = self else { return }
            let arrayControllers = self.navigationController!.viewControllers
            for controller in arrayControllers {
                if controller is LevelsViewController {
                    navigationController?.popToViewController(controller, animated: false)
                }
            }
        }
    }
    
    private func openHelpComplitionHandler() {
        guard let gameScene = gameScene else { return }
        gameScene.goToHelp = {[weak self] in
            guard let self = self else { return }
            let helpVC = HelpViewController()
            navigationController?.pushViewController(helpVC, animated: false)
        }
    }
    
    private func openScoreComplitionHandler() {
        guard let gameScene = gameScene else { return }
        gameScene.goToScore = {[weak self] in
            guard let self = self else { return }
            let scoreVC = ScoreViewController()
            navigationController?.pushViewController(scoreVC, animated: false)
        }
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
