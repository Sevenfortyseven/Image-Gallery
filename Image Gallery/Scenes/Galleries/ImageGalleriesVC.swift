//
//  GallerySelectionTableViewController.swift
//  Image Gallery
//
//  Created by aleksandre on 11.06.22.
//

import UIKit


protocol ImageGalleriesViewControllerDelegate: AnyObject {
    func didChangeGalleryState(isSelected: Bool)
    func reloadData()
}

public class ImageGalleriesViewController: UIViewController
{
    weak var delegate: ImageGalleriesViewControllerDelegate?
    
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
            return dataSource.removedGalleryStore.count
        default: return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryCell", for: indexPath)
            var config = cell.defaultContentConfiguration()
            config.text = dataSource.galleryStore[indexPath.row].title
            cell.contentConfiguration = config
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RemovedGalleryCell", for: indexPath)
            var config = cell.defaultContentConfiguration()
            config.text = dataSource.removedGalleryStore[indexPath.row].title
            cell.contentConfiguration = config
            return cell
        }
  
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Recently removed"
        default: return nil
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 0 else { return }
        dataSource.chooseGallery(with: indexPath)
        delegate?.reloadData()
        delegate?.didChangeGalleryState(isSelected: true)
        
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // indexPath for second section
        var rowCounter = 0
        let indexPathForSectionTwo: IndexPath = [1, rowCounter]
        switch editingStyle {
        case .delete:
            dataSource.chosenGallery = nil
            // Move to recently removed
            if indexPath.section == 0 {
                tableView.performBatchUpdates {
                    let removedGallery = dataSource.galleryStore.remove(at: indexPath.row)
                    dataSource.removedGalleryStore.insert(removedGallery, at: 0)
                    tableView.deleteRows(at: [indexPath], with: .left)
                    tableView.insertRows(at: [indexPathForSectionTwo], with: .left)
                    rowCounter += 1
                    delegate?.didChangeGalleryState(isSelected: false)
                }
            } else if indexPath.section == 1 {
                // Delete permanently
                tableView.performBatchUpdates {
                    dataSource.removedGalleryStore.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPathForSectionTwo], with: .left)
                    
                    rowCounter -= 1
                    
                }
            }
        
        default: break
        }
    }
    
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.section == 1 else { return nil }
        let indexPathForSectionTwo: IndexPath = [1, indexPath.row]
        let lastRow = self.dataSource.galleryStore.endIndex
        let lastIndexPathForSectionOne: IndexPath = [0, lastRow]
        let undeleteSwipeAction = UIContextualAction(style: .normal, title: "Undelete") { [weak self] (action, view, completion) in
            guard let self = self else { return }
            
            tableView.performBatchUpdates {
                let galleryToRecover = self.dataSource.removedGalleryStore.remove(at: indexPath.row)
                self.dataSource.galleryStore.append(galleryToRecover)
                tableView.deleteRows(at: [indexPathForSectionTwo], with: .left)
                tableView.insertRows(at: [lastIndexPathForSectionOne], with: .left)
                
            }
        
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [undeleteSwipeAction])
    }
}
