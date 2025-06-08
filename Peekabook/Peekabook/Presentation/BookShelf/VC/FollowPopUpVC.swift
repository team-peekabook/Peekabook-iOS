import UIKit

import SnapKit
import Moya

final class FollowPopUpVC: UIViewController {
    
    // MARK: - Properties
    
    var friendId: Int
    
    // MARK: - UI Components
    
    private lazy var followPopUpView = CustomPopUpView(frame: .zero, style: .follow, viewController: self)
    
    // MARK: - Initialization
    
    init(friendId: Int) {
        self.friendId = friendId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    }
    
    private func setLayout() {
        view.addSubview(followPopUpView)
        
        followPopUpView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(295)
            $0.height.equalTo(156)
        }
    }
}

// MARK: - Methods

extension FollowPopUpVC {
    func setData(nickName: String) {
        followPopUpView.getConfirmLabel(style: .follow, personName: nickName)
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
