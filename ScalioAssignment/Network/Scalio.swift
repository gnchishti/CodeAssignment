//
//  Scalio.swift
//  ScalioAssignment
//
//  Created by gnc on 13/05/2022.
//

import Foundation
import Moya

public enum Scalio {
    case search(String, Int)
    case image(String)
}

//https://avatars.githubusercontent.com/u/63215266?v=4

extension Scalio : TargetType {
    public var baseURL: URL {
        switch self {
        case .search: return URL(string: "https://api.github.com/search")!
        case .image(let url): return URL(string: url)!
        }
    }
    
    public var path: String {
        switch self {
        case .search: return "/users"
        case .image: return ""
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .search: return .get
        case .image(_): return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .search (let inputValue, let pageno):
            return .requestParameters(parameters: ["q": inputValue, "per_page": Constants.perPageRecords, "page":pageno], encoding: URLEncoding.default)
        case .image(_):
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
  
}
