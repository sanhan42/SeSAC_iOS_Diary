//
//  RealmModel.swift
//  Diary
//
//  Created by 한상민 on 2022/08/24.
//

import Foundation
import RealmSwift

// UserDiarty : 테이블 이름
// @Persisted ~ : Column
class UserDiary: Object {
    @Persisted var diaryTitle: String // 제목(필수)
    @Persisted var diaryContent: String? // 내용 (옵션)
    @Persisted var diaryDate = Date() // 작성 날짜 (필수)
    @Persisted var registrationDate = Date() // 등록 날짜 (필수)
    @Persisted var favorite: Bool // 즐겨찾기 (필수)
    @Persisted var photo: String? // 사진 (옵션)
    
    // PK (필수) : 보통 Int, UUID, ObjectID를 사용
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    
    convenience init(diaryTitle: String, diaryContent: String?, diaryDate: Date, registrationDate: Date, photo: String?) {
           self.init()
        self.diaryTitle = diaryTitle
        self.diaryContent = diaryContent
        self.diaryDate = diaryDate
        self.registrationDate = registrationDate
        self.favorite = false
        self.photo = photo
    }
}
