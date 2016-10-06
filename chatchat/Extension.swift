//
//  Extension.swift
//  chatchat
//
//  Created by Antoine Galpin on 04/10/2016.
//  Copyright © 2016 Antoine Galpin. All rights reserved.
//

import UIKit

private var imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func loadImageUsingCache(urlString: String) {
        self.image = nil
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
            let url = URLRequest(url: URL(string: urlString)!)
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error)
                    return
                }
                
                if let downloadImage = UIImage(data: data!) {
                    imageCache.setObject(downloadImage, forKey: urlString as AnyObject)
                    self.image = downloadImage
                }
            }).resume()
    }
}
