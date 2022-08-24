//
//  ImageSearchViewController.swift
//  Diary
//
//  Created by 한상민 on 2022/08/24.
//

import UIKit
import Kingfisher

class SearchImageViewController: BaseViewController {
    
    var delegate: SelectImageDelegate?
    var selectImage: UIImage?
    var selectIndexPath: IndexPath?

    let mainView = ImageSearchView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @objc func selectButtonClicked() {
        guard let image = selectImage else {
            showAlertMessage(title: "사진을 선택해주세요", button: "확인")
            return
        }
        delegate?.sendImageData(image: image)
        dismiss(animated: true)
    }
    
    @objc func cancelButtonClicked() {
        dismiss(animated: true)
    }
    
    override func configure() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(ImageSearchCollectionViewCell.self, forCellWithReuseIdentifier: ImageSearchCollectionViewCell.reuseIdentifier)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(selectButtonClicked))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(cancelButtonClicked))
    }
}
 
extension SearchImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImageDummy.data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageSearchCollectionViewCell.reuseIdentifier, for: indexPath) as? ImageSearchCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.layer.borderWidth = selectIndexPath == indexPath ? 4 : 0
        cell.layer.borderColor = UIColor.red.cgColor
        cell.setImage(data: ImageDummy.data[indexPath.item].url)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImageSearchCollectionViewCell else { return }
        selectImage = cell.searchImageView.image
        selectIndexPath = indexPath
        collectionView.reloadData()
    }
   
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print(#function) // 호출 시점 검색해보기
        selectImage = nil
        selectIndexPath = nil
        collectionView.reloadData()
    }
}
