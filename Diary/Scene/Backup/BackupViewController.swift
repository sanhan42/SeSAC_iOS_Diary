//
//  BackupViewController.swift
//  Diary
//
//  Created by 한상민 on 2022/08/25.
//

import UIKit

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
