//
//  AvatarCollectionViewCell.swift
//  RxSwiftTutorial
//
//  Created by NhanHoo23 on 09/05/2023.
//

import MTSDK

class AvatarCollectionViewCell: UICollectionViewCell {
    
    
    //Variables
    var containerView: UIView!
    let imageV = UIImageView()
}


//MARK: Functions
extension AvatarCollectionViewCell {
    func configsCell(image: String, isSelected: Bool) {
        if containerView == nil {
            self.setupView()
        }
        imageV.image = UIImage(named: image)
        imageV.layer.borderColor = isSelected ? UIColor.green.cgColor : UIColor.clear.cgColor
        imageV.layer.borderWidth = isSelected ? 3 : 0
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
        
        imageV >>> containerView >>> {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }

    }

}
