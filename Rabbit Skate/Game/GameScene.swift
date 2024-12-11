import UIKit
import SpriteKit
import GameplayKit

struct CategoryBitMasks {
    static let skate: UInt32 = 0x1 << 0
    static let mouse: UInt32 = 0x1 << 1
    static let object: UInt32 = 0x1 << 2
    static let border: UInt32 = 0x1 << 3
    static let truck: UInt32 = 0x1 << 4
    static let hole: UInt32 = 0x1 << 5
}

class GameScene: SKScene, SKPhysicsContactDelegate, StackViewDelegate, ReusableViewDelegate {
    private var rabbit: SKSpriteNode!
    private var skate: SKSpriteNode!
    private var mouse: SKSpriteNode!
    private var truck: SKSpriteNode!
    private var hole: SKSpriteNode!
    private var openHole: SKSpriteNode!
    private var pauseButton: SKSpriteNode!
    private var border: SKShapeNode!
    private var pauseMenuView = PauseMenuStackView()
    private var score = 0
    private var missionObjects = 0
    private var scoreLabel: SKLabelNode!
    private var goalLabel: SKLabelNode!
    private var lifesView = GameLivesView()
    private var cheeseOnScreen = 0
    private var introView = OverscreenReusableView()
    private var gameOverView = GameOverView()
    private var missedItemsLabel: SKLabelNode!
    private var gameOver: SKSpriteNode!
    private var objectsArray = [SKSpriteNode]()
    public var levelModel = Levels(titleImageName: "default", gameImageName: "default", backgroundGameImageName: "backLevel1", scoreLevel: "default", items: LevelsItems.level1, holeOpened: false, mission: "")
    private let storage = UserDefaults.standard
    private var mouseHit = 0
    private var contacted = false
    private var missionInItems = false
    private var firstTouch: UITouch? = nil
    var goToMainMenu: (()->Void)?
    var goToLevelMenu: (()->Void)?
    var goToHelp: (()->Void)?
    var goToScore: (()->Void)?
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        let background = SKSpriteNode(imageNamed: levelModel.backgroundGameImageName)
        background.size = self.frame.size
        background.alpha = 0.8
        addChild(background)
        pauseMenuView.frame = CGRect(x: frame.width / 4, y: frame.height * 0.12, width: frame.width / 2, height: frame.height * 0.76)
        pauseMenuView.backgroundColor = .lightGray
        pauseMenuView.layer.cornerRadius = 20
        pauseMenuView.layer.borderWidth = 6
        pauseMenuView.layer.borderColor = UIColor.black.cgColor
        pauseMenuView.delegate = self
        print("Game menu:")
        print(pauseMenuView.frame.size)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        createLifesView()
        createAndShowHelp()
        createSkate()
        createRabbit()
        createMouse()
        createTruck()
        createScoreLabel()
        createGoalLabel()
        createPauseButton()
        if levelModel.holeOpened {
            createHole(named: "holeOpened", size: CGSize(width: 100, height: 100))
            createOpenHoleCloser()
        } else { createHole(named: "holeClosed", size: CGSize(width: 60, height: 60)) }
        for _ in 0...2 {
            objectRunActionWithAppearanceInterval(names: levelModel.items)
        }
        if levelModel.scoreLevel == "level2" || levelModel.scoreLevel == "level4" {
            missionInItems = true
        }
    }
    
    //MARK: Restart Level
    @objc private func restart() {
        self.removeAllActions()
        self.removeAllChildren()
        score = 0
        missionObjects = 0
        lifesView.addFirstLife()
        lifesView.addSecondLife()
        lifesView.addThirdLife()
        
        let background = SKSpriteNode(imageNamed: levelModel.backgroundGameImageName)
        background.size = self.frame.size
        background.alpha = 0.8
        addChild(background)
        pauseMenuView.frame = CGRect(x: frame.width / 4, y: frame.height * 0.12, width: frame.width / 2, height: frame.height * 0.76)
        pauseMenuView.backgroundColor = .lightGray
        pauseMenuView.layer.cornerRadius = 20
        pauseMenuView.layer.borderWidth = 6
        pauseMenuView.layer.borderColor = UIColor.black.cgColor
        pauseMenuView.delegate = self
        print("Game menu:")
        print(pauseMenuView.frame.size)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        createSkate()
        createRabbit()
        createMouse()
        mouse.position = CGPoint(x: (-frame.width/1.5) , y: (frame.height/4))
        createScoreLabel()
        createGoalLabel()
        createPauseButton()
        if levelModel.holeOpened {
            createHole(named: "holeOpened", size: CGSize(width: 100, height: 100))
            createOpenHoleCloser()
        } else { createHole(named: "holeClosed", size: CGSize(width: 60, height: 60)) }
        for _ in 0...2 {
            objectRunActionWithAppearanceInterval(names: levelModel.items)
        }
        
        gameOverView.removeFromSuperview()
        isPaused = false
    }
    
    //MARK: Touches Moved
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            if pauseButton.contains(touchLocation) {
                return
            } else if isPaused {
                return
            }
            var moveToLocation = touchLocation
            if touchLocation.y > (frame.height*0.24) {
                moveToLocation = CGPoint(x: touchLocation.x, y: frame.height*0.22)
            }
            let distance = distanceCalculate(a: skate.position, b: moveToLocation)
            let speed: CGFloat = 400
            let time = timeToDistance(distance: distance, speed: speed)
            let moveAction = SKAction.move(to: moveToLocation, duration: time)
            skate.run(moveAction)
            firstTouch = touch
        }
    }
    // MARK: Touches Began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            if pauseButton.contains(touchLocation) {
                return
            } else if isPaused {
                return
            }
            var moveToLocation = touchLocation
            if touchLocation.y > (frame.height*0.24) {
                moveToLocation = CGPoint(x: touchLocation.x, y: (frame.height*0.22))
            }
            let distance = distanceCalculate(a: skate.position, b: moveToLocation)
            let speed: CGFloat = 400
            let time = timeToDistance(distance: distance, speed: speed)
            let moveAction = SKAction.move(to: moveToLocation, duration: time)
            skate.run(moveAction)
            firstTouch = touch
        }
    }
    // MARK: Update
    override func update(_ currentTime: TimeInterval) {
        checkLifes()
        mouseRun()
        guard (firstTouch != nil) else { return }
        let R1 = mtoRad(x: skate.position.x, y: skate.position.y)
        rotateMouse(to: -R1)
    }
    
    private func mtoRad(x: CGFloat, y: CGFloat) -> CGFloat {
        let Radian3 = atan2f(Float(x), Float(y))
        return CGFloat(Radian3)
    }
    // MARK: Touches Ended
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            if pauseButton.contains(touchLocation) {
                isPaused = true
                self.view!.addSubview(pauseMenuView)
            }
        }
    }
    // MARK: Did Tap On View
    func didTapOnPauseView(at index: Int) {
        switch index {
        case 0:
            let storedValue: Int? = storage.value(forKey: levelModel.scoreLevel) as? Int
            let storedScore: Int = (storedValue != nil) ? storedValue! : 0
            if storedScore < score {
                storage.set(score, forKey: levelModel.scoreLevel)
            }
            checkMissionStatus()
            goToMainMenu?()
            print("Menu")
        case 1:
            goToScore?()
            print("Score")
        case 2:
            goToHelp?()
            print("Help")
        case 3:
            print("Continue")
            self.pauseMenuView.removeFromSuperview(); isPaused = false
        default:
            break
        }
    }
    
    //MARK: Did Tap On Reusable View
    func didTapOnReusableView() {
        if gameOverView.item == "GameOver" {
            goToLevelMenu?()
        } else {
            isPaused = false
            introView.removeFromSuperview()
        }
    }
    
    //MARK: Check Lifes
    private func checkLifes() {
        if lifesView.isFirstLife == false {
            createAndShowGameOver()
            checkMissionStatus()
            isPaused = true
            let storedValue: Int? = storage.value(forKey: levelModel.scoreLevel) as? Int
            let storedScore: Int = (storedValue != nil) ? storedValue! : 0
            if storedScore < score {
                storage.set(score, forKey: levelModel.scoreLevel)
            }
        }
    }
    
    // MARK: Skate Creation
    private func createSkate() {
        let texture = SKTexture(imageNamed: "Skate")
        let action = SKAction.setTexture(texture, resize: true)
        skate = SKSpriteNode(texture: texture)
        skate.run(action)
        skate.name = "skate"
        skate.position = CGPoint(x:0, y: -70)
        skate.zPosition = 5
//        skate.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        skate.physicsBody = SKPhysicsBody(texture: texture, size: CGSize(width: skate.size.width, height: skate.size.height))
        skate.physicsBody?.isDynamic = true
        skate.physicsBody?.categoryBitMask = CategoryBitMasks.skate
        skate.physicsBody?.contactTestBitMask = CategoryBitMasks.object | CategoryBitMasks.mouse
        skate.physicsBody?.collisionBitMask &= ~CategoryBitMasks.object
        skate.physicsBody?.collisionBitMask &= ~CategoryBitMasks.hole
        skate.physicsBody?.collisionBitMask &= ~CategoryBitMasks.mouse
        addChild(skate)
    }
    
    // MARK: Rabbit Creation
    private func createRabbit() {
        rabbit = SKSpriteNode(imageNamed: "Rabbit")
        rabbit.aspectFillToSize(fillSize: CGSize(width: 160, height: 160))
        rabbit.name = "rabbit"
        rabbit.position = CGPoint(x: 0, y: skate.position.y + rabbit.size.height/1.48)
        rabbit.zPosition = 5
        rabbit.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        rabbit.physicsBody?.isDynamic = false
        skate.addChild(rabbit)
    }
    
    // MARK: Mouse Creation
    private func createMouse() {
        mouse = SKSpriteNode(imageNamed: "mouse")
        mouse.name = "mouse"
        mouse.position = CGPoint(x: (-frame.width/2) + 30 , y: (-frame.height/2) + 30)
        mouse.aspectFillToSize(fillSize: CGSize(width: 60, height: 60))
        mouse.physicsBody = SKPhysicsBody(texture: mouse.texture!, size: mouse.size)
        mouse.zRotation = -45
        mouse.anchorPoint = CGPoint(x: 0.5, y: 0.7)
        mouse.zPosition = 7
        mouse.physicsBody?.isDynamic = true
        mouse.physicsBody?.categoryBitMask = CategoryBitMasks.mouse
        mouse.physicsBody?.contactTestBitMask = CategoryBitMasks.object | CategoryBitMasks.skate
        mouse.physicsBody?.collisionBitMask &= ~CategoryBitMasks.hole
        mouse.physicsBody?.collisionBitMask &= ~CategoryBitMasks.object
        mouse.physicsBody?.collisionBitMask &= ~CategoryBitMasks.skate
        addChild(mouse)
    }
    
    // MARK: Boarder Creation
    private func createBoarder() {
        let drawingPath = CGMutablePath()
        drawingPath.move(to: CGPoint(x: -frame.width/2, y: frame.height*0.22))
        drawingPath.addLine(to: CGPoint(x: frame.width/2, y: frame.height*0.22))
        border = SKShapeNode(path: drawingPath)
        border.strokeColor = .clear
        border.physicsBody?.isDynamic = false
        border.physicsBody?.categoryBitMask = CategoryBitMasks.border
        border.physicsBody?.collisionBitMask = CategoryBitMasks.skate | CategoryBitMasks.mouse
        addChild(border)
    }
    
    //MARK: Truck Creation
    private func createTruck() {
        truck = SKSpriteNode(imageNamed: "truck")
        truck.name = "truck"
        truck.position = CGPoint(x: -frame.width/1.4, y: frame.height*0.04)
        truck.aspectFillToSize(fillSize: CGSize(width: 120, height: 80))
        truck.physicsBody = SKPhysicsBody(texture: truck.texture!, size: truck.size)
        truck.anchorPoint = CGPoint(x: 1, y: 0.5)
        truck.zPosition = 8
        truck.physicsBody?.isDynamic = true
        truck.physicsBody?.categoryBitMask = CategoryBitMasks.truck
        truck.physicsBody?.contactTestBitMask = CategoryBitMasks.skate
        addChild(truck)
        
    }
    
    //MARK: Hole Creation
    private func createHole(named: String, size: CGSize) {
        hole = SKSpriteNode(imageNamed: named)
        hole.name = named
        hole.position = CGPoint(x: 0, y: frame.height*0.07)
        hole.aspectFillToSize(fillSize: size)
        hole.zPosition = 3
        if levelModel.holeOpened {
            hole.physicsBody?.isDynamic = false
            hole.physicsBody = SKPhysicsBody(texture: hole.texture!, size: hole.size)
            hole.physicsBody?.categoryBitMask = CategoryBitMasks.hole
            hole.physicsBody?.contactTestBitMask = CategoryBitMasks.skate | CategoryBitMasks.mouse
            hole.physicsBody?.collisionBitMask &= ~CategoryBitMasks.object
            hole.physicsBody?.collisionBitMask &= ~CategoryBitMasks.mouse
            hole.physicsBody?.collisionBitMask &= ~CategoryBitMasks.skate
        } else { hole.physicsBody?.isDynamic = false }
        addChild(hole)
    }
    
    //MARK: Open Hole Closer Creation
    private func createOpenHoleCloser() {
        openHole = SKSpriteNode(imageNamed: "holeOpenedCloser")
        openHole.aspectFillToSize(fillSize: CGSize(width: 80, height: 80))
        openHole.name = "holeOpenedCloser"
        openHole.position = CGPoint(x: -openHole.size.width*0.4, y: hole.position.y*0.4)
        openHole.physicsBody?.isDynamic = false
        hole.addChild(openHole)
    }
    
    // MARK: UI Creation
    private func createScoreLabel() {
        scoreLabel = SKLabelNode(text: "Score: \(score)")
        scoreLabel.position = CGPoint(x: -frame.size.width/2 + scoreLabel.calculateAccumulatedFrame().width/3, y: frame.size.height/2 - scoreLabel.calculateAccumulatedFrame().height - 15)
        scoreLabel.zPosition = 100
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontName = "Futura Bold"
        if levelModel.scoreLevel == "level3" || levelModel.scoreLevel == "level5" || levelModel.scoreLevel == "level6" {
            scoreLabel.fontColor = .white
        } else { scoreLabel.fontColor = .black }
        addChild(scoreLabel)
    }
    
    private func createGoalLabel() {
        if levelModel.scoreLevel == "level2" || levelModel.scoreLevel == "level4" {
            goalLabel = SKLabelNode(text: "Mission: \(missionObjects)")
            goalLabel.position = CGPoint(x: scoreLabel.position.x, y: scoreLabel.position.y - goalLabel.calculateAccumulatedFrame().height - 10)
                    goalLabel.zPosition = 100
            goalLabel.horizontalAlignmentMode = .left
            goalLabel.fontName = "Futura Bold"
            if levelModel.scoreLevel == "level3" || levelModel.scoreLevel == "level5" || levelModel.scoreLevel == "level6" {
                goalLabel.fontColor = .white
            } else { goalLabel.fontColor = .black }
            addChild(goalLabel)
        } else { return }
    }
    
    private func createPauseButton() {
        if levelModel.scoreLevel == "level3" || levelModel.scoreLevel == "level5" || levelModel.scoreLevel == "level6" {
            pauseButton = SKSpriteNode(imageNamed: "pauseWhite")
        } else { pauseButton = SKSpriteNode(imageNamed: "pauseBlack") }
        pauseButton.size = CGSize(width: 40, height: 40)
        pauseButton.position = CGPoint(x: frame.size.width/2 - pauseButton.calculateAccumulatedFrame().width - 10, y: frame.size.height/2 - pauseButton.calculateAccumulatedFrame().height + 5)
        pauseButton.zPosition = 101
        addChild(pauseButton)
    }
    
    private func createLifesView() {
        lifesView = GameLivesView(frame: CGRect(x: frame.size.width / 2 - 60, y: frame.size.height*0.02, width: 120, height: 60))
        self.view?.addSubview(lifesView)
    }
    
    //MARK: Overscreen View Creation
    private func createAndShowHelp() {
        let corner = CGPoint(x: frame.midX, y: frame.midY)
        introView = OverscreenReusableView(frame: CGRect(origin: corner, size: CGSize(width: frame.width, height: frame.height)), imageName: levelModel.mission, bottomText: "Tap anywhere to start", resetButton: false)
        introView.delegate = self
        isPaused = true
        self.view?.addSubview(introView)
    }
    
    private func createAndShowGameOver() {
        let corner = CGPoint(x: frame.midX, y: frame.midY)
        gameOverView = GameOverView(frame: CGRect(origin: corner, size: CGSize(width: frame.width, height: frame.height)), imageName: "GameOver", score: score, isMission: missionInItems, mission: missionObjects, bottomText: "Restart or tap anywhere to chose another level", resetButton: true)
        gameOverView.button.addTarget(self, action: #selector(restart), for: .touchUpInside)
        gameOverView.delegate = self
        print("ADD GAME OVER")
        self.view?.addSubview(gameOverView)
    }
    
    // MARK: Objects Creation
    private func createGameObject(named: String) -> SKSpriteNode {
        let texture = SKTexture(imageNamed: named)
        let object = SKSpriteNode(texture: texture)
        object.name = named
        object.aspectFillToSize(fillSize: CGSize(width: 60, height: 60))
        object.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        object.zPosition = 4
        object.physicsBody = SKPhysicsBody(texture: texture, size: CGSize(width: object.size.width, height: object.size.height))
        object.physicsBody?.categoryBitMask = CategoryBitMasks.object
        object.physicsBody?.contactTestBitMask = CategoryBitMasks.skate | CategoryBitMasks.mouse
        object.physicsBody?.collisionBitMask &= ~CategoryBitMasks.object
        object.physicsBody?.collisionBitMask &= ~CategoryBitMasks.hole
        return object
    }
    
    func generateObjectsArray(from model: Levels) {
        for item in model.items {
            let object = createGameObject(named: item)
            objectsArray.append(object)
        }
    }
    
    //MARK: Objects Position
    func setObjectPosition(for object: SKSpriteNode) {
        if object.name == Items.cheese {
            var rabbitPosition = skate.position
            if rabbitPosition.y < (-frame.size.height*0.2) {
                rabbitPosition = CGPoint(x: -rabbitPosition.x, y: (frame.size.height*0.18))
                object.position.x = CGFloat(rabbitPosition.x)
                object.position.y = CGFloat(rabbitPosition.y)
            } else {
                object.position.x = CGFloat(-rabbitPosition.x)
                object.position.y = CGFloat(-rabbitPosition.y)
            }
        } else if object.name == Items.carrot {
            let randomXPosition = CGFloat.random(in: (-frame.size.width/2.3)...frame.size.width/2.2)
            var rabbitPosition = skate.position
            if rabbitPosition.y < (-frame.size.height*0.2) {
                rabbitPosition = CGPoint(x: rabbitPosition.x, y: (frame.size.height*0.18))
                object.position.x = CGFloat(CGFloat(randomXPosition))
                object.position.y = CGFloat(rabbitPosition.y)
            } else {
                object.position.x = CGFloat(CGFloat(CGFloat.random(in: (-frame.size.width/2.3)...frame.size.width/2.2)))
                object.position.y = CGFloat(-rabbitPosition.y)
            }
        } else {
            let screenWidth = frame.size.width
            let randomXPosition = CGFloat.random(in: (-screenWidth/2.3)...screenWidth/2.2)
            object.position.x = CGFloat(randomXPosition)
            let screenHeigh = frame.size.height
            let randomYPosition = CGFloat.random(in: (-screenHeigh/2.6)...screenHeigh*0.22)
            object.position.y = CGFloat(randomYPosition)
        }
    }
    
    //MARK: Objects Massive Creation
    
    func objectRunActionWithAppearanceInterval (names: [String]) {
        var setRemoveDuration = Double.random(in: 4...8)
        let createNode = SKAction.run { [self] in
            
            let name = names[Int.random(in: 0..<names.count)]
            let sprite = createGameObject(named: name)
            setObjectPosition(for: sprite)
            if name == Items.cheese {
                cheeseOnScreen += 1
                setRemoveDuration = 10
                if let isCheese = self.childNode(withName: Items.cheese) {
                    if cheeseOnScreen > 2 { return }
                    sprite.position = CGPoint(x: -isCheese.position.x, y: isCheese.position.y*0.8)
                }
            }
            if name == Items.carrot {
                setRemoveDuration = 6
                if self.childNode(withName: Items.carrot) != nil {
                    return
                }
            }
            let wait = SKAction.wait(forDuration: setRemoveDuration)
            let removeNode = SKAction.removeFromParent()
            sprite.run(SKAction.sequence([wait, removeNode]))
            self.addChild(sprite)
        }
        let duration = Double.random(in: 3...6)
        let range = Double.random(in: 5...15)
        let objectCreationDelay = SKAction.wait(forDuration: duration, withRange: range)
        
        let objectSequenceAction = SKAction.sequence([objectCreationDelay, createNode])
        let objectRunAction = SKAction.repeatForever(objectSequenceAction)
        
        run(objectRunAction)
        
    }
    
    //MARK: Movement Time Calculation
    
    func distanceCalculate(a: CGPoint, b: CGPoint) -> CGFloat {
        sqrt((b.x - a.x)*(b.x - a.x) + (b.y - a.y)*(b.y - a.y))
    }
    
    func timeToDistance(distance: CGFloat, speed: CGFloat) -> TimeInterval {
        TimeInterval(distance / speed)
    }
    
    // MARK: Actions
    private func mouseRun() {
        let distance = distanceCalculate(a: mouse.position, b: skate.position)
        let speed: CGFloat = 100
        let time = timeToDistance(distance: distance, speed: speed)
        let moveAction = SKAction.move(to: skate.position, duration: time)
        mouse.run(moveAction)
    }
    
    private func rotateMouse(to targetAngle: CGFloat) {
        let rotateAction = SKAction.rotate(toAngle: targetAngle, duration: 0.1, shortestUnitArc: true)
        mouse.run(rotateAction)
    }
    
    private func rotateRabbit(to targetAngle: CGFloat) {
        let rotateAction = SKAction.rotate(toAngle: targetAngle, duration: 0.1, shortestUnitArc: true)
        rabbit.run(rotateAction)
    }
    // MARK: didBegin (collisions)
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if contact.bodyA.categoryBitMask == CategoryBitMasks.skate && contact.bodyB.categoryBitMask == CategoryBitMasks.mouse || contact.bodyB.categoryBitMask == CategoryBitMasks.skate && contact.bodyA.categoryBitMask == CategoryBitMasks.mouse {
            if mouse.speed > 0 && !contacted {
                contacted = true
                skate.highlitWithDuration(0.2)
                mouse.isPaused = true
                mouse.physicsBody?.isDynamic = false
                mouseHit += 1
                Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.rabbitRelease), userInfo: nil, repeats: false)
                Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.mouseRelease), userInfo: nil, repeats: false)
                let storedValue: Int? = storage.value(forKey: levelModel.scoreLevel) as? Int
                let storedScore: Int = (storedValue != nil) ? storedValue! : 0
                if storedScore < score {
                    storage.set(score, forKey: levelModel.scoreLevel)
                }
                if lifesView.isthirdLife {
                    lifesView.removeThirdLife()
                } else if lifesView.isSecondLife {
                    lifesView.removeSecondLife()
                } else if lifesView.isFirstLife {
                    lifesView.removeFirstLife()
                }
            }
        }
        
        if contact.bodyA.categoryBitMask == CategoryBitMasks.skate && contact.bodyB.categoryBitMask == CategoryBitMasks.hole || contact.bodyB.categoryBitMask == CategoryBitMasks.skate && contact.bodyA.categoryBitMask == CategoryBitMasks.hole {
            lifesView.removeThirdLife()
            lifesView.removeSecondLife()
            lifesView.removeFirstLife()
        }
        
        if contact.bodyA.categoryBitMask == CategoryBitMasks.mouse && contact.bodyB.categoryBitMask == CategoryBitMasks.hole || contact.bodyB.categoryBitMask == CategoryBitMasks.mouse && contact.bodyA.categoryBitMask == CategoryBitMasks.hole {
            let action = SKAction.run {
                self.mouse.position = CGPoint(x: -self.frame.width*1.6, y: -self.frame.height*1.6)
            }
            mouse.run(action)
        }
        
        if contact.bodyA.categoryBitMask == CategoryBitMasks.skate && contact.bodyB.categoryBitMask == CategoryBitMasks.object  {
            collision(with: nodeB)
        }
        if contact.bodyB.categoryBitMask == CategoryBitMasks.skate && contact.bodyA.categoryBitMask == CategoryBitMasks.object {
            collision(with: nodeA)
        }
        if contact.bodyA.categoryBitMask == CategoryBitMasks.mouse && contact.bodyB.categoryBitMask == CategoryBitMasks.object {
            if nodeB.name == Items.cheese {
                mouse.speed /= 2
                let scaleSize = CGSize(width: mouse.size.width * 1.5, height: mouse.size.height * 1.5)
                mouse.scale(to: scaleSize)
                nodeB.removeFromParent()
                Timer.scheduledTimer(timeInterval: 6.0, target: self, selector: #selector(self.mouseSpeedUp), userInfo: nil, repeats: false)
            } else { nodeB.removeFromParent() }
        }
        if  contact.bodyB.categoryBitMask == CategoryBitMasks.mouse && contact.bodyA.categoryBitMask == CategoryBitMasks.object {
            if nodeA.name == Items.cheese {
                cheeseOnScreen -= 1
                mouse.speed /= 2
                let scaleSize = CGSize(width: mouse.size.width * 1.5, height: mouse.size.height * 1.5)
                mouse.scale(to: scaleSize)
                nodeA.removeFromParent()
                Timer.scheduledTimer(timeInterval: 6.0, target: self, selector: #selector(self.mouseSpeedUp), userInfo: nil, repeats: false)
            } else { nodeA.removeFromParent() }
        }
    }
    
    @objc func mouseRelease() {
        mouse.isPaused = false
        mouse.physicsBody?.isDynamic = true
        contacted = false
    }
    
    @objc func rabbitRelease() {
        skate.isPaused = false
    }
    
    // MARK: Objects Collision Result
    private func collision(with object: SKNode) {
        if object.name == Items.burger {
            self.score += 4
            self.scoreLabel.text = "Score: \(self.score)"
            object.removeFromParent()
        } else if object.name == Items.pizza {
            self.score += 6
            self.scoreLabel.text = "Score: \(self.score)"
            object.removeFromParent()
        } else if object.name == Items.hotDog {
            self.score += 8
            self.scoreLabel.text = "Score: \(self.score)"
            object.removeFromParent()
        } else if object.name == Items.goldenRabbit {
            self.score += 25
            self.scoreLabel.text = "Score: \(self.score)"
            if levelModel.titleImageName == "level2" {
                missionObjects += 1
                self.goalLabel.text = "Mission: \(self.missionObjects)"
            }
            object.removeFromParent()
        } else if object.name == Items.coins {
            self.score += 30
            self.scoreLabel.text = "Score: \(self.score)"
            if levelModel.titleImageName == "level4" {
                missionObjects += 1
                self.goalLabel.text = "Mission: \(self.missionObjects)"
            }
            object.removeFromParent()
        } else if object.name == Items.carrot {
            if !lifesView.isSecondLife {
                lifesView.addSecondLife()
            } else if !lifesView.isthirdLife {
                lifesView.addThirdLife()
            }
            object.removeFromParent()
        } else if object.name == Items.cheese {
            self.score -= 50
            self.scoreLabel.text = "Score: \(self.score)"
            cheeseOnScreen -= 1
            object.removeFromParent()
        } else if object.name == MysteryItems.mysteryBag {
            self.score += 25
            self.scoreLabel.text = "Score: \(self.score)"
            cheeseOnScreen -= 1
            object.removeFromParent()
        } else if object.name == MysteryItems.mysteryCards {
            self.score += 10
            self.scoreLabel.text = "Score: \(self.score)"
            cheeseOnScreen -= 1
            object.removeFromParent()
        } else if object.name == MysteryItems.mysteryCrystal {
            self.score += 15
            self.scoreLabel.text = "Score: \(self.score)"
            cheeseOnScreen -= 1
            object.removeFromParent()
        }  else if object.name == MysteryItems.mysteryMushroom {
            self.score -= 30
            self.scoreLabel.text = "Score: \(self.score)"
            cheeseOnScreen -= 1
            object.removeFromParent()
        }
    }
    
//    private func mysteryCollision()
    
    @objc func mouseSpeedUp() {
        mouse.speed = 1
        let normalSize = CGSize(width: mouse.size.width / 1.5, height: mouse.size.height / 1.5)
        mouse.scale(to: normalSize)
    }
    
    //MARK: Mission Goal Check
    private func checkMissionStatus() {
        if levelModel.titleImageName == "level1" {
            if score >= 200 {
                storage.set(true, forKey: "mission1")
            }
        } else if levelModel.titleImageName == "level2" {
            if missionObjects >= 20 {
                storage.setValue(true, forKey: "mission2")
            }
        } else if levelModel.titleImageName == "level3" {
            if score >= 300 {
                storage.setValue(true, forKey: "mission3")
            }
        } else if levelModel.titleImageName == "level4" {
            if missionObjects > 30 {
                storage.setValue(true, forKey: "mission4")
            }
        } else if levelModel.titleImageName == "level5" {
            if score >= 500 {
                storage.setValue(true, forKey: "mission5")
            }
        }
    }
    
}
// MARK: Extensions
extension SKSpriteNode {
    func aspectFillToSize(fillSize: CGSize) {
        if let texture = self.texture {
            let horizontalRatio = fillSize.width / texture.size().width
            let verticalRatio = fillSize.height / texture.size().height
            let finalRatio = horizontalRatio < verticalRatio ? horizontalRatio : verticalRatio
            size = CGSize(width: texture.size().width * finalRatio, height: texture.size().height * finalRatio)
        }
    }
    
    func highlitWithDuration(_ duration: TimeInterval) {
        let highlitedAction = SKAction.fadeAlpha(to: 1, duration: duration)
        let unHighlitedAction = SKAction.fadeAlpha(to: 0.3, duration: duration)
        let pulseSequence = SKAction.sequence([unHighlitedAction, highlitedAction])
        let infiniteLoop = SKAction.repeat(pulseSequence, count: 3)
        
        self.run(infiniteLoop)
    }
}
