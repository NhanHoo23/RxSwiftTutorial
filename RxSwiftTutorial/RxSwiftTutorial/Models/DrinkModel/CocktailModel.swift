//
//  Drink.swift
//  RxSwiftTutorial
//
//  Created by NhanHoo23 on 11/05/2023.
//

import MTSDK


//codable: để chuyển đổi dữ liệu 1 cách nhanh chóng, nhưng bắt buộc các properties cũng phải codable. Nó bao gồm các Encodable và Decodable
struct CocktailCategory: Codable {
    let strCategory: String
    var items = [Drink]()
    
    enum CodingKeys: String, CodingKey {
        case strCategory
    }
}

struct CategoryResult<T: Codable>: Codable { // <T> là dạng generic
    let drinks: [T]
}

