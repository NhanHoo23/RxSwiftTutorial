//
//  DrinksViewController.swift
//  RxSwiftTutorial
//
//  Created by NhanHoo23 on 11/05/2023.
//

import MTSDK
import RxSwift
import RxCocoa

//MARK: -Init and Variables
class DrinksViewController: UIViewController {

    //Variables-Layout
    private let tableView = UITableView()
    
    //Variables-Properties
    private let bag = DisposeBag()
    private let drinks = BehaviorRelay<[Drink]>(value: [])
    var categoryName: String = ""
}

//MARK: -Lifecycle
extension DrinksViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        drinks
            .asObservable()
            .subscribe(onNext: {[weak self] drinks in
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.title = "\(self!.categoryName) (\(drinks.count))"
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
extension DrinksViewController {
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        title = categoryName
        
        tableView >>> view >>> {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            $0.dataSource = self
            $0.delegate = self
            $0.registerReusedCell(DrinkTableViewCell.self)
            $0.backgroundColor = .clear
            $0.separatorStyle = .none
        }
    }

}

//MARK: -Functions
extension DrinksViewController {
    func loadAPI() {
        Networking.shared.getDrinks(kind: "c", value: categoryName)
            .bind(to: drinks)
            .disposed(by: bag)
    }
}

//MARK:  Delegate
extension DrinksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinks.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(cellClass: DrinkTableViewCell.self, indexPath: indexPath)
        cell.configsCell()
        let item = drinks.value[indexPath.row]
        cell.textLabel?.text = item.strDrink
        
        return cell
    }
}


