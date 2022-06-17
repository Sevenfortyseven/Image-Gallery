//
//  GalleryStore.swift
//  Image Gallery
//
//  Created by aleksandre on 12.06.22.
//

import Foundation
import UIKit


class DataStore
{
    
    public static var sharedDataStore = DataStore()
    
    private init() { }
    
    public var galleryStore: [ImageGallery] = [] {
        didSet {
            print(galleryStore.count)
        }
    }
    public var removedGalleryStore: [RemovedGallery] = []
    
    public var galleryData: [GalleryImage] = []
    
    public func createGallery(with title: String) {
        galleryStore.append(ImageGallery(title: title, galleryImages: nil))
    }
    
}
