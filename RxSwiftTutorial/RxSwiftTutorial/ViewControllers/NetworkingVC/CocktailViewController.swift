//
//  CocktailViewController.swift
//  RxSwiftTutorial
//
//  Created by NhanHoo23 on 11/05/2023.
//

import MTSDK
import RxCocoa
import RxSwift

//MARK: -Init and Variables
class CocktailViewController: UIViewController {

    //Variables-Layout
    private let tableView = UITableView()
    
    //Variables-Properties
    private let bag = DisposeBag()
    private let categories = BehaviorRelay<[CocktailCategory]>(value: [])
}

//MARK: -Lifecycle
extension CocktailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        categories
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            })
            .disposed(by: bag)
        
        loadAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

//    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
}

//MARK: -SetupView
extension CocktailViewController {
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        title = "Cocktail"
        
        tableView >>> view >>> {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            $0.dataSource = self
            $0.delegate = self
            $0.registerReusedCell(CocktailTableViewCell.self)
            $0.backgroundColor = .clear
            $0.separatorStyle = .none
        }

    }

}

//MARK: -Functions
extension CocktailViewController {
    private func loadAPI() {
        let newCategories = Networking.shared.getCategory(kind: "c")
        
        let downloadItems = newCategories
            .flatMap {categories in
                //sử dụng toán tử from vì cần arr truyền vào
                return Observable.from(categories.map { category in
                    Networking.shared.getDrinks(kind: "c", value: category.strCategory)
                })
            }
            .merge(maxConcurrent: 2) //gộp các Observable con và chỉ cho tối đa chạy trên 2 luồng
        
        let updateCategories = newCategories.flatMap { categories in
            downloadItems
                .enumerated() // kiểu dử liệu của downloadItems update thành (index: Int, drinks: [Drink])
                .scan([]) {(updated, element: (index: Int, drinks: [Drink])) -> [CocktailCategory] in
                    var new: [CocktailCategory] = updated
                    new.append(CocktailCategory(strCategory: categories[element.index].strCategory, items: element.drinks))
                    
                    return new
                }
        }
        
        updateCategories
            .bind(to: categories)
            .disposed(by: bag)
    }
}

//MARK: -Delegate
extension CocktailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(cellClass: CocktailTableViewCell.self, indexPath: indexPath)
        cell.configsCell()
        let item = categories.value[indexPath.row]
        cell.textLabel?.text = "\(item.strCategory) - \(item.items.count) items"
        
        return cell 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = categories.value[indexPath.row]
        print("⭐️ \(item.strCategory) - \(item.items.count) items")
        
        let vc = DrinksViewController()
        vc.categoryName = item.strCategory
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

