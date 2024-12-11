
import UIKit

class HelpViewController: UIViewController {
    private let returnButton = UIButton()
    private let descriptionImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        configureDescritpion()
        configureReturnButton()
    }
    
    private func configureDescritpion() {
        descriptionImageView.image = UIImage(named: "HelpScreen")
        descriptionImageView.contentMode = .scaleAspectFit
        view.addSubview(descriptionImageView)
        descriptionImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionImageView.topAnchor.constraint(equalTo: view.topAnchor),
            descriptionImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            descriptionImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            descriptionImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
