//
//  Books.swift
//  MedicareApp
//
//  Created by Arrax on 17/01/24.
//

import Foundation

struct Books : Decodable, Hashable {
    var docs : [content]
}

struct content : Decodable, Hashable {
    var title : String?
    var ratings_average : Double?
    var ratings_count : Int?
    var cover_i : Int
    var author_name : [String]?
}
