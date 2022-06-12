//
//  ViewController.swift
//  Image Gallery
//
//  Created by aleksandre on 11.06.22.
//

import UIKit


public class ImageGalleryCollectionViewController: UICollectionViewController
{

    private var dataSource = GalleryStore.sharedGalleryStore.galleryImages
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
    }

    private func setupDelegate() {
        let navVC = splitViewController?.viewControllers[0] as! UINavigationController
        let galleriesVC = navVC.viewControllers[0] as! ImageGalleriesTableViewConroller
        galleriesVC.delegate = self
    }
    
}


extension ImageGalleryCollectionViewController
{
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath)
        if let imageCell = cell as? ImageCollectionCell {
            imageCell.galleryImageView.image = dataSource[indexPath.item]
        }
        
        
        return cell
    }
    
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
}

//MARK: - Drag and Drop Delegate Methods
extension ImageGalleryCollectionViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate
{
    
    /// Begin dragging
    public func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(at: indexPath)
    }
    
    /// Get an object to drag
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        if let image = (collectionView.cellForItem(at: indexPath) as? ImageCollectionCell)?.galleryImageView.image {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: image))
            dragItem.localObject = image
            return [dragItem  ]
        } else {
            return []
        }
    }
    
    /// Detect  if  CV can  handle a drop of the appropriate type objects
    public func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return (session.canLoadObjects(ofClass: URL.self) && session.canLoadObjects(ofClass: UIImage.self))
    }
    
    /// Return a drop proposal( copy , move or cancel)
    public func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        // if drag initiator is self collectionView then move, if not then copy
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        print(isSelf)
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    /// Perform a drop
    public func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            // If drag item is local
            if let sourceIndexPath = item.sourceIndexPath {
                if let image = item.dragItem.localObject as? UIImage {
                    collectionView.performBatchUpdates {
                        dataSource.remove(at: sourceIndexPath.item)
                        dataSource.insert(image, at: destinationIndexPath.item)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                    }
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                }
            } else {
                let placeholderContext = coordinator.drop(
                    item.dragItem,
                    to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "DropPlaceholderCell"))
                item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) { provider, error in
                    DispatchQueue.main.async {
                        if let image = provider as? UIImage {
                            placeholderContext.commitInsertion { insertionIndexPath in
                                self.dataSource.insert(image, at: insertionIndexPath.item)
                            }
                        } else {
                            print("Provider error")
                            placeholderContext.deletePlaceholder()
                        }
                    }
                }
            }
        }
    }
    
}


extension ImageGalleryCollectionViewController: ImageGalleriesTableViewControllerDelegate
{
    func reloadData() {
        collectionView.reloadData()
    }
    
}
