//
//  MDContextManager+Delegate.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/29.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import Foundation

extension MDContextManager:UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        saved = false
        guard let caretChange = caretChange else { return }
        caretChange()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard let caretChange = caretChange else { return }
        caretChange()
    }
    
}

extension MDContextManager: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func importPicture() {
        let picker = UIImagePickerController()
        picker.delegate = self
        let vc = MDBaseFuncHelper.mdGetCurrentShowViewController()
        vc.present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        insertPictureToTextView(image: image)
        let vc = MDBaseFuncHelper.mdGetCurrentShowViewController()
        vc.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        let vc = MDBaseFuncHelper.mdGetCurrentShowViewController()
        vc.dismiss(animated: true)
    }
}
