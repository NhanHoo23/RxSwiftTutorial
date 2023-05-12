//
//  Drink.swift
//  RxSwiftTutorial
//
//  Created by NhanHoo23 on 11/05/2023.
//

import MTSDK

// MARK: - DrinkResult
struct CategoryResult<T: Codable>: Codable { //codable: để chuyển đổi dữ liệu 1 cách nhanh chóng, nhưng bắt buộc các properties cũng phải codable
    let drinks: [T]
}

// MARK: - Drink
struct CocktailCategory: Codable {
    let strCategory: String
    var items = [Drink]()
    
    enum CodingKeys: String, CodingKey {
        case strCategory
    }
}
