//
//  GameView.swift
//  nFactorialAtHogwarts
//
//  Created by Акбала Тлеугалиева on 30.06.2023.
//


import SwiftUI
import SpriteKit
import SceneKit
struct GameVieww: View {
    var body: some View {
        ZStack {
            SpriteView(scene: GameScense(size: CGSize(width: 300, height: 500)))
                .edgesIgnoringSafeArea(.all)
            
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameVieww()
    }
}


class GameScense: SKScene {
    private var voldemort: SKSpriteNode!
    private var student: SKSpriteNode!
    private var systemLifeLine: SKShapeNode!
    private var userLifeLine: SKShapeNode!
    private var centerLine: SKShapeNode!
    private var systemTimer: Timer?
    
    override func didMove(to view: SKView) {
        setupCharacters()
        setupLifeLines()
        setupCenterLine()
        startSystemLineGrowth()
    }
    
    func setupCharacters() {
        let backgroundTexture = SKTexture(imageNamed: "background.png")
        let background = SKSpriteNode(texture: backgroundTexture)
        background.size = CGSize(width: size.width, height: size.height)
        background.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        background.zPosition = -1
        addChild(background)
        
        voldemort = SKSpriteNode(imageNamed: "Beknar")
        voldemort.position = CGPoint(x: size.width * 0.25, y: size.height * 0.2)
        voldemort.setScale(0.3)
        addChild(voldemort)
        
        student = SKSpriteNode(imageNamed: "Balapan")
        student.position = CGPoint(x: size.width * 0.75, y: size.height * 0.2)
        student.setScale(0.2)
        addChild(student)
    }
    
    func setupLifeLines() {
        let systemLifeLinePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 1, height: 15))
        systemLifeLine = SKShapeNode(path: systemLifeLinePath.cgPath)
        systemLifeLine.position = CGPoint(x: size.width * 0.05, y: size.height - 20 - 30)
        systemLifeLine.fillColor = .red
        addChild(systemLifeLine)

        let userLifeLinePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 1, height: 15))
        userLifeLine = SKShapeNode(path: userLifeLinePath.cgPath)
        userLifeLine.position = CGPoint(x: size.width * 0.95, y: size.height - 20 - 30)
        userLifeLine.fillColor = .green
        addChild(userLifeLine)
    }
    
    func setupCenterLine() {
        let centerLinePath = UIBezierPath()
        centerLinePath.move(to: CGPoint(x: size.width * 0.5, y: 0))
        centerLinePath.addLine(to: CGPoint(x: size.width * 0.5, y: size.height))
        
        centerLine = SKShapeNode(path: centerLinePath.cgPath)
        centerLine.strokeColor = .white
        addChild(centerLine)
    }
    
    func startSystemLineGrowth() {
        systemTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.growLifeLine(node: self?.systemLifeLine)
        }
    }
    
    func stopSystemLineGrowth() {
        systemTimer?.invalidate()
        systemTimer = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        if touchLocation.y < size.height * 0.5 {
            growLifeLineOpposite(node: userLifeLine)
        }
        
        checkWinCondition()
        increaseScore()
    }
    
    func growLifeLine(node: SKShapeNode?) {
        guard let node = node else { return }
        
        let growthAmount: CGFloat = 10
        let currentWidth = node.path?.boundingBox.width ?? 0
        let newWidth = currentWidth + growthAmount
        
        let newLifeLinePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: newWidth, height: 20))
        node.path = newLifeLinePath.cgPath
    }
    
    func growLifeLineOpposite(node: SKShapeNode?) {
        guard let node = node else { return }
        
        let growthAmount: CGFloat = 10
        let currentWidth = node.path?.boundingBox.width ?? 0
        let currentX = node.path?.boundingBox.origin.x ?? 0
        let newWidth = currentWidth + growthAmount
        let newX = currentX - growthAmount
        
        let newLifeLinePath = UIBezierPath(rect: CGRect(x: newX, y: 0, width: newWidth, height: 20))
        node.path = newLifeLinePath.cgPath
    }
    
    func checkWinCondition() {
        let userLineWidth = userLifeLine.frame.width
        let systemLineWidth = systemLifeLine.frame.width
        let screenWidth = size.width
        
        if userLineWidth > screenWidth / 2 && userLineWidth > systemLineWidth {
            stopSystemLineGrowth()
            showAlert(message: "You win!")
        } else if systemLineWidth > screenWidth / 2 && userLineWidth < systemLineWidth {
            stopSystemLineGrowth()
            showAlert(message: "You lose!")
        }
    }

    
    func showAlert(message: String) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.restartGame()
        }))
        
        guard let viewController = self.view?.window?.rootViewController else { return }
        viewController.present(alert, animated: true, completion: nil)
    }
    
    
    func restartGame() {
        userLifeLine.removeFromParent()
        systemLifeLine.removeFromParent()
        centerLine.removeFromParent()
        
        setupLifeLines()
        setupCenterLine()
        startSystemLineGrowth()
    }
    
    func increaseScore() {
    }
}
