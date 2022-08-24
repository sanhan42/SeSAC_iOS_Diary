//
//  FileManager+Extension.swift
//  Diary
//
//  Created by 한상민 on 2022/08/24.
//

import UIKit

extension UIViewController {
    func saveImageToDocument(fileName: String, image: UIImage) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return } // Document 경로
        let fileURL = documentDirectory.appendingPathComponent(fileName) // 세부경로. 이미지를 저장할 위치
        guard let data = image.jpegData(compressionQuality: 0.5) else { return } // 이미지 용량을 줄이기 위함
        
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("file save error", error)
        }
    }
    
    func loadImageFromDocument(fileName: String) -> UIImage? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil } // Document 경로
        let fileURL = documentDirectory.appendingPathComponent(fileName) // 세부경로. 이미지를 저장할 위치
        let image = UIImage(contentsOfFile: fileURL.path)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return image
        } else {
            return UIImage(named: "noimg")
        }
    }
    
    func removeImageFromDocument(fileName: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch let error {
            print(error)
        }
    }
}
