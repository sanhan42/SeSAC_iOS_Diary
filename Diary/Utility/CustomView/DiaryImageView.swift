//
//  DiaryImageView.swift
//  Diary
//
//  Created by 한상민 on 2022/08/24.
//

import UIKit

class DiaryImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupView() {
        contentMode = .scaleAspectFill
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }

}
