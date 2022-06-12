//
//  GalleryStore.swift
//  Image Gallery
//
//  Created by aleksandre on 12.06.22.
//

import UIKit


class GalleryStore
{
    
    public static var sharedGalleryStore = GalleryStore()
    
    private init() { }
    
    public var galleryStore: [ImageGallery] = []
    public var removedGalleryStore: [RemovedGallery] = []
    
    public var galleryImages: [UIImage] = []
    
}
