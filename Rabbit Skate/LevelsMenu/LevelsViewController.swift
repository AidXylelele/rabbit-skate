import UIKit

class LevelsViewController: UIViewController {
    private let backgroundImageView = UIImageView()
    private let stackBackground = UIView()
    private let backButton = UIButton()
    private let mainStackView = UIStackView()
    private let firstStackView = UIStackView()
    private let secondStackView = UIStackView()
    private let startButton = UIButton()
    private let storage = UserDefaults.standard
    var levelsModel = LevelsModel()
    var levelsArray = [LevelsView]()
    var checkAllMissions = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createArrayOfLevels()
        checkSecretLevel()
        configureBackground()
        configureBackButton()
        configureStackBackgroundView()
        configureMainStackView()
        configureFirstStackView()
        configureSecondStackView()
        checkSecretLevel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkSecretLevel()
        for item in levelsArray {
            if (storage.value(forKey: item.mission) != nil) {
                item.star.image = UIImage(named: "star")
            }
            if let score = storage.value(forKey: item.scoreLevel) {
                item.levelScore.text = "Best score: \(score)"
                item.levelScore.isHidden = false
            } else { item.levelScore.isHidden = true }
        }
    }
    
    //MARK: Check Secret Level
    private func checkSecretLevel() {
        levelsModel.levels.forEach { level in
            guard storage.value(forKey: level.mission) != nil else { return }
            checkAllMissions += 1
        }
        if checkAllMissions < 5  {
            levelsArray.last?.startButton.isHidden = true
        } else {
            levelsArray.last?.startButton.isHidden = false
        }
    }
    
    //MARK: Create Levels
    private func createArrayOfLevels() {
        for item in 0...5 {
            let levelView = LevelsView(with: levelsModel.levels[item])
            levelsArray.append(levelView)
        }
    }
    
    //MARK: Configure Views
    private func configureBackground() {
        backgroundImageView.image = UIImage(named: "backgroundUnderMain")
        backgroundImageView.alpha = 0.7
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureStackBackgroundView() {
        view.addSubview(stackBackground)
        stackBackground.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackBackground.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackBackground.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8),
            stackBackground.heightAnchor.constraint(equalToConstant: view.frame.height * 0.8)
        ])
    }
    
    private func configureBackButton() {
        backButton.addTarget(self, action: #selector(backToMain), for: .touchUpInside)
        
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func stackLinesConfigure(for stackView: UIStackView) {
        stackView.axis = .horizontal
        stackView.spacing = 5.0
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
    }
    // MARK: First Stack
    private func configureFirstStackView() {
        stackLinesConfigure(for: firstStackView)
        for item in 0...2 {
            let level = levelsArray[item]
            level.startButton.tag = item
            level.startButton.addTarget(self, action: #selector(presentGameVC(_:)), for: .touchUpInside)
            firstStackView.addArrangedSubview(level)
        }
        mainStackView.addArrangedSubview(firstStackView)
        firstStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            firstStackView.topAnchor.constraint(equalTo: mainStackView.topAnchor),
            firstStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            firstStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            firstStackView.heightAnchor.constraint(equalToConstant: (view.frame.height * 0.8) / 2)
        ])
    }
    // MARK: Second Stack
    private func configureSecondStackView() {
        stackLinesConfigure(for: secondStackView)
        for item in 3...5 {
            let level = levelsArray[item]
            level.startButton.tag = item
            level.startButton.addTarget(self, action: #selector(presentGameVC(_:)), for: .touchUpInside)
            secondStackView.addArrangedSubview(level)
        }
        mainStackView.addArrangedSubview(secondStackView)
        secondStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            secondStackView.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor),
            secondStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            secondStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            secondStackView.heightAnchor.constraint(equalToConstant: (view.frame.height * 0.8) / 2)
        ])
    }
    // MARK: Main Stack
    private func configureMainStackView() {
        mainStackView.axis = .vertical
        mainStackView.alignment = .fill
        mainStackView.distribution = .fillEqually
        mainStackView.spacing = 5.0
        stackBackground.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: stackBackground.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: stackBackground.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: stackBackground.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: stackBackground.bottomAnchor)
        ])
    }


    // MARK: - Navigation
    @objc private func presentGameVC(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "GameStoryboard", bundle: nil)
        let gameVC = (storyboard.instantiateViewController(identifier: "GameViewController")) as GameViewController
        gameVC.levelModel = levelsModel.levels[sender.tag]
        navigationController?.pushViewController(gameVC, animated: false)
    }
    
    @objc private func backToMain() {
        navigationController?.popViewController(animated: false)
    }
}
