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
    let title: String
    let galleryImages: [GalleryImage]?
    
}


struct RemovedGallery
{
    let title: String
    let images: [GalleryImage]?
    let imageURLs: [URL]?
    
}
