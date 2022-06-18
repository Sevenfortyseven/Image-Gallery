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
    
    public var galleryStore: [ImageGallery] = []
    
    public var chosenGallery: ImageGallery?
    
    public func chooseGallery(with indexPath: IndexPath) {
        // Replace chosen galleryStore gallery with current gallery before choosing new gallery
        let currentGalleryIndex = galleryStore.firstIndex(where: {$0.title == chosenGallery?.title})
        if chosenGallery != nil, currentGalleryIndex != nil {
            galleryStore[currentGalleryIndex!] = chosenGallery!
        }
        
        let newGalleryImages = galleryStore[indexPath.row]
        chosenGallery = newGalleryImages
        
    }
    
    
    public var removedGalleryStore: [ImageGallery] = []
    
    
    public func createGallery(with title: String) {
        galleryStore.append(ImageGallery(title: title, galleryImages: []))
        
    }
    
}
