//
//  ImageCell.swift
//  Image Gallery
//
//  Created by aleksandre on 12.06.22.
//

import UIKit


class ImageCollectionCell: UICollectionViewCell
{
    
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var galleryImageView: UIImageView!
    
    public var imageURL: URL!
    
    public func fetchImage(with url: URL?) {
        loadingSpinner.startAnimating()
        galleryImageView.image = nil
        guard let url = url else {
            print("invalid url")
            return
        }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data, let fetchedImage = UIImage(data: data) {
                    self.loadingSpinner.stopAnimating()
                    self.galleryImageView.image = fetchedImage
                }
            }
        }
        dataTask.resume()
    }
}
