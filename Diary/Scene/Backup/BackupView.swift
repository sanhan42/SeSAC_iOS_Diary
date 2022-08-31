//
//  BackupView.swift
//  Diary
//
//  Created by 한상민 on 2022/08/25.
//

import UIKit

final class BackupView: BaseView {
    let BackupButton: UIButton = {
        let view = UIButton()
        view.setTitle("백업", for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 22, weight: .black)
        return view
    }()
    
    let restorationButton: UIButton = {
        let view = UIButton()
        view.setTitle("복구", for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 22, weight: .black)
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [BackupButton, restorationButton])
        view.distribution = .fillEqually
        return view
    }()
    
    let tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .systemGray6
        view.rowHeight = 44
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [stackView, tableView].forEach {
            self.addSubview($0)
        }
        tableView.register(BackupTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalTo(35)
            make.trailing.equalTo(-35)
            make.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom)
            make.leading.equalTo(35)
            make.trailing.equalTo(-35)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
