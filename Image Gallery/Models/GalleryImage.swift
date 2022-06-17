//
//  Ge.swift
//  Image Gallery
//
//  Created by aleksandre on 14.06.22.
//

import UIKit


struct GalleryImage
{
        
    var aspectRatio: CGFloat?
    var url: URL?
    
    init(aspectRatio: CGFloat? = nil, url: URL? = nil) {
        self.aspectRatio = aspectRatio
        self.url = url
    }
    
}
