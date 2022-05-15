//
//  SCNetworkManager.swift
//  ScalioAssignment
//
//  Created by gnc on 12/05/2022.
//

import Foundation
import Moya
import SystemConfiguration


class SCNetworkManager {
    static let shared = SCNetworkManager()
    let provider = MoyaProvider<Scalio>()
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        return ret
        
    }
    
    func requestResult(strLogin:String, pageNo:Int, resultHanlder:@escaping ([SCItem]) -> Void, errorHandler:@escaping (String) -> Void) {
        
        if !self.isConnectedToNetwork() {
            errorHandler("Internet not connected")
            return
        }
        
        provider.request(.search(strLogin, pageNo)) { result in
            switch result {
            case .success(let response):
                do {
                    let results = try response.map(SCResults.self)
                    resultHanlder(results.items)
                } catch {
                    errorHandler(error.localizedDescription)
                }
            case .failure(let failure):
                errorHandler(failure.localizedDescription)
            }
        }
    }
    
    func loadImage(strImageUrl:String, resultHanlder:@escaping (UIImage) -> Void, errorHandler:@escaping (String) -> Void) {
        
        if !self.isConnectedToNetwork() {
            errorHandler("Internet not connected")
            return
        }
        
        provider.request(.image(strImageUrl)) { result in
            switch result {
            case .success(let response):
                do {
                    let img = try response.mapImage()
                    resultHanlder(img)
                } catch {
                    errorHandler(error.localizedDescription)
                }
            case .failure(let failure):
                errorHandler(failure.localizedDescription)
            }
        }
    }
    
}
