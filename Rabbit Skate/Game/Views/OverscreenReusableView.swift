import Foundation
import UIKit

protocol ReusableViewDelegate {
    func didTapOnReusableView()
}

class OverscreenReusableView: UIView {
    var delegate: ReusableViewDelegate?
    var bottomLabel = UILabel()
    var item: String = ""
    var restart = ""
    var button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, imageName: String, bottomText: String, resetButton: Bool) {
        super.init(frame: frame)
        createbackground()
        createBottomLabel(with: bottomText)
        createImage(named: imageName)
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
        let image = UIImageView()
        image.image = UIImage(named: named)
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .clear
        item = named
        addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor),
            image.bottomAnchor.constraint(equalTo: bottomLabel.topAnchor)
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
    
    private func configureTapGestures() {
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnReusableView))
        addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapOnReusableView(_ gestureRecognizer: UIGestureRecognizer) {
        delegate?.didTapOnReusableView()
    }
}
