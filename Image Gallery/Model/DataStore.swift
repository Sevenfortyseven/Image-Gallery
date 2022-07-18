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
        let chosenGalleryIndex = galleryStore.firstIndex(where: {$0.uuid == chosenGallery?.uuid})
        if chosenGallery != nil, chosenGalleryIndex != nil {
            galleryStore[chosenGalleryIndex!] = chosenGallery!
        }
        
        let newGallery = galleryStore[indexPath.row]
        chosenGallery = newGallery
        
    }
    
    
    public var removedGalleryStore: [ImageGallery] = []
    
    
    public func createGallery(with title: String) {
        galleryStore.append(ImageGallery(title: title, galleryImages: []))
        
    }
    
    public func removeImage(for indexPath: IndexPath) {
        chosenGallery?.galleryImages?.remove(at: indexPath.row)
    }
    
}
