import Foundation
import UIKit

class GameOverView: UIView {
    var delegate: ReusableViewDelegate?
    var image = UIImageView()
    var scoreLabel = UILabel()
    var missionLabel = UILabel()
    var bottomLabel = UILabel()
    var item: String = ""
    var restart = ""
    var button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, imageName: String, score: Int, isMission: Bool, mission: Int, bottomText: String, resetButton: Bool) {
        super.init(frame: frame)
        createbackground()
        createImage(named: imageName)
        configureScoreLabel(with: score)
        if isMission {
            configureMisiionLabel(with: mission)
        }
        createBottomLabel(with: bottomText)
        createRestartButton(when: resetButton)
        configureTapGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createbackground() {
        let background = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        background.backgroundColor = .gray
        background.alpha = 0.8
        addSubview(background)
    }
    
    private func createImage(named: String) {
        image.image = UIImage(named: named)
        item = named
        image.contentMode = .scaleAspectFit
        addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: centerXAnchor),
            image.topAnchor.constraint(equalTo: topAnchor),
            image.heightAnchor.constraint(equalToConstant: frame.height/4)
        ])
    }
    
    private func configureScoreLabel(with score: Int) {
        scoreLabel.text = "Your score: \(score)"
        scoreLabel.textColor = .white
        scoreLabel.textAlignment = .center
        scoreLabel.font = UIFont(name: "Kailasa Bold", size: 22)
        addSubview(scoreLabel)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scoreLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            scoreLabel.heightAnchor.constraint(equalToConstant: 30),
            scoreLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func configureMisiionLabel(with score: Int) {
        missionLabel.text = "Mission collected: \(score)"
        missionLabel.textColor = .white
        missionLabel.textAlignment = .center
        missionLabel.font = UIFont(name: "Kailasa Bold", size: 22)
        addSubview(missionLabel)
        missionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            missionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            missionLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            missionLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func createBottomLabel(with text: String) {
        bottomLabel.text = text
        bottomLabel.textColor = .white
        bottomLabel.textAlignment = .center
        bottomLabel.font = UIFont(name: "Kailasa", size: 16)
        addSubview(bottomLabel)
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomLabel.heightAnchor.constraint(equalToConstant: 60),
            bottomLabel.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }
    
    private func createRestartButton(when isButton: Bool) {
        guard isButton == true else { return }
        button.setImage(UIImage(named: "Restart"), for: .normal)
        addSubview(button)
        restart = "Restart"
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: bottomLabel.topAnchor),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.heightAnchor.constraint(equalToConstant: 100),
            button.widthAnchor.constraint(equalToConstant: 240)
        ])
    }
    
    private func configureTapGestures() {
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnReusableView))
        addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapOnReusableView(_ gestureRecognizer: UIGestureRecognizer) {
        delegate?.didTapOnReusableView()
    }
}
