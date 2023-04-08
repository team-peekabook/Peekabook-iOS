//
//  OnboardingCVC.swift
//  Peekabook
//
//  Created by devxsby on 2023/04/07.
//

import UIKit

final class OnboardingCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.masksToBounds = true
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .h2
        label.textColor = .peekaRed
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension OnboardingCVC {
    
    private func setUI() {
        self.backgroundColor = .clear
    }
    
    private func setLayout() {
        addSubviews(imageView, titleLabel)
        
        imageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.width.equalTo(240.adjusted)
            $0.height.equalTo(500.adjustedH)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20.adjustedH)
            $0.centerX.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension OnboardingCVC {

    func setOnboardingSlides(_ slides: OnboardingDataModel) {
        imageView.image = slides.image
        titleLabel.text = slides.title
    }
}

struct OnboardingDataModel {
    var image: UIImage
    var title: String
    
    public init(image: UIImage, title: String) {
        self.image = image
        self.title = title
    }
}
