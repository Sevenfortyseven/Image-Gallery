//
//  ViewController.swift
//  Image Gallery
//
//  Created by aleksandre on 11.06.22.
//

import UIKit


public class ImageGalleryCollectionViewController: UICollectionViewController
{
    
    private var dataSource = DataStore.sharedDataStore.galleryData
    
    private var cellWidthScale: CGFloat = 150
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        addGestureRecognizers()
    }
    
    
    private func setupDelegate() {
        let navVC = splitViewController?.viewControllers[0] as! UINavigationController
        let galleriesVC = navVC.viewControllers[0] as! ImageGalleriesViewController
        galleriesVC.delegate = self
    }
    
    private func addGestureRecognizers() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(resizeCell))
        collectionView.addGestureRecognizer(pinchGesture)
    }
    
    
    @objc
    private func resizeCell(sender: UIPinchGestureRecognizer) {
        print(sender.scale)
        let minimumScale: CGFloat =  0.5
        let maxmimumScale: CGFloat = 2
        if sender.state == UIGestureRecognizer.State.changed ||
            sender.state == UIGestureRecognizer.State.ended {
            if sender.scale > minimumScale && sender.scale < maxmimumScale {
                cellWidthScale *= sender.scale
                flowLayout.invalidateLayout()
            }
            sender.scale = 1
        }
        
  
    }
    
}


extension ImageGalleryCollectionViewController: UICollectionViewDelegateFlowLayout
{
    
    var flowLayout: UICollectionViewFlowLayout {
        return collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidthScale, height: (cellWidthScale * (dataSource[indexPath.row].aspectRatio ?? 150)))
    }
   
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath)
        if let imageCell = cell as? ImageCollectionCell {
            if let imageUrl = dataSource[indexPath.item].url {
                imageCell.imageURL = imageUrl
                imageCell.fetchImage(with: imageUrl)
                
            }
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
        session.localContext = self.view
        return dragItems(at: indexPath)
    }
    
    /// Get an object to drag
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        if let image = (collectionView.cellForItem(at: indexPath) as? ImageCollectionCell)?.galleryImageView.image {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: image))
            dragItem.localObject = image
            return [dragItem ]
        } else {
            return []
        }
    }
    
    /// Detect  if  CV can  handle a drop of the appropriate type objects
    public func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        if session.localDragSession != nil {
            print("CanLoadONly Image")
            return session.canLoadObjects(ofClass: UIImage.self)
        }
        return (session.canLoadObjects(ofClass: URL.self) && session.canLoadObjects(ofClass: UIImage.self))
    }

    /// Return a drop proposal( copy , move or cancel)
    public func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        // if drag initiator is self collectionView then move, if not then copy
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    
    /// Perform a drop
    public func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            // If drag item is local collection cell image
            if let sourceIndexPath = item.sourceIndexPath {
                collectionView.performBatchUpdates {
                    let sortedImage = dataSource.remove(at: sourceIndexPath.item)
                    dataSource.insert(sortedImage, at: destinationIndexPath.item)
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                }
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                
            } else {
                var newGalleryItem = GalleryImage()
                let placeholderContext = coordinator.drop(item.dragItem, to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "DropPlaceholderCell"))
                
                // Get an object image aspect ratio
                item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) { imageProvider, _ in
                    DispatchQueue.main.async {
                        if let image = imageProvider as? UIImage {
                            let aspectRatio = image.size.height / image.size.width
                            newGalleryItem.aspectRatio = aspectRatio
                            
                        } else {
                            placeholderContext.deletePlaceholder()
                        }
                    }
                }
                
                // Get an object URL
                item.dragItem.itemProvider.loadObject(ofClass: NSURL.self) { urlProvider, _ in
                    DispatchQueue.main.async {
                        if let imageUrl = urlProvider as? URL {
                            placeholderContext.commitInsertion { insertionIndexPath in
                                newGalleryItem.url = imageUrl
                                self.dataSource.insert(newGalleryItem, at: insertionIndexPath.item)
                            }
                        } else {
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
