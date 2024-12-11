import Foundation
import UIKit

class GameLivesView: UIView {
    var firstLife = UIImageView()
    var secondLife = UIImageView()
    var thirdLife = UIImageView()
    
    var isthirdLife = true
    var isSecondLife = true
    var isFirstLife = true
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        configureLifeViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func removeFirstLife() {
        firstLife.image = UIImage(named: "LifeCarrotEmpty")
        isFirstLife = false
    }
    
    public func removeSecondLife() {
        secondLife.image = UIImage(named: "LifeCarrotEmpty")
        isSecondLife = false
    }
    
    public func removeThirdLife() {
        thirdLife.image = UIImage(named: "LifeCarrotEmpty")
        isthirdLife = false
    }
    
    public func addFirstLife() {
        firstLife.image = UIImage(named: "LifeCarrotFull")
        isFirstLife = true
    }
    
    public func addSecondLife() {
        secondLife.image = UIImage(named: "LifeCarrotFull")
        isSecondLife = true
    }
    
    public func addThirdLife() {
        thirdLife.image = UIImage(named: "LifeCarrotFull")
        isthirdLife = true
    }
    
    private func configureLifeViews() {
        firstLife.image = UIImage(named: "LifeCarrotFull")
        firstLife.contentMode = .scaleAspectFill
        addSubview(firstLife)
        firstLife.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            firstLife.topAnchor.constraint(equalTo: topAnchor),
            firstLife.leadingAnchor.constraint(equalTo: leadingAnchor),
            firstLife.widthAnchor.constraint(equalToConstant: 48),
            firstLife.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        secondLife.image = UIImage(named: "LifeCarrotFull")
        secondLife.contentMode = .scaleAspectFill
        addSubview(secondLife)
        secondLife.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            secondLife.topAnchor.constraint(equalTo: topAnchor),
            secondLife.leadingAnchor.constraint(equalTo: firstLife.trailingAnchor),
            secondLife.widthAnchor.constraint(equalToConstant: 48),
            secondLife.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        thirdLife.image = UIImage(named: "LifeCarrotFull")
        thirdLife.contentMode = .scaleAspectFill
        addSubview(thirdLife)
        thirdLife.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thirdLife.topAnchor.constraint(equalTo: topAnchor),
            thirdLife.leadingAnchor.constraint(equalTo: secondLife.trailingAnchor),
            thirdLife.widthAnchor.constraint(equalToConstant: 48),
            thirdLife.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
