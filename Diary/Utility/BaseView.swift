//
//  BaseView.swift
//  Diary
//
//  Created by 한상민 on 2022/08/24.
//

import UIKit
import SnapKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureUI() {
        self.backgroundColor = .white
    }
    
    func setConstraints() {}
}

