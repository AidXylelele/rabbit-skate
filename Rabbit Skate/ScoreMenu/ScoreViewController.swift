import UIKit

class ScoreViewController: UIViewController {
    private let background = UIImageView()
    private let returnButton = UIButton()
    private let mainStackView = UIStackView()
    private let firstStackView = UIStackView()
    private let secondStackView = UIStackView()
    private let storage = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackground()
        configureMainStackView()
        configureFirstStackView()
        configureSecondStackView()
        configureReturnButton()
    }
    
    //MARK: Firest Stack
    private func configureFirstStackView() {
        firstStackView.axis = .vertical
        firstStackView.distribution = .fillEqually
        firstStackView.alignment = .center
        firstStackView.spacing = 14
        
        for item in 1...3 {
            var score = ""
            if let recentScore = storage.string(forKey: "level\(item)") {
                score = "Best score: \(recentScore)"
            } else { score = "Not played yet" }
            let levelLabel = ScoreLabelView(level: item, score: score)
            firstStackView.addArrangedSubview(levelLabel)
        }
        mainStackView.addArrangedSubview(firstStackView)
        firstStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            firstStackView.topAnchor.constraint(equalTo: mainStackView.topAnchor),
            firstStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            firstStackView.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor),
            firstStackView.widthAnchor.constraint(equalToConstant: (view.frame.width * 0.9) / 2)
        ])
    }
    
    //MARK: Second Stack
    private func configureSecondStackView() {
        secondStackView.axis = .vertical
        secondStackView.distribution = .fillEqually
        secondStackView.alignment = .center
        secondStackView.spacing = 14
        
        for item in 4...6 {
            var score = ""
            if let recentScore = storage.string(forKey: "level\(item)") {
                score = "Best score: \(recentScore)"
            } else { score = "Not played yet" }
            let levelLabel = ScoreLabelView(level: item, score: score)
            secondStackView.addArrangedSubview(levelLabel)
        }
        mainStackView.addArrangedSubview(secondStackView)
        secondStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            secondStackView.topAnchor.constraint(equalTo: mainStackView.topAnchor),
            secondStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            secondStackView.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor),
            secondStackView.widthAnchor.constraint(equalToConstant: (view.frame.width * 0.9) / 2)
        ])
    }
    
    // MARK: Main Stack
    private func configureMainStackView() {
        mainStackView.axis = .horizontal
        mainStackView.alignment = .fill
        mainStackView.distribution = .fillEqually
        mainStackView.spacing = 5.0
        view.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: -10),
            mainStackView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.56),
            mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
    }
    
    private func configureBackground() {
        background.image = UIImage(named: "scoreBackground")
        background.contentMode = .scaleAspectFill
        
        view.addSubview(background)
        background.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureReturnButton() {
        returnButton.setImage(UIImage(named: "back"), for: .normal)
        returnButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        view.addSubview(returnButton)
        returnButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            returnButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            returnButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            returnButton.widthAnchor.constraint(equalToConstant: 40),
            returnButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - Navigation
    
        @objc private func backButtonPressed() {
            navigationController?.popViewController(animated: false)
    }
}
