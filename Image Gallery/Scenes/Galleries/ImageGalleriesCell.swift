//
//  ImageGalleriesCell.swift
//  Image Gallery
//
//  Created by aleksandre on 21.06.22.
//

import UIKit

protocol ImageGallertiesTableViewCellDelegate: AnyObject {
    func didUpdateGalleryTitle(_ text: String, _ currentCell: UITableViewCell)
}

class ImageGalleriesTableViewCell: UITableViewCell
{
    weak var delegate: ImageGallertiesTableViewCellDelegate?
    
    private var initialTitle: String?
    
    @IBOutlet weak var galleryTitle: UITextField!
    @IBOutlet weak var titleTextField: UITextField! {
        didSet {
            titleTextField.isUserInteractionEnabled = false
            titleTextField.delegate = self
            addDoubleTapGesture()
            
        }
    }
    
    
    private func addDoubleTapGesture() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(editTitle))
        doubleTap.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(doubleTap)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.isUserInteractionEnabled = false
    }
    
    @objc
    private func editTitle() {
        initialTitle = titleTextField.text
        titleTextField.isUserInteractionEnabled = true
        titleTextField.becomeFirstResponder()
    }
    
    
    
}

extension ImageGalleriesTableViewCell: UITextFieldDelegate
{
    /// Hides keyboard after pressing return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.isUserInteractionEnabled = false
        guard textField.text != "" else {
            textField.text = initialTitle
            return true
        }
        delegate?.didUpdateGalleryTitle(textField.text!, self)
        return true
    }
    
    
    
    
    
}
