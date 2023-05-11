//
//  FetchingTableViewCell.swift
//  RxSwiftTutorial
//
//  Created by NhanHoo23 on 11/05/2023.
//

import MTSDK

class FetchingTableViewCell: UITableViewCell {
    
    
    //Variables
    var containerView: UIView!
    
}


//MARK: Functions
extension FetchingTableViewCell {
    func configsCell() {
        if containerView == nil {
            self.setupView()
        }
    }
    
    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        containerView = UIView()
        containerView >>> contentView >>> {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            $0.backgroundColor = .clear
        }
        
    }

}
