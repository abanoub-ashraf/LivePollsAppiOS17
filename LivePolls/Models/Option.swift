//
//  Option.swift
//  LivePolls
//
//  Created by Abanoub Ashraf on 31/08/2023.
//

import Foundation

struct Option: Codable, Identifiable, Hashable {
    var id = UUID().uuidString
    var count: Int
    var name: String
}
