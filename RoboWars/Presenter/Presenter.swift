//
//  Presenter.swift
//  RoboWars
//
//  Created by Dmitry Victorovich on 27.05.2022.
//

import Foundation

class Presenter: PresenterProtocol {
    
    weak var view: ViewProtocol!
    
    var score: Score!
    let maxScore = 3
    var button: RestartButtonModel!
    var topRobot: Robot!
    var bottomRobot: Robot!
    var bullets = [Bullet]()
    let step = 1
    var viewWidth: Int!
    var viewHeight: Int!
    var safeSpaceFromTop: Int!
    var moveTimer = Timer()
    var bulletTimer = Timer()
    var shotTimer = Timer()
    var bulletTag = -1
    
    enum MoveDirection: String {
        case left = "left"
        case right = "right"
    }
    
    enum Hand {
        case left
        case right
    }
    
    func configureSelfAndStart() {
        guard let view = view as? MainView else { return }
        viewWidth = Int(view.bounds.width)
        viewHeight = Int(view.bounds.height)
        safeSpaceFromTop = Int(view.safeAreaInsets.top)
        
        view.addBackground(with: Background.init().imageName)
        
        createScoreAndButton()
        configureRobotsAndStart()
    }
    
    private func createScoreAndButton() {
        score = Score(centerX: viewWidth / 2,
                      centerY: viewHeight / 3)
        
        button = RestartButtonModel(centerX: viewWidth / 2,
                                    centerY: Int(Double(viewHeight) - (Double(viewHeight) / 2.5)))
        
    }
    
    private func configureRobotsAndStart() {
        topRobot = TopRobot()
        bottomRobot = BottomRobot()
        topRobot.originX = (0...(viewWidth - topRobot.width)).randomElement() ?? 0
        topRobot.originY = safeSpaceFromTop
        bottomRobot.originX = (0...(viewWidth - bottomRobot.width)).randomElement() ?? 0
        bottomRobot.originY = viewHeight - bottomRobot.height - 20
        
        view.showRobotsImages(topRobot: topRobot, bottomRobot: bottomRobot)
        
        moveTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                         target: self,
                                         selector: #selector(moveRobots),
                                         userInfo: nil,
                                         repeats: true)
        shotTimer = Timer.scheduledTimer(timeInterval: 2,
                                         target: self,
                                         selector: #selector(robotsCanShot),
                                         userInfo: nil,
                                         repeats: true)
    }
    
    @objc private func moveRobots() {
        moveRobot(robot: &topRobot)
        moveRobot(robot: &bottomRobot)
        
        view.updateRobotsImagesPositions(topRobot: topRobot, bottomRobot: bottomRobot)
    }
    
    @objc private func robotsCanShot() {
        checkChanceToShotFor(robot: &topRobot)
        checkChanceToShotFor(robot: &bottomRobot)
    }
    
    private func moveRobot(robot: inout Robot) {
        
        if robot.runAway {
            robot.stepOfRun += 1
            robot.checkStillNeedRun()
            guard let direction = MoveDirection(rawValue: robot.runDirection) else { return }
            doStep(for: &robot, in: direction)
        } else {
            chooseDirectionFor(robot: robot) { direction in
                doStep(for: &robot, in: direction)
            }
            checkNeedRunAvayFor(robot: &robot)
        }
    }
    
    private func doStep(for robot: inout Robot, in chosenDirection: MoveDirection) {
        switch chosenDirection {
        case .left:
            robot.originX -= step
        case .right:
            robot.originX += step
        }
    }
    
    private func chooseDirectionFor(robot: Robot, completion: (MoveDirection) -> Void) {
        var direction: MoveDirection!
        let otherRobot = whoIsNotThis(robot: robot)
        
        if robot.centerX <= otherRobot.centerX && (robot.originX + robot.width + step) < viewWidth {
            direction = MoveDirection.right
        } else if robot.originX - step > 0 {
            direction = MoveDirection.left
        } else {
            direction = MoveDirection.right
        }
        
        completion(direction)
    }
    
    private func checkNeedRunAvayFor(robot: inout Robot) {
        var result = false
        switch robot {
        case is TopRobot:
            if bullets.contains(where: { bullet in
                bullet is BottomBullet &&
                robot.horizontalBody.contains(bullet.centerX)
            }) {
            	result = true
            	robot.stepOfRun = 0
                let bottomBullets = bullets.filter { bullet in
                    bullet is BottomBullet
                }
                chooseRunDirection(robot: &robot, from: bottomBullets)
            }
        case is BottomRobot:
            if bullets.contains(where: { bullet in
                bullet is TopBullet &&
                robot.horizontalBody.contains(bullet.centerX)
            }) {
            	result = true
            	robot.stepOfRun = 0
                let topBullets = bullets.filter { bullet in
                    bullet is TopBullet
                }
                chooseRunDirection(robot: &robot, from: topBullets)
            }
        default: break
        }
        robot.runAway = result
    }
    
    private func chooseRunDirection(robot: inout Robot, from bullets: [Bullet]) {
        switch  (robot.originX...robot.centerX).contains(bullets[0].centerX) {
        case false: // try run left
            if robot.originX > robot.width {
                robot.runDirection = MoveDirection.left.rawValue
            } else {
                robot.runDirection = MoveDirection.right.rawValue
            }
        case true: // try run right
            if (viewWidth - (robot.originX + robot.width)) > robot.width {
                robot.runDirection = MoveDirection.right.rawValue
            } else {
                robot.runDirection = MoveDirection.left.rawValue
            }
        }
    }
    
    private func whoIsNotThis(robot: Robot) -> Robot {
        var otherRobot: Robot!
        
        switch robot {
        case is TopRobot:
            otherRobot = bottomRobot
        case is BottomRobot:
            otherRobot = topRobot
        default: break
        }
        
        return otherRobot
    }
    
    private func checkChanceToShotFor(robot: inout Robot) {
        let otherRobot = whoIsNotThis(robot: robot)
        
        if otherRobot.horizontalBody.contains(robot.rightHandPosition) {
            if robot.haveAmmo && checkReadyToShoot() {
                fire(robot: &robot, from: Hand.right)
            }
        }
        if otherRobot.horizontalBody.contains(robot.leftHandPosition) {
            if robot.haveAmmo && checkReadyToShoot() {
                fire(robot: &robot, from: Hand.left)
            }
        }
    }
    
    private func checkReadyToShoot() -> Bool {
        return Bool.random()
    }
    
    private func fire(robot: inout Robot, from hand: Hand) {
        robot.haveAmmo = false
        bulletTag += 1
        var bullet: Bullet!
        if robot is TopRobot && hand == Hand.right {
            bullet = TopBullet(centerX: robot.rightHandPosition, originY: robot.originY + robot.height, tag: bulletTag)
        } else if robot is TopRobot && hand == Hand.left {
            bullet = TopBullet(centerX: robot.leftHandPosition, originY: robot.originY + robot.height, tag: bulletTag)
        } else if robot is BottomRobot && hand == Hand.right {
            bullet = BottomBullet(centerX: robot.rightHandPosition, tag: bulletTag)
            bullet.originY = robot.originY - bullet.height
        } else if robot is BottomRobot && hand == Hand.left {
            bullet = BottomBullet(centerX: robot.leftHandPosition, tag: bulletTag)
            bullet.originY = robot.originY - bullet.height
        }
        
        getSoundFor(bullet: bullet)
        bullets.append(bullet)
    
        let smoke = Smoke(centerX: bullet.centerX,
                          centerY: bullet.centerY)
        view.showBulletImage(bullet, with: smoke)
        if !bulletTimer.isValid {
            bulletTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                               target: self,
                                               selector: #selector(updateBulletsPositions),
                                               userInfo: nil,
                                               repeats: true)
        }
    }
    
    private func getSoundFor(bullet: Bullet) {
        switch bullet.type {
        case .bullet:
            SoundManager.play(sound: .bullet)
        case .blaster:
            SoundManager.play(sound: .blaster)
        case .rocket:
            SoundManager.play(sound: .rocket)
        }
    }
    
    @objc private func updateBulletsPositions() {
        bullets.enumerated().map { index, bullet in
            bullets[index].fly()
            bullets[index].indexInArray = index
        }
        view.updateBulletsImagesPositions(bullets)
        checkHit()
        checkBulletsIsOutOfScreen()
        checkBulletsAcross()
    }
    
    private func checkHit() {
        for bullet in bullets {
            if bullet is TopBullet {
                if bottomRobot.verticalBody.contains(bullet.facePosition) {
                    for point in bullet.horizontalBody {
                        if bottomRobot.horizontalBody.contains(point) {
                            removeWithHit(bullet: bullet)
                            plusScoreAndCheckStopGame(bullet: bullet)
                            return
                        }
                    }
                }
            } else if bullet is BottomBullet {
                if topRobot.verticalBody.contains(bullet.facePosition) {
                    for point in bullet.horizontalBody {
                        if topRobot.horizontalBody.contains(point) {
                            removeWithHit(bullet: bullet)
                            plusScoreAndCheckStopGame(bullet: bullet)
                            return
                        }
                    }
                }
            }
        }
    }
    
    private func plusScoreAndCheckStopGame(bullet: Bullet) {
        switch bullet {
        case is TopBullet:
            score.topRobotScore += 1
            if score.topRobotScore >= maxScore {
                stopGame(deathRobot: bottomRobot)
            } else {
                getHitSound()
            }
        case is BottomBullet:
            score.bottomRobotScore += 1
            if score.bottomRobotScore >= maxScore {
                stopGame(deathRobot: topRobot)
            } else {
                getHitSound()
            }
        default: break
        }
    }
    
    private func stopGame(deathRobot: Robot) {
        let finalExplosion = FinalExplosion(centerX: deathRobot.centerX,
                                            centerY: deathRobot.centerY)
        
        view.destroyRobot(tag: deathRobot.tag, with: finalExplosion)
        SoundManager.play(sound: .boom)
        view.addScoreViewAndButton(widh: score, and: button)
        moveTimer.invalidate()
        bulletTimer.invalidate()
        shotTimer.invalidate()
    }
    
    private func getHitSound() {
        SoundManager.play(sound: .hit)
        
        if Bool.random() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                SoundManager.play(sound: .penetration)
            }
        }
    }
    
    private func checkBulletsAcross() {
        guard bullets.count >= 2 else { return }
        if bullets[0].verticalBody.contains(bullets[1].facePosition) {
            if bullets[0].horizontalBody.contains(bullets[1].originX) ||
                bullets[0].horizontalBody.contains((bullets[1].originX + bullets[1].width)) {
                removeAllBullets()
                SoundManager.play(sound: .boom)
            }
        }
    }
    
    private func checkBulletsIsOutOfScreen() {
        for bullet in bullets {
            if bullet is TopBullet {
                if bullet.backPosition > viewHeight {
                    remove(bullet: bullet)
                }
            } else if bullet is BottomBullet {
                if bullet.backPosition < 0 {
                    remove(bullet: bullet)
                }
            }
        }
    }
    
    private func remove(bullet: Bullet) {
        
        switch bullet {
        case is TopBullet:
            topRobot.haveAmmo.toggle()
        case is BottomBullet:
            bottomRobot.haveAmmo.toggle()
        default: break
        }
        
        bullets.remove(at: bullet.indexInArray)
        view.removeBulletImageWith(tag: bullet.tag)
        
        if bullets.isEmpty {
            bulletTimer.invalidate()
        }
    }
    
    private func removeWithHit(bullet: Bullet) {
        let hit = Hit(centerX: bullet.centerX,
                      centerY: bullet.facePosition)
        
        switch bullet {
        case is TopBullet:
            topRobot.haveAmmo.toggle()
        case is BottomBullet:
            bottomRobot.haveAmmo.toggle()
        default: break
        }
        
        bullets.remove(at: bullet.indexInArray)
        view.removeBulletImageWith(tag: bullet.tag, with: hit)
        
        if bullets.isEmpty {
            bulletTimer.invalidate()
        }
    }
    
    private func removeAllBullets() {
        let explosion = AcrossExplosion(centerX: bullets[0].centerX,
                                        centerY: bullets[1].originY)
        bullets.removeAll()
        topRobot.haveAmmo.toggle()
        bottomRobot.haveAmmo.toggle()
        view.removeAllBulletImages(with: explosion)
        bulletTimer.invalidate()
    }
    
    func tellWhoWin() {
        if score.topRobotScore >= score.bottomRobotScore {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                SoundManager.play(sound: .countTerrWin)
            })
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                SoundManager.play(sound: .terrWin)
            })
        }
    }
    
    func restartGame() {
        bullets.removeAll()
        score.topRobotScore = 0
        score.bottomRobotScore = 0
        configureRobotsAndStart()
    }
}
