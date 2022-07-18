//
//  File.swift
//  Image Gallery
//
//  Created by aleksandre on 19.06.22.
//

import UIKit

public class ImageDetailsViewController: UIViewController
{
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.fetchImage(with: imageData?.url, start: nil) { [weak self] finishedfetching in
                guard let self = self else { return }
                if finishedfetching {
                    self.loadingSpinner.stopAnimating()
                    let size = self.imageView.image?.size ?? CGSize.zero

                    // Configure ScrollView
                    self.imageView.frame = CGRect(origin: CGPoint.zero, size: size)
                    self.scrollView.contentSize = size
                    self.scrollViewWidth.constant = size.width
                    self.scrollViewHeight.constant = size.height
                    self.scrollView.zoomScale = max(self.view.bounds.size.width / size.width,
                                                    self.view.bounds.size.height / size.height)
                    
                }
            }
            
            
        }
    }
    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 1/15
            scrollView.maximumZoomScale = 1
            scrollView.delegate = self
        }
    }
    
    var imageData: GalleryImage?
    
    override public func viewDidLoad() {
        super.viewDidLoad()

    }
    
}

extension ImageDetailsViewController: UIScrollViewDelegate
{
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView

    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        // TODO: Repair this
        scrollViewHeight.constant = scrollView.contentSize.height
        scrollViewWidth.constant = scrollView.contentSize.width
    
        
    }
    
    
}
