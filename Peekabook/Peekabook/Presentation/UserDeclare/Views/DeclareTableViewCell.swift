//
//  DeclareTableViewCell.swift
//  Peekabook
//
//  Created by 고두영 on 2023/03/21.
//

import UIKit
import SnapKit
import Then

final class DeclareTableViewCell: UITableViewCell {
    
    var label = UILabel().then {
        $0.font = .h2
        $0.textColor = .black
    }
    
    lazy var radioButton = UIButton().then {
        $0.setImage(ImageLiterals.Icn.uncheckedButton, for: .normal)
        $0.setImage(ImageLiterals.Icn.checkedButton, for: .selected)
        $0.addTarget(self, action: #selector(radioButtonDidtap(_:)), for: .touchUpInside)
    }

    private let underLineView = UIView()

    var radioButtonAction: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: DeclareTableViewCell.className)
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func radioButtonDidtap(_ sender: UIButton) {
        guard let tableView = superview as? UITableView,
              let indexPath = tableView.indexPath(for: self) else {
            return
        }
        for cell in tableView.visibleCells {
            if let cell = cell as? DeclareTableViewCell, cell !== self {
                cell.radioButton.isSelected = false
            }
        }
        sender.isSelected = true
        tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }
}

extension DeclareTableViewCell {

    private func setLayout() {
        underLineView.backgroundColor = .peekaGray1
        backgroundColor = .peekaBeige
        contentView.addSubviews(label, radioButton, underLineView)

        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }

        radioButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
        }

        underLineView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(0.5)
        }
    }
}
