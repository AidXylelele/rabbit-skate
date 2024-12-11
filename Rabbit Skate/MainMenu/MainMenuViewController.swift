import UIKit

class MainMenuViewController: UIViewController {
    private let backgroundImageView = UIImageView()
    private let underBackgroundImageView = UIImageView()
    private let gameTitleImage = UIImageView()
    private let stackView = UIStackView()
    private let startButton = UIButton()
    private let scoreButton = UIButton()
    private let helpButton = UIButton()
    private let levelsModel = LevelsModel()
    private let storage = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setAlbumDeviceOrientation()
        configureUnderBackground()
        configureBackground()
        configureGameTitle()
        configureButtons()
        configureStackView()
        checkLevelsPassed()
        checkAllLevelsPassed()
    }
    
    //MARK: - Check Levels Passed
    private func checkLevelsPassed() {
        levelsModel.levels.forEach { level in
            if storage.value(forKey: level.scoreLevel) as? Int ?? 0 > 200 {
                storage.setValue(true, forKey: "\(level.scoreLevel)Passed")
            }
        }
    }
    
    private func checkAllLevelsPassed() {
        var passed = false
        levelsModel.levels.forEach { level in
            if storage.value(forKey: "\(level.scoreLevel)Passed") as? Bool ?? false == true {
                passed = true
            } else { passed = false }
        }
        if passed {
            storage.setValue(true, forKey: "alllevelsPassed")
        }
    }
    
    // MARK: - View Configurations
    private func configureUnderBackground() {
        underBackgroundImageView.image = UIImage(named: "backgroundUnderMain")
        underBackgroundImageView.contentMode = .scaleAspectFill
        underBackgroundImageView.alpha = 0.7
        view.addSubview(underBackgroundImageView)
        underBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    underBackgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
                    underBackgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    underBackgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    underBackgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])
    }
    
    private func configureBackground() {
        backgroundImageView.image = UIImage(named: "backgroundMain")
        backgroundImageView.contentMode = .scaleAspectFit
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
                    backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])
    }
    
    private func configureGameTitle() {
        gameTitleImage.image = UIImage(named: "gameTitle")
        gameTitleImage.contentMode = .scaleAspectFill
        view.addSubview(gameTitleImage)
        gameTitleImage.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    gameTitleImage.topAnchor.constraint(equalTo: self.view.topAnchor),
                    gameTitleImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant:  view.frame.width * 0.2),
                    gameTitleImage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant:  -view.frame.width * 0.2),
                    gameTitleImage.heightAnchor.constraint(equalToConstant: self.view.frame.height * 0.34)
                ])
    }
    
    private func configureButtons() {
        startButton.setImage(UIImage(named: "StartMain"), for: .normal)
        startButton.addTarget(self, action: #selector(presentLevelsVC), for: .touchUpInside)
        scoreButton.setImage(UIImage(named: "HighScore"), for: .normal)
        scoreButton.addTarget(self, action: #selector(presentScoreVC), for: .touchUpInside)
        helpButton.setImage(UIImage(named: "Help"), for: .normal)
        helpButton.addTarget(self, action: #selector(presentHelpVC), for: .touchUpInside)
        helpButton.imageView?.contentMode = .scaleAspectFit
    }
    
    private func configureStackView() {
        stackView.axis = .vertical
        stackView.spacing = 5.0
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        stackView.addArrangedSubview(startButton)
        stackView.addArrangedSubview(scoreButton)
        stackView.addArrangedSubview(helpButton)
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant:  view.frame.width * 0.3),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant:  -view.frame.width * 0.3),
            stackView.topAnchor.constraint(equalTo: gameTitleImage.bottomAnchor)
        ])
    }
    
    private func setAlbumDeviceOrientation() {
           UIView.setAnimationsEnabled(false)
           AppUtility.lockOrientation(.landscape, andRotateTo: .landscapeRight)
           UIView.setAnimationsEnabled(true)
       }
    
    
    override var shouldAutorotate: Bool {
        return false
    }

    // MARK: - Navigation
    @objc private func presentLevelsVC() {
        let levelsVC = LevelsViewController()
        navigationController?.pushViewController(levelsVC, animated: false)
    }
    
    @objc private func presentScoreVC() {
        let storeVC = ScoreViewController()
        navigationController?.pushViewController(storeVC, animated: false)
    }
    
    @objc private func presentHelpVC() {
        let helpVC = HelpViewController()
        navigationController?.pushViewController(helpVC, animated: false)
    }
}
