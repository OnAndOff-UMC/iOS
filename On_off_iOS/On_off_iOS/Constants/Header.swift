//
//  Header.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/01.
//

import Alamofire
import Foundation

enum Header {
    case header
    
    func getHeader() -> HTTPHeaders {
        let accessToken = KeychainWrapper.loadItem(forKey: LoginKeyChain.accessToken.rawValue) ?? ""
        print(accessToken)
        return ["Authorization": "Bearer \(accessToken)"]
    }
}
