//
//  OnboardingCVC.swift
//  Peekabook
//
//  Created by devxsby on 2023/04/07.
//

import UIKit

final class OnboardingCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .peekaRed
        label.numberOfLines = 0
        label.font = .h2
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
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.85)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(18)
            $0.centerX.equalToSuperview()
        }
        
        checkSmallLayout()
    }
    
    private func checkSmallLayout() {
        if UIScreen.main.isSmallThan712pt {
            imageView.snp.remakeConstraints {
                $0.top.equalToSuperview().offset(10)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(240 * 0.85)
                $0.height.equalTo(500 * 0.85)
            }
        }
    }
}

// MARK: - Methods

extension OnboardingCVC {

    func setOnboardingSlides(_ slides: OnboardingDataModel) {
        imageView.image = slides.image
        titleLabel.text = slides.title
        titleLabel.setLineSpacing(lineSpacing: 2)
        titleLabel.textAlignment = .center
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
