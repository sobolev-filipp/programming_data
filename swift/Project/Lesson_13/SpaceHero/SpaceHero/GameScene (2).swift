//
//  GameScene.swift
//  SpaceHero
//
//  Created by Соболев Филипп on 04.06.2026.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // MARK: - Свойства

        var hero: SKSpriteNode!
        var scoreLabel: SKLabelNode!
        var tapCount = 0

        // MARK: - Загрузка сцены

        override func didMove(to view: SKView) {
            setupBackground()
            setupHero()
            setupScoreLabel()
        }

        // MARK: - Фон со звёздами

        func setupBackground() {
            backgroundColor = SKColor(red: 0.05, green: 0.05, blue: 0.2, alpha: 1.0)

            for _ in 0..<80 {
                let star = SKShapeNode(circleOfRadius: CGFloat.random(in: 0.5...2))
                star.fillColor = .white
                star.strokeColor = .clear
                star.alpha = CGFloat.random(in: 0.3...1.0)
                star.position = CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: CGFloat.random(in: 0...size.height)
                )
                addChild(star)
            }
        }

        // MARK: - Персонаж

        func setupHero() {
            hero = SKSpriteNode(color: .clear, size: CGSize(width: 70, height: 70))

            // Тело
            let body = SKShapeNode(rectOf: CGSize(width: 60, height: 60), cornerRadius: 12)
            body.fillColor = SKColor(red: 0.3, green: 0.8, blue: 1.0, alpha: 1.0)
            body.strokeColor = .white
            body.lineWidth = 2
            hero.addChild(body)

            // Левый глаз
            let leftEye = SKShapeNode(circleOfRadius: 8)
            leftEye.fillColor = .white
            leftEye.position = CGPoint(x: -12, y: 8)
            hero.addChild(leftEye)

            // Правый глаз
            let rightEye = SKShapeNode(circleOfRadius: 8)
            rightEye.fillColor = .white
            rightEye.position = CGPoint(x: 12, y: 8)
            hero.addChild(rightEye)

            // Левый зрачок
            let leftPupil = SKShapeNode(circleOfRadius: 4)
            leftPupil.fillColor = .black
            leftPupil.position = CGPoint(x: -12, y: 8)
            hero.addChild(leftPupil)

            // Правый зрачок
            let rightPupil = SKShapeNode(circleOfRadius: 4)
            rightPupil.fillColor = .black
            rightPupil.position = CGPoint(x: 12, y: 8)
            hero.addChild(rightPupil)

            // Позиция — центр экрана
            hero.position = CGPoint(x: size.width / 2, y: size.height / 2)
            addChild(hero)
        }

        // MARK: - Счётчик

        func setupScoreLabel() {
            scoreLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
            scoreLabel.text = "Нажатий: 0"
            scoreLabel.fontSize = 22
            scoreLabel.fontColor = .white
            scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 60)
            scoreLabel.horizontalAlignmentMode = .center
            addChild(scoreLabel)
        }

        // MARK: - Касание

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)

            tapCount += 1
            scoreLabel.text = "Нажатий: \(tapCount)"

            moveHeroTo(point: location)
            showTapMarker(at: location)
        }

        // MARK: - Движение персонажа

        func moveHeroTo(point: CGPoint) {
            let dx = point.x - hero.position.x
            let dy = point.y - hero.position.y
            let distance = sqrt(dx * dx + dy * dy)

            let speed: CGFloat = 300
            let duration = TimeInterval(distance / speed)

            let moveAction = SKAction.move(to: point, duration: duration)
            moveAction.timingMode = .easeInEaseOut

            hero.removeAction(forKey: "move")
            hero.run(moveAction, withKey: "move")

            // Зеркалим в сторону движения
            hero.xScale = dx > 0 ? 1 : -1
        }

        // MARK: - Маркер касания

        func showTapMarker(at point: CGPoint) {
            let marker = SKShapeNode(circleOfRadius: 15)
            marker.fillColor = SKColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 0.6)
            marker.strokeColor = .yellow
            marker.lineWidth = 2
            marker.position = point
            addChild(marker)

            let fadeOut = SKAction.fadeOut(withDuration: 0.4)
            let scaleUp = SKAction.scale(to: 2.0, duration: 0.4)
            let group = SKAction.group([fadeOut, scaleUp])
            let remove = SKAction.removeFromParent()
            marker.run(SKAction.sequence([group, remove]))
        }
}
