//
//  UserDiaryRepository.swift
//  Diary
//
//  Created by 한상민 on 2022/08/26.
//

import UIKit
import RealmSwift

protocol UserDiaryRepositoryType {
    func fetch(isClickedSort: Bool, isClickedFilter: Bool) -> Results<UserDiary>!
    func fetchDate(isClickedSort: Bool, isClickedFilter: Bool, date:Date) -> Results<UserDiary>!
    func updateFavorite(item: UserDiary)
    func deleteItem(item: UserDiary)
    func addItem(item: UserDiary)
    
}

struct UserDiaryRepositoty: UserDiaryRepositoryType {
    func fetchDate(isClickedSort: Bool, isClickedFilter: Bool, date:Date) -> Results<UserDiary>! {
        let key = isClickedSort ? "diaryTitle" : "diaryDate"
        let tempTasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: key, ascending: true).filter("diaryDate >= %@ AND diaryDate < %@", date, Date(timeInterval: 86400, since: date)) // NSPredicate
        return isClickedFilter ? tempTasks.filter("favorite = true") : tempTasks
    }
    
    func addItem(item: UserDiary) {
        
    }
    
    let localRealm = try! Realm()
    //cf.구조체, 싱글턴 찾아보기 -> 구조체. 이미 한 곳을 바라보기에, 굳이 싱글턴을 사용할 필요X...
    
    func fetch(isClickedSort: Bool, isClickedFilter: Bool) -> Results<UserDiary>! {
        // Realm 데이터를 정렬해 tasks에 담기.
        let key = isClickedSort ? "diaryTitle" : "diaryDate"
        let tempTasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: key, ascending: true)
        return isClickedFilter ? tempTasks.filter("favorite = true") : tempTasks
    }
    
    private func removeImageFromDocument(fileName: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch let error {
            print(error)
        }
    }
    
    func deleteItem(item: UserDiary) {
        try! localRealm.write({
            removeImageFromDocument(fileName: "\(item.objectId).jpg")
            localRealm.delete(item)
        })
    }
    
    func updateFavorite(item: UserDiary){
        item.favorite.toggle()
    }
}
