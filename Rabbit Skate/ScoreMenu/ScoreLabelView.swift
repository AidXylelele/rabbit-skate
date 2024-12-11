import Foundation
import UIKit

class ScoreLabelView: UIView {
    let levelLabel = UILabel()
    let scoreLabel = UILabel()
    
    init(level: Int, score: String) {
        super .init(frame: .zero)
        configureLevelLabel(with: level)
        configureScoreLabel(with: score)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLevelLabel(with level: Int) {
        levelLabel.font = UIFont(name: "Marker Felt Wide", size: 32)
        levelLabel.text = "Level \(level)"
        addSubview(levelLabel)
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            levelLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            levelLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            levelLabel.heightAnchor.constraint(equalToConstant: 38)
        ])
    }
    
    private func configureScoreLabel(with score: String) {
        scoreLabel.font = UIFont(name: "Marker Felt Wide", size: 24)
        scoreLabel.text = "\(score)"
        addSubview(scoreLabel)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: levelLabel.bottomAnchor),
            scoreLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            scoreLabel.heightAnchor.constraint(equalToConstant: 26)
        ])
    }
}
