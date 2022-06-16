//
//  UIImage+.swift
//  Image Gallery
//
//  Created by aleksandre on 15.06.22.
//

import UIKit

extension UIImageView
{
    
    public func fetchImage(with url: URL?) {
        self.image = nil
        guard let url = url else {
            print("invalid url")
            return
        }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data, let fetchedImage = UIImage(data: data) {
                    self.image = fetchedImage
                }
            }
        }
        dataTask.resume()
    }
    
}
