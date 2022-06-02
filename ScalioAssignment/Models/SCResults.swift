//
//  SCResults.swift
//  ScalioAssignment
//
//  Created by gnc on 12/05/2022.
//

import UIKit

class SCResults: Codable {
    let total_count:Int
    let incomplete_results:Bool
    let items:[SCItem]
    
    init(total_count:Int, incomplete_results:Bool, items:[SCItem]) {
        self.total_count = total_count
        self.incomplete_results = incomplete_results
        self.items = items
    }
}
