//
//  ReportTVC.swift
//  Peekabook
//
//  Created by 고두영 on 2023/03/21.
//

import UIKit
import SnapKit
import Then

final class ReportTVC: UITableViewCell {
    
    private let titleLabel = UILabel().then {
        $0.font = .h2
        $0.textColor = .black
    }
    
    func setLabel(with text: String) {
        titleLabel.text = text
    }
    
    private lazy var radioButton = UIButton().then {
        $0.setImage(ImageLiterals.Icn.radio_uncheck, for: .normal)
        $0.setImage(ImageLiterals.Icn.radio_check, for: .selected)
        $0.addTarget(self, action: #selector(radioButtonDidtap), for: .touchUpInside)
    }

    private let underLineView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: ReportTVC.className)
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ReportTVC {
    private func setBackgroundColor() {
        backgroundColor = .peekaBeige
        underLineView.backgroundColor = .peekaGray1
    }

    private func setLayout() {
        contentView.addSubviews(titleLabel, radioButton, underLineView)

        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }

        radioButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }

        underLineView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(0.5)
        }
    }
    
    @objc private func radioButtonDidtap(_ sender: UIButton) {
        guard let tableView = superview as? UITableView,
              let indexPath = tableView.indexPath(for: self) else {
            return
        }
        for cell in tableView.visibleCells {
            if let cell = cell as? ReportTVC, cell !== self {
                cell.radioButton.isSelected = false
            }
        }
        sender.isSelected = true
        tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }
}
