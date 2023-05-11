//
//  CocktailViewController.swift
//  RxSwiftTutorial
//
//  Created by NhanHoo23 on 11/05/2023.
//

import MTSDK

//MARK: -Init and Variables
class CocktailViewController: UIViewController {

    //Variables-Layout
    
    //Variables-Properties
    
}

//MARK: -Lifecycle
extension CocktailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

//    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
}

//MARK: -SetupView
extension CocktailViewController {
    private func setupView() {
        view.backgroundColor = .systemBackground
    }

}

//MARK: -Functions
extension CocktailViewController {

}

