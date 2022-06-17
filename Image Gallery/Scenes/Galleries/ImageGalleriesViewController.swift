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

public class ImageGalleriesViewController: UIViewController
{
    weak var delegate: ImageGalleriesTableViewControllerDelegate?
    
    @IBOutlet private var galleriesTableView: UITableView! {
        didSet {
            galleriesTableView.delegate = self
            galleriesTableView.dataSource = self
        }
    }
    
    private var dataSource = DataStore.sharedDataStore
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func addNewGallery(_ sender: Any) {
        let alert = UIAlertController(title: "Enter gallery name", message: nil, preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            if let inputText = alert.textFields?.first?.text {
                print("created")
//                DataStore.sharedDataStore.createGallery(with: inputText)
                self.dataSource.createGallery(with: inputText)
                self.galleriesTableView.reloadData()
            }
        }))
        self.present(alert, animated: true)
    }
    
}

extension ImageGalleriesViewController: UITableViewDelegate, UITableViewDataSource
{
    
    
    public  func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return dataSource.galleryStore.count
        case 1:
            return 0
        default: return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryCell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = dataSource.galleryStore[indexPath.item].title
        cell.contentConfiguration = config
        return cell
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Recently removed"
        default: return nil
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let newGallery = ImageGallery(title: "AA", images: nil, imageURLs: nil)
        //        dataSource.galleryStore.append(newGallery)
        //        delegate?.reloadData()
        
    }
}
