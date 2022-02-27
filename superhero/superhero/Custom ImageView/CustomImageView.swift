//
//  CustomImageView.swift
//  superhero
//
//  Created by Bhanu Kaushik on 27/02/22.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    
    var task: URLSessionTask!
    
    func loadImage(from url: URL, indicator: UIActivityIndicatorView) {
        image = nil
        
        if let task = task {
            task.cancel()
        }
        
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            self.image = imageFromCache
            indicator.stopAnimating()
            return
        }
        
        task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, let newImage = UIImage(data: data) else {
                return
            }
            
            imageCache.setObject(newImage, forKey: url.absoluteString as AnyObject)
            
            DispatchQueue.main.async {
                self.image = newImage
                indicator.stopAnimating()
            }
        }
        task.resume()
    }
}
