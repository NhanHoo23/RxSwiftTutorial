//
//  MainViewController.swift
//  RxSwiftTutorial
//
//  Created by NhanHoo23 on 11/05/2023.
//

import MTSDK

//MARK: Init and Variables
class MainViewController: UIViewController {

    //Variables
    private let tableView = UITableView()
    private let controllerNames: [String] = ["Register", "Fetching Data", "Networking Model", "RxCocoa"]
}

//MARK: Lifecycle
extension MainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

}

//MARK: SetupView
extension MainViewController {
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        title = "RxSwift Tutorial"
        
        tableView >>> view >>> {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            $0.registerReusedCell(MainTableViewCell.self)
            $0.dataSource = self
            $0.delegate = self
            $0.backgroundColor = .clear
        }

    }
}


//MARK: Delegate
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controllerNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(cellClass: MainTableViewCell.self, indexPath: indexPath)
        cell.configsCell()
        cell.textLabel?.text = controllerNames[indexPath.row]
        cell.textLabel?.textColor = .label
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = RegisterViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = FetchingViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = CocktailViewController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            let vc = RegisterViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
