//
//  AvatarViewController.swift
//  RxSwiftTutorial
//
//  Created by NhanHoo23 on 09/05/2023.
//

import MTSDK
import RxSwift
import RxCocoa

//MARK: Init and Variables
class AvatarViewController: UIViewController {

    //Variables
    private var collectionView: UICollectionView!
    
    private let avaCollection: [String] = ["avatar_1", "avatar_2", "avatar_3", "avatar_4", "avatar_5", "avatar_6", "avatar_7", "avatar_8", "avatar_9", "avatar_10", "avatar_11", "avatar_12"]
    private let disposeBag = DisposeBag()
    private let selectedPhotoSubject = PublishSubject<UIImage>() //Vì sao phải dùng publishSubject: vì nó không cần thiết phải khởi tạo giá trị ban đầu cho nó, lúc hiển thị thì người dùng chưa có lựa chọn nào hết
    var selectedPhoto: Observable<UIImage> { //tạo thằng này để bên ngoài có thể subcribe tới
        return selectedPhotoSubject.asObserver() //return có nghĩa là khi truy cập tới selectedPhoto, thì nó sẽ nhận được giá trị được trả về từ thằng SelectPhotoSubject (nó là get đó bro)
    }
    private var selectedIndex = -1
    
}

//MARK: Lifecycle
extension AvatarViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        selectedPhotoSubject.onCompleted()
    }

}

//MARK: SetupView
extension AvatarViewController {
    private func setupView() {
        view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView >>> view >>> {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            $0.registerReusedCell(AvatarCollectionViewCell.self)
            $0.dataSource = self
            $0.delegate = self
            $0.backgroundColor = .clear
        }

    
    }
}


//MARK: Functions
extension AvatarViewController {

}

extension AvatarViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avaCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusable(cellClass: AvatarCollectionViewCell.self, indexPath: indexPath)
        cell.configsCell(image: avaCollection[indexPath.item], isSelected: selectedIndex == indexPath.item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = 16.0
        let items = 3.0
        
        let width = (maxWidth - padding * (items + 1)) / items
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        collectionView.reloadData()
        
        //emit UIimage
        if let image = UIImage(named: "avatar_\(indexPath.item + 1)") {
            selectedPhotoSubject.onNext(image) //emit dữ liệu 
        }
    }
}
