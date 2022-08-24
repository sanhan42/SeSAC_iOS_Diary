//
//  WriteView.swift
//  Diary
//
//  Created by 한상민 on 2022/08/22.
//

import UIKit

import UIKit

class WriteView: BaseView {
   
    let userImageView: DiaryImageView = {
        let view = DiaryImageView(frame: .zero)
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    let titleTextField: WriteTextField = {
        let view = WriteTextField()
        view.placeholder = "제목을 입력해주세요"
        return view
    }()
    
    let dateTextField: WriteTextField = {
        let view = WriteTextField()
        view.placeholder = "날짜를 입력해주세요(yyyy.MM.dd)"
        return view
    }()
    
    let contentTextView: UITextView = {
        let view = UITextView()
        view.font = .systemFont(ofSize: 14)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.darkGray.cgColor
        return view
    }()
    
    let searchImageButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "photo"), for: .normal)
        view.tintColor = .black
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        return view
    }()
    
//    let saveButton: UIButton = {
//        let view = UIButton()
//        view.backgroundColor = .magenta
//        return view
//    }()
//
//    let cancelButton: UIButton = {
//        let view = UIButton()
//        view.backgroundColor = .cyan
//        return view
//    }()
    
    
    // MARK: - Methods
    override func configureUI() {
        [userImageView, titleTextField, dateTextField, contentTextView, searchImageButton].forEach {
            self.addSubview($0)
        }
    }
     
    override func setConstraints() {
        userImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(12)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(self.snp.width).multipliedBy(0.75)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp.bottom).offset(12)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(55)
        }
        
        dateTextField.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(12)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(55)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(dateTextField.snp.bottom).offset(12)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-12)
        }
        
        searchImageButton.snp.makeConstraints { make in
            make.trailing.equalTo(userImageView.snp.trailing).offset(-12)
            make.bottom.equalTo(userImageView.snp.bottom).offset(-12)
            make.width.height.equalTo(50)
        }
        
//        saveButton.snp.makeConstraints { make in
//            make.width.height.equalTo(30)
//            make.trailing.top.equalTo(self.safeAreaLayoutGuide)
//            make.trailing.equalTo(self).offset(-20)
//        }
//
//        cancelButton.snp.makeConstraints { make in
//            make.width.height.equalTo(30)
//            make.leading.top.equalTo(self.safeAreaLayoutGuide)
//            make.leading.equalTo(self).offset(20)
//        }
    }

}
