//
//  SCResults.swift
//  ScalioAssignment
//
//  Created by gnc on 12/05/2022.
//

import UIKit

struct ScalioResults<T:Codable> : Codable {
    let results: T
}

class SCResults: Codable {
    var total_count:Int = 0
    var incomplete_results:Bool = false
    var items:[SCItem] = [SCItem]()
}
