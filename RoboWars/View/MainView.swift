//
//  MainView.swift
//  RoboWars
//
//  Created by Dmitry Victorovich on 27.05.2022.
//

import UIKit

class MainView: UIView {

    var presenter: PresenterProtocol!
    
    var backgroundImageView: UIImageView!
    let topRobotImageView = UIImageView()
    let bottomRobotImageView = UIImageView()
    var bulletsArray = [UIImageView]()
    var scoreView: ScoreView!
    var restartButton: RestartButton!
//    var blurView: UIVisualEffectView!

    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
    }
    
    func addRobotsToView() {
        presenter.configureSelfAndStart()
    }
}

extension MainView: ViewProtocol {
    
    func addBackground(with name: String) {
        backgroundImageView = UIImageView(image: .init(named: name))
        backgroundImageView.frame.size = frame.size
        backgroundImageView.center = center
        addSubview(backgroundImageView)
    }
    
    func showRobotsImages(topRobot: Robot, bottomRobot: Robot) {
        topRobotImageView.frame = CGRect(x: topRobot.originX,
                                         y: topRobot.originY,
                                         width: topRobot.width,
                                         height: topRobot.height)
        topRobotImageView.image = UIImage(named: topRobot.imageName)
        topRobotImageView.tag = topRobot.tag
        
        bottomRobotImageView.frame = CGRect(x: bottomRobot.originX,
                                            y: bottomRobot.originY,
                                            width: bottomRobot.width,
                                            height: bottomRobot.height)
        bottomRobotImageView.image = UIImage(named: bottomRobot.imageName)
        bottomRobotImageView.tag = bottomRobot.tag

        addSubview(topRobotImageView)
        addSubview(bottomRobotImageView)
    }
    
    func updateRobotsImagesPositions(topRobot: Robot, bottomRobot: Robot) {
        UIView.animate(withDuration: 0.1, delay: 0) {
            self.topRobotImageView.frame.origin.x = CGFloat(topRobot.originX)
            self.bottomRobotImageView.frame.origin.x = CGFloat(bottomRobot.originX)
        }
    }
    
    func showBulletImage(_ bullet: Bullet, with smoke: Smoke) {
        let bulletImageView = UIImageView(frame: CGRect(x: bullet.originX,
                                                        y: bullet.originY,
                                                        width: bullet.width,
                                                        height: bullet.height))
        bulletImageView.image = UIImage(named: bullet.imageName)
        bulletImageView.tag = bullet.tag
        addSubview(bulletImageView)
        bulletsArray.append(bulletImageView)
        
        let smokeImageView = UIImageView(image: .init(named: smoke.imageName))
        smokeImageView.frame.size = CGSize(width: smoke.width,
                                           height: smoke.height)
        smokeImageView.center = CGPoint(x: smoke.centerX,
                                        y: smoke.centerY)
        addSubview(smokeImageView)
        UIImageView.animate(withDuration: 1, delay: 0) {
            smokeImageView.alpha = 0
        } completion: { _ in
            smokeImageView.removeFromSuperview()
        }
    }
    
    func updateBulletsImagesPositions(_ bullets: [Bullet]) {
        for bulletImage in bulletsArray {
            for bullet in bullets {
                if bulletImage.tag == bullet.tag {
                    UIView.animate(withDuration: 0.15, delay: 0) {
                        bulletImage.frame.origin.y = CGFloat(bullet.originY)
                    }
                }
            }
        }
    }
    
    func removeBulletImageWith(tag: Int) {
        for bulletImage in bulletsArray {
            if bulletImage.tag == tag {
                bulletImage.removeFromSuperview()
            }
        }
    }
    
    func removeBulletImageWith(tag: Int, with hit: Hit) {
        let hitImageView = UIImageView(image: .init(named: hit.imageName))
        hitImageView.frame.size = CGSize(width: hit.width,
                                         height: hit.height)
        hitImageView.center = CGPoint(x: hit.centerX,
                                      y: hit.centerY)
        addSubview(hitImageView)
        
        UIView.animate(withDuration: 1, delay: 0) {
            hitImageView.alpha = 0
        } completion: { _ in
            hitImageView.removeFromSuperview()
        }
        
        for bulletImage in bulletsArray {
            if bulletImage.tag == tag {
                bulletImage.removeFromSuperview()
            }
        }
    }
    
    func removeAllBulletImages(with explosion: AcrossExplosion) {
        let explosionImageView = UIImageView(image: .init(named: explosion.imageName))
        explosionImageView.frame.size = CGSize(width: explosion.width,
                                               height: explosion.height)
        explosionImageView.center = CGPoint(x: explosion.centerX,
                                            y: explosion.centerY)
        addSubview(explosionImageView)
        
        UIView.animate(withDuration: 2, delay: 0) {
            explosionImageView.alpha = 0
        } completion: { _ in
            explosionImageView.removeFromSuperview()
        }

        bulletsArray.map { imageView in
            imageView.removeFromSuperview()
        }
        bulletsArray.removeAll()
    }
    
    func addScoreViewAndButton(widh score: Score, and button: RestartButtonModel) {
        scoreView = ScoreView(frame: CGRect(x: 0,
                                            y: 0,
                                            width: score.width,
                                            height: score.height))
        scoreView.center = CGPoint(x: score.centerX - 400,
                                   y: score.centerY)
        scoreView.topRobotScore = score.topRobotScore
        scoreView.bottomRobotScore = score.bottomRobotScore
        scoreView.updateScore()
        addSubview(scoreView)
        
        restartButton = RestartButton(frame: CGRect(x: 0,
                                                 	y: 0,
                                                 	width: button.width,
                                                    height: button.height))
        restartButton.center = CGPoint(x: button.centerX + 400,
                                       y: button.centerY)
        restartButton.addTarget(self,
                                action: #selector(restrartButtonDidPressed),
                                for: .touchUpInside)
        
//        let blurEffect = UIBlurEffect(style: .regular)
//        blurView = UIVisualEffectView(effect: blurEffect)
//        blurView.frame = restartButton.frame
//        blurView.layer.cornerRadius = restartButton.layer.cornerRadius
//        blurView.layer.masksToBounds = true
//
//        backgroundImageView.addSubview(blurView)
        addSubview(restartButton)
        
        UIView.animate(withDuration: 1, delay: 0) {
            self.moveObjects()
        } completion: { _ in
            self.presenter.tellWhoWin()
        }
    }
    
    private func moveObjects() {
        scoreView.frame = scoreView.frame.offsetBy(dx: 400, dy: 0)
        restartButton.frame = restartButton.frame.offsetBy(dx: -400, dy: 0)
//        blurView.frame = blurView.frame.offsetBy(dx: -400, dy: 0)
    }
    
    func destroyRobot(tag: Int, with explosion: FinalExplosion) {
        let finalExplosionImageView = UIImageView(image: .init(named: explosion.imageName))
        finalExplosionImageView.frame.size = CGSize(width: explosion.width,
                                                    height: explosion.height)
        finalExplosionImageView.center = CGPoint(x: explosion.centerX,
                                                 y: explosion.centerY)
        addSubview(finalExplosionImageView)
        
        let robotImageViewsArray = [topRobotImageView, bottomRobotImageView]
        for imageView in robotImageViewsArray {
            if imageView.tag == tag {
                imageView.image = UIImage(named: explosion.deathRobotImageName)
            }
        }
        
        UIView.animate(withDuration: 2, delay: 0) {
            finalExplosionImageView.alpha = 0
        } completion: { _ in
            finalExplosionImageView.removeFromSuperview()
        }
    }
    
    @objc private func restrartButtonDidPressed() {
        removeRobotsAndBullets()
        UIView.animate(withDuration: 1, delay: 0) {
            self.moveObjects()
        } completion: { _ in
            self.scoreView.removeFromSuperview()
            self.restartButton.removeFromSuperview()
//            self.blurView.removeFromSuperview()
            
            self.presenter.restartGame()
        }
    }
    
    private func removeRobotsAndBullets() {
        self.topRobotImageView.removeFromSuperview()
        self.bottomRobotImageView.removeFromSuperview()
        for bullet in self.bulletsArray {
            bullet.removeFromSuperview()
        }
        bulletsArray.removeAll()
    }
}
