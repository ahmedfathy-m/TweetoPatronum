//
//  +(URLSession).swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 27/06/2022.
//

import Foundation

extension URLRequest{
    init(url:URL, method:HTTPMethod,token: String) {
        self.init(url: url)
        self.httpMethod = method.rawValue
        self.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    
    init(url:URL, method:HTTPMethod,auth: String) {
        self.init(url: url)
        self.httpMethod = method.rawValue
        self.addValue("OAuth \(auth)", forHTTPHeaderField: "Authorization")
    }
    
    init(url:URL, method:HTTPMethod) {
        self.init(url: url)
        self.httpMethod = method.rawValue
    }
}


