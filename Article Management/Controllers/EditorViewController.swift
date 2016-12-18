//
//  EditorViewController.swift
//  Article Management
//
//  Created by Sim Fickry on 12/13/16.
//  Copyright © 2016 HRD. All rights reserved.
//

import UIKit

protocol EditorViewDelegate {
    func postData(title: String, description: String, image: String)
    func uploadImage(image: Data)
    func returnImageUrl(imgUrl: String)
    func postContentSuccess(withMessage message:String)
    func putData(id: Int, title: String, description: String, image: String)
}

class EditorViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleTitleTextField: UITextField!
    @IBOutlet weak var articleDescriptionTextView: UITextView!
    
    var imagePicker: UIImagePickerController!
    var eventHandler: EditorViewPresenter!
    var homeTableViewDelegate : HomeTableViewDelegate?
    var imageUrl: String!
    var articleToEdit: ArticleModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        eventHandler = EditorViewPresenter()
        eventHandler.editorViewDelegate = self
        if articleToEdit != nil {
            loadNoteData()
        }
    }
    
    @IBAction func imagePickerButton(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            articleImageView.image = img
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let imageData = UIImagePNGRepresentation(articleImageView.image!)
        uploadImage(image: imageData!)    
    }
    
    func loadNoteData() {
        if let article = articleToEdit {
            articleTitleTextField.text = article.title
            articleDescriptionTextView.text = article.description
            let imgUrl = article.image
            let url = URL(string: imgUrl!)
            let data = try! Data(contentsOf: url!)
            let image = UIImage(data: data)
            articleImageView.image = image
        }
    }
}

extension EditorViewController: EditorViewDelegate {
    
    internal func putData(id: Int, title: String, description: String, image: String) {
        eventHandler.putData(id: id, title: title, description: description, image: image)
    }
    
    internal func returnImageUrl(imgUrl: String) {
        self.imageUrl = imgUrl
        if articleToEdit == nil {
            postData(title: articleTitleTextField.text!, description: articleDescriptionTextView.text!, image: imageUrl)
        } else {
            putData(id: articleToEdit.id!, title: articleTitleTextField.text!, description: articleDescriptionTextView.text!, image: imgUrl)
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    func postData(title: String, description: String, image: String) {
        eventHandler.postData(title: title, description: title, image: image)
    }
    
    func uploadImage(image: Data) {
        eventHandler.uploadImage(image: image)
    }
    
    func postContentSuccess(withMessage message: String) {
        print("Message \(message)")
    }
}
