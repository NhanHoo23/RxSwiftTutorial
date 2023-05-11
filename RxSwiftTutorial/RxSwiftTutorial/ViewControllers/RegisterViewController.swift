//
//  RegisterViewController.swift
//  RxSwiftTutorial
//
//  Created by NhanHoo23 on 05/05/2023.
//

import MTSDK
import RxSwift
import RxCocoa

//MARK: Init and Variables
class RegisterViewController: UIViewController {

    //Outlet
    let avatarImgView = UIImageView()
    let userNameTF = MTTextfield()
    let passwordTF = MTTextfield()
    let emailTF = MTTextfield()
    let registerBt = UIButton()
    let clearBt = UIButton()
    
    //Properties
    var avatarIndex = 0
    let disposeBag = DisposeBag()
    let image = BehaviorRelay<UIImage?>(value: nil)
}

//MARK: Lifecycle
extension RegisterViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        subcription()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

}

//MARK: SetupView
extension RegisterViewController {
    private func setupView() {
        view.backgroundColor = .systemBackground
        title = "Register"
        
        let rightBt = UIBarButtonItem(title: "Change Ava", style: .plain, target: self, action: #selector(changeAva))
        navigationItem.rightBarButtonItem = rightBt
        
        let scrollView = UIScrollView()
        scrollView >>> view >>> {
            $0.snp.makeConstraints {
                $0.top.equalTo(topSafe)
                $0.leading.trailing.bottom.equalToSuperview()
            }
            $0.isScrollEnabled = true
            $0.showsVerticalScrollIndicator = false
            $0.alwaysBounceVertical = true
        }
        
        let contentView = UIView()
        contentView >>> scrollView >>> {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.width.equalToSuperview()
            }
        }
        
        avatarImgView >>> contentView >>> {
            $0.snp.makeConstraints {
                $0.top.equalToSuperview().offset(16)
                $0.centerX.equalToSuperview()
                $0.width.height.equalTo(maxWidth / 3)
            }
            $0.layer.cornerRadius = (maxWidth / 3) / 2
            $0.layer.borderColor = UIColor.gray.cgColor
            $0.layer.borderWidth = 2
            $0.image = UIImage(named: "avatar_1")
            $0.layer.masksToBounds = true
        }
        
        let fieldView = UIView()
        fieldView >>> contentView >>> {
            $0.snp.makeConstraints {
                $0.top.equalTo(avatarImgView.snp.bottom).offset(24)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(maxWidth * 0.9)
                $0.height.equalTo(50 * 3 + 4 * 2)
            }
            $0.layer.cornerRadius = 15
            $0.layer.masksToBounds = true
        }
        
        userNameTF >>> fieldView >>> {
            $0.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.height.equalTo(50)
            }
            $0.layer.borderColor = UIColor.gray.cgColor
            $0.layer.borderWidth = 1
            $0.placeholder = "User Name"
        }

        passwordTF >>> fieldView >>> {
            $0.snp.makeConstraints {
                $0.top.equalTo(userNameTF.snp.bottom).offset(4)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(50)
            }
            $0.layer.borderColor = UIColor.gray.cgColor
            $0.layer.borderWidth = 1
            $0.placeholder = "Password"
        }

        emailTF >>> fieldView >>> {
            $0.snp.makeConstraints {
                $0.top.equalTo(passwordTF.snp.bottom).offset(4)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(50)
            }
            $0.layer.borderColor = UIColor.gray.cgColor
            $0.layer.borderWidth = 1
            $0.placeholder = "Email"
        }
        
        registerBt >>> contentView >>> {
            $0.snp.makeConstraints {
                $0.leading.equalTo(fieldView.snp.leading)
                $0.trailing.equalTo(fieldView.snp.trailing)
                $0.top.equalTo(fieldView.snp.bottom).offset(16)
                $0.height.equalTo(50)
            }
            $0.setTitle("Register", for: .normal)
            $0.backgroundColor = .green
            $0.handle {
                self.register()
            }
        }
        
        clearBt >>> contentView >>> {
            $0.snp.makeConstraints {
                $0.leading.equalTo(fieldView.snp.leading)
                $0.trailing.equalTo(fieldView.snp.trailing)
                $0.top.equalTo(registerBt.snp.bottom).offset(16)
                $0.height.equalTo(50)
                $0.bottom.equalToSuperview()
            }
            $0.setTitle("Clear", for: .normal)
            $0.backgroundColor = .red
        }
    }
}


//MARK: Functions
extension RegisterViewController {
    @objc func changeAva() {
        let avaVC = AvatarViewController()
        navigationController?.pushViewController(avaVC, animated: true)
        
        avaVC.selectedPhoto
            .subscribe(onNext: {img in
                self.image.accept(img)
            }, onDisposed: {
                print("changed avatar")
            })
            .disposed(by: disposeBag)
    }
    
    func subcription() {
        image.asObservable()
            .subscribe(onNext: {img in
                self.avatarImgView.image = img
            })
            .disposed(by: disposeBag)
    }
    
    func register() {
//        RegisterModel.shared().register(username: userNameTF.text,
//                                        password: passwordTF.text,
//                                        email: emailTF.text,
//                                        avatar: avatarImgView.image)
//        .subscribe(onNext: {done in
//            print("Register successfully")
//        }, onError: { error in
//            if let myError = error as? APIError {
//                print("Register with error: \(myError.localizedDescription)")
//            }
//        }, onCompleted: {
//            print("Register completed")
//        })
//        .disposed(by: disposeBag)
        
        RegisterModel.shared().register2(username: userNameTF.text,
                                        password: passwordTF.text,
                                        email: emailTF.text,
                                        avatar: avatarImgView.image)
        .asObservable()
        .subscribe(onNext: {done in
            print("Register successfully")
        }, onError: { error in
            if let myError = error as? APIError {
                print("Register with error: \(myError.localizedDescription)")
            }
        }, onCompleted: {
            print("Register completed")
        })
        .disposed(by: disposeBag)
    }
    
    func clear() {
        
    }
}
