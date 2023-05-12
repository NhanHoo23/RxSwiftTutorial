//
//  Drink.swift
//  RxSwiftTutorial
//
//  Created by NhanHoo23 on 11/05/2023.
//

import MTSDK

struct DrinkResult {
    var drinks: [Drink]
}

struct Drink: Codable {
    let strDrink: String
    let strDrinkThumb: String
    let idDrink: String
}
