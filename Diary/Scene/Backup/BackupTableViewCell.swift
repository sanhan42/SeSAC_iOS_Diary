//
//  BackupTableViewCell.swift
//  Diary
//
//  Created by 한상민 on 2022/08/25.
//

import UIKit

class BackupTableViewCell: BaseTableViewCell {
    let label: UILabel = {
        let view = UILabel()
        view.textColor = .black
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        contentView.addSubview(label)
    }
    
    override func setConstraints() {
        label.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView)
            make.leading.equalTo(contentView).offset(12)
            make.trailing.equalTo(contentView).offset(-12)
        }
    }
}
