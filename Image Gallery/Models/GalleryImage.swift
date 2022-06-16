//
//  Ge.swift
//  Image Gallery
//
//  Created by aleksandre on 14.06.22.
//

import UIKit


struct GalleryImage
{
        
    var image: UIImage?
    var url: URL?
    
    init(image: UIImage? = nil, url: URL? = nil) {
        self.image = image
        self.url = url
    }
    
}
