//
//  ResultTableViewCellViewModel.swift
//  ScalioAssignment
//
//  Created by gnc on 15/05/2022.
//

import Foundation
import RxSwift
import RxCocoa

class ResultTableViewCellViewModel {
    
    var login = BehaviorRelay(value: String())
    var avatar_url = BehaviorRelay(value: String())
    var type = BehaviorRelay(value: String())
    
    func setItem(item:SCItem) {
        self.login.accept(item.login)
        self.avatar_url.accept(item.avatar_url)
        self.type.accept(item.type)
    }
}
