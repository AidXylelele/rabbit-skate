import Foundation
import UIKit

protocol StackViewDelegate {
    func didTapOnPauseView(at index: Int)
}

class PauseMenuStackView: UIStackView {
    var delegate: StackViewDelegate?
    let menusArray = ["MainMenu", "HighScore", "Help", "Continue"]
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        self.axis = .vertical
        self.distribution = .fillEqually
        self.alignment = .fill
        self.spacing = 10
        self.isUserInteractionEnabled = true
        createMenuImage()
        configureTapGestures()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTapGestures() {
         arrangedSubviews.forEach { view in
             view.isUserInteractionEnabled = true
             let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnPauseView))
             view.addGestureRecognizer(tapGesture)
         }
     }
    
    @objc func didTapOnPauseView(_ gestureRecognizer: UIGestureRecognizer) {
        if let index = arrangedSubviews.firstIndex(of: gestureRecognizer.view!) {
            delegate?.didTapOnPauseView(at: index)
        }
    }
    
    private func createMenuImage() {
        for name in menusArray {
            let image = UIImageView()
            image.image = UIImage(named: name)
            image.contentMode = .scaleAspectFit
            self.addArrangedSubview(image)
        }
    }
}
