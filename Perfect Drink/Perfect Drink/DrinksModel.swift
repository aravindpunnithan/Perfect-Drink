//
//  DrinksModel.swift
//  Perfect Drink
//
//  Created by Aravind P on 12/03/22.
//

import Foundation

struct DrinksBase : Codable {
    let drinks : [Drinks]?

    enum CodingKeys: String, CodingKey {
        case drinks = "drinks"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        drinks = try values.decodeIfPresent([Drinks].self, forKey: .drinks)
    }

}


struct Drinks : Codable {
    let idDrink : String
    let strDrink : String
    let strDrinkThumb : String
    let strInstructions : String
    
    init(idDrink: String, strDrink: String, strDrinkThumb: String, strInstructions: String) {
        self.idDrink = idDrink
        self.strDrink = strDrink
        self.strDrinkThumb = strDrinkThumb
        self.strInstructions = strInstructions
    }
}

