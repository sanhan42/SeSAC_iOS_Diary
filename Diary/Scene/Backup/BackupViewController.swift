//
//  BackupViewController.swift
//  Diary
//
//  Created by 한상민 on 2022/08/25.
//

import UIKit
import Zip

class BackupViewController: BaseViewController {
    let mainView = BackupView()

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func configure() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.BackupButton.addTarget(self, action: #selector(backupButtonClicked), for: .touchUpInside)
        mainView.restorationButton.addTarget(self, action: #selector(restoreButtonClicked), for: .touchUpInside)
    }
    
    @objc func backupButtonClicked() {
        var urlPaths = [URL]()
//        1. 도큐먼트 위치에 백업 파일 확인
        guard let path = documentDirectoryPath() else {
            showAlertMessage(title: "도큐먼트 위치에 오류가 있습니다.")
            return
        } // 도큐먼트 파일 위치
        
        let realmFile = path.appendingPathComponent("default.realm") // realm 파일
        // realm 파일 설정시 파일명을 지정해주지 않았을 때, 기본 파일명 = default.realm
        
        guard FileManager.default.fileExists(atPath: realmFile.path) else {
            showAlertMessage(title: "백업할 파일이 없습니다.")
            return
        } // 백업할 realm 파일 확인
        
        urlPaths.append(realmFile)
        // urlPaths.append(URL(string: realmFile.path)!)
        
//        2. 백업 파일을 압축
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "SeSACDiary_1")
            print("Archive Location: \(zipFilePath)")
            showActiviryViewController() // 3. AcrivityViewController 띄우기
        } catch {
            showAlertMessage(title: "압축을 실패했습니다.")
        }
        

    }
    
    func showActiviryViewController() {
        guard let path = documentDirectoryPath() else {
            showAlertMessage(title: "도큐먼트 위치에 오류가 있습니다.")
            return
        }
        
        let backupFile = path.appendingPathComponent("SeSACDiary_1.zip")
        guard FileManager.default.fileExists(atPath: backupFile.path) else {
            showAlertMessage(title: "백업 압축 파일이 없습니다.")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [backupFile], applicationActivities: [])
        transition(vc)
    }
    
    @objc func restoreButtonClicked() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        transition(documentPicker)
    }
}

extension BackupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? BackupTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .white
        cell.label.text = "Temp\(Int.random(in: 1...100))"
        return cell
    }
}

extension BackupViewController: UIDocumentPickerDelegate {
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print(#function)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else {
            showAlertMessage(title: "선택하신 파일에 오류가 있습니다.")
            return
        } // 선택한 파일의 URL
        
        guard let path = documentDirectoryPath() else {
            showAlertMessage(title: "도큐먼트 위치에 오류가 있습니다.")
            return
        }
        
        let sandboxFileURL = path.appendingPathComponent(selectedFileURL.lastPathComponent) // '도큐먼트 위치'에 '파일이름.확장자'를 붙여줌
        
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            let fileURL = sandboxFileURL
            do {
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("PROGRESS : \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("UnzippedFile : \(unzippedFile)")
                    self.showAlertMessage(title: "복구가 완료되었습니다.")
                })
            } catch {
                showAlertMessage(title: "압축 해제에 실패했습니다.")
            }
        } else {
            do {
                // 파일 앱의 zip을 도큐먼트 폴더에 복사
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                
                let fileURL = sandboxFileURL
                
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("PROGRESS : \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("UnzippedFile : \(unzippedFile)")
                    let alert = UIAlertController(title: "복구가 완료되었습니다.", message: nil, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "확인", style: .default) {_ in
                        print("OK")
                        /// 윈도우의 루트뷰를 바꿔주는 작업이 필요하다. => 왜 안될까.... HomeViewController의 새 인스턴스를 생성해주니까, Realm() 이것도 새로 생성된게 아닌가..?
                        let vc = HomeViewController()
                        let navi = UINavigationController(rootViewController: vc)
                        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                        let sceneDelegate = windowScene?.delegate as? SceneDelegate
                        sceneDelegate?.window?.rootViewController = navi
                        sceneDelegate?.window?.makeKeyAndVisible()
                    }
                    alert.addAction(ok)
                    self.present(alert, animated: true)
                })
            } catch {
                showAlertMessage(title: "압축 해제에 실패했습니다.")
            }
        }
    }
}
