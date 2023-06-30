import SwiftUI
import SpriteKit

struct GameView: UIViewRepresentable {
    func makeUIView(context: Context) -> SKView {
        let scene = GameScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .aspectFill
        
        let view = SKView(frame: UIScreen.main.bounds)
        view.showsFPS = true
        view.showsNodeCount = true
        view.ignoresSiblingOrder = true
        view.presentScene(scene)
        
        return view
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {}
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var student = SKSpriteNode()
    var background = SKSpriteNode()
    var gameOver = false

    var timer = Timer()
    var playingDuration: TimeInterval = 0

    enum ColliderType: UInt32 {
        case Student = 1
        case Object = 2
        case Gap = 4
    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        setupGame()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view?.addGestureRecognizer(tapGesture)
    }
    
    @objc func updatePlayingDuration() {
        playingDuration += 1
        
        if playingDuration > 30 {
            gameOver = true
            timer.invalidate()
            
            let gameOverLabel = SKLabelNode()
            gameOverLabel.fontName = "Helvetica"
            gameOverLabel.fontSize = 30
            gameOverLabel.text = "Вы нашли!"
            gameOverLabel.position = CGPoint(x: size.width/2, y: size.height/2)
            
            self.addChild(gameOverLabel)
        }
    }

    func setupGame() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(addPipes), userInfo: nil, repeats: true)


        let backgroundTexture = SKTexture(imageNamed: "background.png")
        let moveBackground = SKAction.moveBy(x: -backgroundTexture.size().width, y: 0, duration: 9)
        let shiftBackground = SKAction.moveBy(x: backgroundTexture.size().width, y: 0, duration: 0)
        let moveBackgroundForever = SKAction.repeatForever(SKAction.sequence([moveBackground, shiftBackground]))
        
        var i: CGFloat = 0
        
        while i < 3 {
            background = SKSpriteNode(texture: backgroundTexture)
            background.position = CGPoint(x: backgroundTexture.size().width * i, y: frame.midY)
            background.size.height = self.frame.height
            background.run(moveBackgroundForever)
            background.zPosition = -1
            self.addChild(background)
            
            i += 1
        }
        
        let birdTexture1 = SKTexture(imageNamed: "bird1.png")
        let birdTexture2 = SKTexture(imageNamed: "bird2.png")
        let animation = SKAction.animate(with: [birdTexture1, birdTexture2], timePerFrame: 0.1)
        let makeBirdFlap = SKAction.repeatForever(animation)
        
        student = SKSpriteNode(texture: birdTexture1)
        student.position = CGPoint(x: frame.midX, y: frame.midY)
        student.run(makeBirdFlap)
     
        let birdSize = CGSize(width: 200, height: 150)
        student.size = birdSize
        
        student.physicsBody = SKPhysicsBody(circleOfRadius: birdSize.width / 2)
        student.physicsBody!.isDynamic = false
        student.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        student.physicsBody!.categoryBitMask = ColliderType.Student.rawValue
        student.physicsBody!.collisionBitMask = ColliderType.Student.rawValue
        self.addChild(student)
        
        let ground = SKNode()
        ground.position = CGPoint(x: frame.midX, y: -frame.height / 2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: frame.width, height: 1))
        ground.physicsBody!.isDynamic = false
        ground.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        ground.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        ground.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        self.addChild(ground)
        

    }

    
    
    @objc func addPipes() {
        let gapHeight = student.size.height * 4
        let pipeOffset1 = frame.height / 4
        let pipeOffset2 = -(frame.height / 4)
        
        let minHeight = -frame.height / 2.5
        let maxHeight = frame.height / 2.5
        let randomHeight1 = CGFloat.random(in: minHeight...maxHeight)
        let randomHeight2 = CGFloat.random(in: minHeight...maxHeight)
        
        let pipeTexture1 = SKTexture(imageNamed: "pipe1.png")
        let pipe1 = SKSpriteNode(texture: pipeTexture1)
        pipe1.position = CGPoint(x: frame.midX + frame.width, y: frame.midY + pipeTexture1.size().height / 2 + gapHeight / 2 + pipeOffset1 + randomHeight1)
        pipe1.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture1.size())
        pipe1.physicsBody?.isDynamic = false
        pipe1.physicsBody?.categoryBitMask = ColliderType.Object.rawValue
        self.addChild(pipe1)
        
        let pipeTexture2 = SKTexture(imageNamed: "pipe2.png")
        let pipe2 = SKSpriteNode(texture: pipeTexture2)
        pipe2.position = CGPoint(x: frame.midX + frame.width, y: frame.midY - pipeTexture2.size().height / 2 - gapHeight / 2 + pipeOffset2 + randomHeight2)
        pipe2.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture2.size())
        pipe2.physicsBody?.isDynamic = false
        pipe2.physicsBody?.categoryBitMask = ColliderType.Object.rawValue
        self.addChild(pipe2)
        
        let gap = SKNode()
        gap.position = CGPoint(x: frame.midX + frame.width, y: frame.midY + pipeOffset1 + randomHeight1)
        gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeTexture1.size().width, height: gapHeight))
        gap.physicsBody?.isDynamic = false
        gap.physicsBody?.categoryBitMask = ColliderType.Gap.rawValue
        self.addChild(gap)
        
        let moveDistance = CGFloat(frame.width + 2 * pipeTexture1.size().width)
        
        let movePipes = SKAction.moveBy(x: -moveDistance, y: 0, duration: TimeInterval(moveDistance / 100))
        let removePipes = SKAction.removeFromParent()
        let moveAndRemovePipes = SKAction.sequence([movePipes, removePipes])
        
        pipe1.run(moveAndRemovePipes)
        pipe2.run(moveAndRemovePipes)
        gap.run(moveAndRemovePipes)
    }



    func didBegin(_ contact: SKPhysicsContact) {
        if gameOver == false {
            if contact.bodyA.categoryBitMask == ColliderType.Gap.rawValue || contact.bodyB.categoryBitMask == ColliderType.Gap.rawValue {
               
            } else {
               
                gameOver = true
                timer.invalidate()
                
                let gameOverLabel = SKLabelNode()
                gameOverLabel.fontName = "Helvetica"
                gameOverLabel.fontSize = 30
            
                if gameOver == true && playingDuration >= 30  {
                    gameOverLabel.text = "Вы выиграли! Найдите Хафизиус Блэк!"
                } else {
                    gameOverLabel.text = "Попытайтесь еще раз чтобы найти Хафизиус Блэк!"
                }
                gameOverLabel.numberOfLines = 2
                gameOverLabel.preferredMaxLayoutWidth = 300
                
                gameOverLabel.position = CGPoint(x: size.width/2, y: size.height/2)
                
                self.addChild(gameOverLabel)
            }
        }
    }



    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if gameOver == false {
            student.physicsBody!.isDynamic = true
            student.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
            student.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 500))
        } else {
            self.speed = 1
            self.removeAllChildren()
            
            setupGame()
            
            gameOver = false
        }
    }
}

struct ContentView: View {
    var body: some View {
        GameView()
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
