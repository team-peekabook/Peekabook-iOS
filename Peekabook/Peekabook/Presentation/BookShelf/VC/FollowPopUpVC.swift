import UIKit

import SnapKit
import Then

import Moya

final class FollowPopUpVC: UIViewController {
    
    // MARK: - Properties
    
    var friendId: Int = 0

    // MARK: - UI Components
    
    private lazy var followPopUpVC = CustomPopUpView(frame: .zero, style: .report, viewController: self)

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - UI & Layout
extension FollowPopUpVC {

    private func setUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
        followPopUpVC.backgroundColor = .peekaBeige
        followPopUpVC.getConfirmLabel(style: .report)
    }
    
    private func setLayout() {
        view.addSubview(followPopUpVC)
        
        followPopUpVC.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(295)
            $0.height.equalTo(136)
        }
    }
}

// MARK: - Methods

extension FollowPopUpVC {
    @objc func confirmButtonDidTap() {
        postFollowAPI(friendId: friendId)
    }
}

// MARK: - Network

extension FollowPopUpVC {
    private func postFollowAPI(friendId: Int) {
        FriendAPI(viewController: self).postFollowing(id: friendId) { response in
            if response?.success == true {
                self.switchRootViewController(rootViewController: TabBarController(), animated: true, completion: nil)
            }
        }
    }
}
