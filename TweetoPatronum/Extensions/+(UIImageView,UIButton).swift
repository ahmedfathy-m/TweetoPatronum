//
//  +(UIImageView).swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 27/06/2022.
//

import Foundation
import UIKit

extension UIImageView{
    func downloadImage(from link:String) {
        Task.init {
            guard let imageURL = URL(string: link) else { return }
            let (data, _) = try await URLSession.shared.data(from: imageURL)
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }
    }
}

extension UIButton{
    func downloadImage(from link:String){
        Task.init {
            guard let imageURL = URL(string: link) else { return }
            let (data, _) = try await URLSession.shared.data(from: imageURL)
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.setImage(image, for: .normal)
            }
        }
    }
}
