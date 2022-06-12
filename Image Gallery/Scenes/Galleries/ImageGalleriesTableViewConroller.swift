//
//  GallerySelectionTableViewController.swift
//  Image Gallery
//
//  Created by aleksandre on 11.06.22.
//

import UIKit


protocol ImageGalleriesTableViewControllerDelegate: AnyObject {
    func reloadData()
}

public class ImageGalleriesTableViewConroller: UITableViewController
{
    weak var delegate: ImageGalleriesTableViewControllerDelegate?
    

    private var dataSource = GalleryStore.sharedGalleryStore
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    

}

extension ImageGalleriesTableViewConroller
{
    
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return dataSource.galleryStore.count
        case 1:
            return dataSource.removedGalleryStore.count
        default: return 0
        }
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryCell", for: indexPath)
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Galleries"
        case 1:
            return "Deleted"
        default: return nil
        }
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newGallery = ImageGallery(title: "AA", images: nil, imageURLs: nil)
        dataSource.galleryStore.append(newGallery)
        delegate?.reloadData()
        
    }
}
