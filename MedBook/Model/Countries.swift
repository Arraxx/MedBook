//
//  Countries.swift
//  MedicareApp
//
//  Created by Arrax on 16/01/24.
//

import Foundation

struct Countries : Decodable{
    var data : [String : countryVal]
    
}

struct countryVal : Decodable{
    var country : String
    var region : String
}

struct currentCountry : Decodable{
    var country : String?
}
