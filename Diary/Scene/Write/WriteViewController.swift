//
//  WriteViewController.swift
//  Diary
//
//  Created by 한상민 on 2022/08/24.
//

import UIKit
import RealmSwift // Realm 1.

protocol SelectImageDelegate {
    func sendImageData(image: UIImage)
}

class WriteViewController: BaseViewController {

    let mainView = WriteView()
    let localRealm = try! Realm() // Realm 2.
    // Realm 테이블에 데이터를 CRUD할 때, Realm 테이블 경로에 접근하기 위한 코드
    
    override func loadView() {
        self.view = mainView
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        print("Realm is located at:", localRealm.configuration.fileURL!)
    }
    
    override func configure() {
        mainView.searchImageButton.addTarget(self, action: #selector(selectImageButtonClicked), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(cancelButtonClicked))
//        mainView.saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
//        mainView.cancelButton.addTarget(self, action: <#T##Selector#>, for: .touchUpInside)
    }
      
    @objc func selectImageButtonClicked() {
        let vc = SearchImageViewController()
        vc.delegate = self
        transition(vc, transitionStyle: .presentFullNavigation)
    }
    
 
    
    @objc func saveButtonClicked() {
        
        guard let title = mainView.titleTextField.text, title != "" else {
            showAlertMessage(title: "제목을 입력해주세요", button: "확인")
            return
        }
        guard let date = mainView.dateTextField.text?.toDate(), title != "" else { return }
        
        // Add some tasks
        let task = UserDiary(diaryTitle: title, diaryContent: "일기 내용 테스트", diaryDate: date, registrationDate: Date() , photo: nil) // => Record
        do {
            try localRealm.write {
                localRealm.add(task) // Create - 생성한 Record를 추가
                print("Realm Succeed")
                if let image = mainView.userImageView.image {
                    saveImageToDocument(fileName: "\(task.objectId).jpg", image: image)
                }
                dismiss(animated: true)
            }
        } catch let error {
            print(error)
        }
        
    }
    
    @objc func cancelButtonClicked() {
        dismiss(animated: true)
    }
}

extension WriteViewController: SelectImageDelegate {
    func sendImageData(image: UIImage) {
        mainView.userImageView.image = image
        print(#function)
    }
}
