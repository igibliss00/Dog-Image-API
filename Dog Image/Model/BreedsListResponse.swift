//
//  BreedsListResponse.swift
//  Dog Image
//
//  Created by J on 2020-04-30.
//  Copyright © 2020 J. All rights reserved.
//

import Foundation

struct BreedsListResponse: Codable {
    let message: [String: [String]]
    let status: String
}
