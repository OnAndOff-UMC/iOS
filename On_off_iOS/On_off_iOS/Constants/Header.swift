//
//  Header.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/13/24.
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
