//
//  HomeTableViewCell.swift
//  Diary
//
//  Created by 한상민 on 2022/08/24.
//

import UIKit

class HomeTableViewCell: BaseTableViewCell {
    let diaryImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16, weight: .bold)
        view.textColor = .black
        return view
    }()
    
    let dateLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        view.textColor = .black
        return view
    }()
    
    let favoriteButton: UIButton = {
        let view = UIButton()
        view.tintColor = .black
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, dateLabel])
        view.axis = .vertical
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
        [diaryImageView, stackView, favoriteButton].forEach {
            contentView.addSubview($0)
        }
    }
   
    override func setConstraints() {
        diaryImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(20)
            make.width.height.equalTo(45)
            make.centerY.equalTo(contentView)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).offset(-20)
        }
        
//        stackView.alignment = .fill
//        stackView.distribution = .fill
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView)
            make.leading.equalTo(contentView).offset(72)
            make.trailing.equalTo(favoriteButton.snp.leading)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(5)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(5)
        }
    }
}
