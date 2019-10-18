//
//  EKMediaPicker.swift
//  
//
//

import UIKit

class EKMediaPicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    static let mediaPicker = EKMediaPicker()
    
    typealias DidFinishPickingMediaBlock = (_ info: [String : Any], _ pickedImage: UIImage?) -> Void
    private var finishedPickingMediaWithInfo: DidFinishPickingMediaBlock?
    
    typealias DidCancelledPickingMediaBlock = () -> Void
    var cancelledPickingMediaBlock: DidCancelledPickingMediaBlock?

    func pickMediaFromCamera(cameraBlock: @escaping DidFinishPickingMediaBlock) ->Void {
        
        finishedPickingMediaWithInfo = cameraBlock
        
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            
            if let currentController = UIWindow.currentController {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                currentController.present(imagePicker, animated: true, completion: nil)
            }
        } else {
            pickMediaFromGallery(galleryBlock: { (info: [String : Any], pickedImage: UIImage?) in
                cameraBlock(info, pickedImage)
            })
        }
    }
    
    func pickMediaFromGallery(galleryBlock: @escaping DidFinishPickingMediaBlock) {
        
        if let currentController = UIWindow.currentController {
            finishedPickingMediaWithInfo = galleryBlock
            let imagePicker:UIImagePickerController? = UIImagePickerController()
            imagePicker!.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker?.delegate = self
            imagePicker!.allowsEditing = false
            currentController.present(imagePicker!, animated: true, completion: nil)
        }
    }
    
    // MARK:- - image picker delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        picker.dismiss(animated: true, completion: nil)
        
        let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
        
        if let finishedPickingMediaWithInfo = finishedPickingMediaWithInfo {
            finishedPickingMediaWithInfo(info, image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
        if let cancelledPickingMediaBlock = cancelledPickingMediaBlock {
            cancelledPickingMediaBlock()
        }
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
