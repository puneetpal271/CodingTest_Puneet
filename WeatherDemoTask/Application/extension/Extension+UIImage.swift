//
//  Extension+UIImage.swift
//  WeatherDemoTask
//
//  Created by Puneetpal Singh on 5/16/23.
//

import Foundation
import UIKit
extension UIImageView{
    func loadImages(url:URL?){
        self.sd_setImage(with: url, placeholderImage: UIImage(), options: [.highPriority,]) { image, error, cache, url in
            if let imageData = image{
                DispatchQueue.main.async {
                    self.image = imageData
                }

            }
        }
    }
    func loadUIImage(url:URL?,completion : @escaping (UIImage)->Void){
        self.sd_setImage(with: url, placeholderImage: UIImage(), options: [.highPriority,]) { image, error, cache, url in
            if let imageData = image{
                DispatchQueue.main.async {
                    self.image = imageData
                    completion(imageData)
                }

            }
        }
    }
}
