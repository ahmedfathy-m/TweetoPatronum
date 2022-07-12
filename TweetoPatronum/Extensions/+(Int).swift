//
//  +(Int).swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 27/06/2022.
//

import Foundation

extension Int{  
    var kFormattedString: String{
        let number = self
        if Double(number) >= 1000.0 {
            let formattedNumber = Double(number) / 1000.0
            return "\(String(format: "%.1f", formattedNumber))K"
        }else if number == 0{
            return ""
        }else {
            return String(number)
        }
    }
}

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }

    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
    
    func hexDataFromString()-> Data?{
        guard self.count % 2 == 0 else { return nil }
        var data = Data()
        var byteLiteral = ""
        for (index, character) in self.enumerated() {
            if index % 2 == 0 {
                byteLiteral = String(character)
            } else {
                byteLiteral.append(character)
                guard let byte = UInt8(byteLiteral, radix: 16) else { return nil }
                data.append(byte)
            }
        }
        return data
    }
    
    var parametersFromOAuthResponse: [String: String]? {
        var oauthParameters = [String:String]()
        let oauth = self.split(separator: "&")
        for kvPair in oauth{
            guard let key = kvPair.split(separator: "=").first?.description else {return nil}
            guard let value = kvPair.split(separator: "=").last?.description else {return nil}
            oauthParameters[key] = value
        }
        return oauthParameters
    }
}
