//
//  ImageGallery.swift
//  Image Gallery
//
//  Created by aleksandre on 11.06.22.
//

import Foundation
import UIKit

struct ImageGallery
{
    var title: String
    var galleryImages: [GalleryImage]?
    var uuid: String
    
    init(title: String, galleryImages: [GalleryImage]?) {
        self.title = title
        self.galleryImages = galleryImages
        self.uuid = UUID().uuidString
    }
    
}

