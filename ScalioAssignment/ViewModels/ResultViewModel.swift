//
//  ResultViewModel.swift
//  ScalioAssignment
//
//  Created by gnc on 12/05/2022.
//

import Foundation

import RxSwift
import RxCocoa

class ResultViewModel {
    let arrItems = BehaviorRelay(value: [SCItem]())
    var lastCount:Int = 1
    func fetchResults(inputText:String, pageno:Int, completion:@escaping (Int) -> Void, errorHandler:@escaping (String) -> Void) {
        weak var weakSelf = self //getting self reference for to get rid of retain cycle
        SCNetworkManager.shared.requestResult(strLogin: inputText, pageNo: pageno) { arr in
            self.lastCount = arr.count
            if (arr.count>0) {
                let sortedArray = arr.sorted { $0.login.lowercased() < $1.login.lowercased() }
                weakSelf?.arrItems.accept(sortedArray)
            }
            completion(arr.count)
        } errorHandler: { errorString in
            errorHandler(errorString)
        }
    }
}
    

