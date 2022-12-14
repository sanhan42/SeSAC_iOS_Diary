//
//  Transition+Extension.swift
//  Diary
//
//  Created by 한상민 on 2022/08/24.
//

import UIKit

extension UIViewController {
    
    enum TransitionStyle {
        case present // 네비게이션 없이 Present]
        case presentNavigation // 네비게이션 임베드 Present
        case presentFullNavigation // 네비게이션 풀스크린
        case push
    }
    
    func transition<T: UIViewController>(_ viewController: T, transitionStyle: TransitionStyle = .present) {
        switch transitionStyle {
        case .present:
            self.present(viewController, animated: true)
        case .push:
            self.navigationController?.pushViewController(viewController, animated: true)
        case .presentNavigation:
            let navi = UINavigationController(rootViewController: viewController)
            navi.navigationBar.tintColor = .white
            navi.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 16)!]
            self.present(navi, animated: true)
        case .presentFullNavigation:
            let navi = UINavigationController(rootViewController: viewController)
            navi.navigationBar.tintColor = .white
            navi.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 16)!]
            navi.modalPresentationStyle = .fullScreen
            self.present(navi, animated: true)
        }
    }
    
}
