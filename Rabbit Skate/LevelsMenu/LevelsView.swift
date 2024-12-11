import Foundation
import UIKit

class LevelsView: UIView {
    private var titleImageView = UIImageView()
    public var star = UIImageView()
    private var gameImageView = UIImageView()
    public var levelScore = UILabel()
    public var startButton = UIButton()
    public var scoreLevel = ""
    public var mission = ""
    
    private let storage = UserDefaults.standard
    
    init(with model: Levels) {
        super.init(frame: .zero)
        layer.cornerRadius = 25
        layer.borderWidth = 3
        layer.borderColor = UIColor.black.cgColor
        layer.masksToBounds = true
        configure(with: model)
        mission = model.mission
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(with model: Levels) {
        gameImageView.image = UIImage(named: model.gameImageName)
        gameImageView.contentMode = .scaleAspectFill
        gameImageView.backgroundColor = .yellow
        addSubview(gameImageView)
        gameImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gameImageView.topAnchor.constraint(equalTo: topAnchor),
            gameImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gameImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gameImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        startButton.setImage(UIImage(named: "Start"), for: .normal)
        startButton.contentMode = .scaleAspectFit
        addSubview(startButton)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startButton.heightAnchor.constraint(equalToConstant: 38),
            startButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            startButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2)
        ])
        
        if (storage.value(forKey: model.mission) != nil) {
            star.image = UIImage(named: "star")
        } else { star.image = UIImage(named: "starEmpty") }
        star.contentMode = .scaleAspectFit
        addSubview(star)
        star.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            star.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            star.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            star.widthAnchor.constraint(equalToConstant: 30),
            star.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        titleImageView.image = UIImage(named: model.titleImageName)
        titleImageView.contentMode = .scaleAspectFit
        addSubview(titleImageView)
        titleImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleImageView.topAnchor.constraint(equalTo: topAnchor),
            titleImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            titleImageView.trailingAnchor.constraint(equalTo: star.leadingAnchor),
            titleImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        scoreLevel = model.scoreLevel
        if let score = storage.value(forKey: model.scoreLevel) {
            levelScore.text = "Best score: \(score)"
            levelScore.isHidden = false
        } else { levelScore.isHidden = true }
        levelScore.textAlignment = .center
        levelScore.font = UIFont(name: "Impact", size: 18)
        levelScore.textColor = .white
        addSubview(levelScore)
        levelScore.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            levelScore.bottomAnchor.constraint(equalTo: startButton.topAnchor),
            levelScore.leadingAnchor.constraint(equalTo: leadingAnchor),
            levelScore.trailingAnchor.constraint(equalTo: trailingAnchor),
            levelScore.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
