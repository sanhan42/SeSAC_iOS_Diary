//
//  HomeViewController.swift
//  Diary
//
//  Created by 한상민 on 2022/08/24.
//

import UIKit
import SnapKit
import RealmSwift
import FSCalendar

class HomeViewController: BaseViewController {
    let repository = UserDiaryRepository()
    
    lazy var calendar: FSCalendar = {
        let view = FSCalendar()
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .white
        return view
    }()
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyMMdd"
        return formatter
    }()
    
    let tableView: UITableView = {
        let view = UITableView()
//        view.delegate = self // 초기화 전에는 아직 self를 사용 불가능. self는 초기화된 인스턴스를 가르킴.
        // tableview를 let이 아닌 lazy var로 선언하면 가능.
        view.rowHeight = 50
        view.backgroundColor = .systemGray6
        return view
    }() // 즉시 실행 클로저
    
    var tasks: Results<UserDiary>! {
        didSet {
            tableView.reloadData()
        }
    }
    
    var isClickedSort = false {
        didSet {
            setLeftBarButtons()
            fetchRealm()
        }
    }
    
    var isClickedFilter = false {
        didSet {
            setLeftBarButtons()
            fetchRealm()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 16)!]
        configure()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLeftBarButtons()
        fetchRealm()
//        tasks = repository.localRealm.objects(UserDiary.self).sorted(byKeyPath: "diaryDate", ascending: false) // 호출 시점만 맞다면, 생략해도 잘 작동..
//        tableView.reloadData() // => didSet 으로 처리...
        // 화면 갱신은 화면 전환 코드 및 생명 주기 실행 점검 필요!!
        // present, overCuttentContext, overFullScreen > viewWillAppear 호출X
    }
    
    func fetchRealm() {
        tasks = repository.fetch(isClickedSort: isClickedSort, isClickedFilter: isClickedFilter)
    }
    
    func setLeftBarButtons() {
        let sortBtnTitle = isClickedSort ? "날짜순" : "이름순"
        let filterBtnTitle = isClickedFilter ? "모두보기" : "즐겨찾기"
        let sortButton = UIBarButtonItem(title: sortBtnTitle, style: .plain, target: self, action: #selector(sortButtonClicked))
        let filterButton = UIBarButtonItem(title: filterBtnTitle, style: .plain, target: self, action: #selector(filterButtonClicked))
        navigationItem.leftBarButtonItems = [sortButton, filterButton]
    }
    
    func setRightBarButtons() {
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonClicked))
        let backupButton = UIBarButtonItem(title: "백업", style: .plain, target: self, action: #selector(backupButtonClicked))
        navigationItem.rightBarButtonItems = [plusButton, backupButton]
    }
   
    override func configure() {
        view.addSubview(tableView)
        view.addSubview(calendar)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "cell")
        setRightBarButtons()
    }
    
    func setConstraints() {
        calendar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(300)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom)
            make.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
//            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func sortButtonClicked() {
        isClickedSort = !isClickedSort
    }
    
    // realm filter query 사용하기 || NSPredicate 사용하기
    @objc func filterButtonClicked() {
//        tasks = repository.localRealm.objects(UserDiary.self).filter("diaryTitle = '오늘의 수업'")
//        tasks = repository.localRealm.objects(UserDiary.self).filter("diaryTitle CONTAINS[c] '일기'") // [c] 대소문자 관계없이 찾아줄 떄 사용
        isClickedFilter = !isClickedFilter
    }
    
    @objc func backupButtonClicked() {
        let vc = BackupViewController()
        self.transition(vc, transitionStyle: .present)
    }
    
    @objc func plusButtonClicked() {
        let vc = WriteViewController()
        transition(vc, transitionStyle: .presentFullNavigation)
        // overFullScreen은 viewWillApper가 실행되지 않음.
        
//        present(vc, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    @objc func favoriteButtonClicked(btn: UIButton) {
        do {
            try repository.localRealm.write({
                tasks[btn.tag].favorite = !tasks[btn.tag].favorite
                fetchRealm()
            })
        } catch {
            print("Fail!")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? HomeTableViewCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = tasks[indexPath.row].diaryTitle
        cell.dateLabel.text = tasks[indexPath.row].diaryDate.toString()
        let image = tasks[indexPath.row].favorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        cell.favoriteButton.setImage(image, for: .normal)
        cell.favoriteButton.tag = indexPath.row
        cell.favoriteButton.addTarget(self, action: #selector(favoriteButtonClicked(btn:)), for: .touchUpInside)
        cell.diaryImageView.image = loadImageFromDocument(fileName: "\(tasks[indexPath.row].objectId).jpg")
        cell.diaryImageView.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "삭제") { action, view, completionHandler in
            print("delete Button Clicked")
            
            self.repository.deleteItem(item: self.tasks[indexPath.row])
            self.fetchRealm()
        }
        
//        let example = UIContextualAction(style: .normal, title: "예시") { action, view, completionHandler in
//            print("example Button Clicked")
//        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView,  trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favorite = UIContextualAction(style: .normal, title: "즐겨찾기") { action, view, completionHandler in
            print("favorite Button Clicked")
            
            self.repository.updateFavorite(item: self.tasks[indexPath.row])
            self.fetchRealm()
//            try! self.repository.localRealm.write({
//            // 하나의 레코드에서 특정 컬럼 하나만 변경
//                self.tasks[indexPath.row].favorite = !self.tasks[indexPath.row].favorite
//                self.fetchRealm() // didSet 설정을 해뒀기에 reload 되어짐. 이것 대신에 스와이프한 셀 하나만 ReloadRows 코드를 구현해줘도 된다. (보다 효율적)
//            })
            
            /*
            // 하나의 테이블에서 특정 컬럼 전체 변경
            self.tasks.setValue(true, forKey: "favorite")
            
            // 하나의 레코드에서 여러 컬럼 변경
            self.repository.localRealm.create(UserDiary.self, value: ["objectId": self.tasks[indexPath.row].objectId, "diaryContent": "변경 테스트", "diaryTitle": "제목임"], update: .modified)
             */
        }
        favorite.backgroundColor = .systemCyan
        
//        let example = UIContextualAction(style: .normal, title: "예시") { action, view, completionHandler in
//            print("example Button Clicked")
//        }
        
        return UISwipeActionsConfiguration(actions: [favorite])
    }
}

extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 10
    }
    
//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//        return "title"
//    }
//
//    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
//        return UIImage(systemName: "star.fill")
//    }
//
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        return formatter.string(from: date) == "220907" ? "오프라인 모임" : nil
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        tasks = repository.fetchDate(isClickedSort: isClickedSort, isClickedFilter: isClickedFilter, date: date)
    }
}
