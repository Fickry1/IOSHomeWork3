//
//  EditorViewPresenter.swift
//  Article Management
//
// Created by Sim Fickry on 12/13/16.
//  Copyright © 2016 HRD. All rights reserved.
//

import Foundation

protocol EditorViewPresenterDelegate {
    func responseData(imgUrl: String)
    func postContentSuccess(withMessage message: String)
}

class EditorViewPresenter: EditorViewPresenterDelegate {
    
    //  Mark Object
    var editorViewDelegate: EditorViewDelegate?
    var service = Service()
    
    func postData(title: String, description: String, image: String) {
        service.postData(title: title, description: description, image: image)
    }
    
    func putData(id: Int, title: String, description: String, image: String) {
        service.putData(id: id, title: title, description: description, image: image)
    }
    
    func uploadImage(image: Data){
        service.editorViewPresenterDelegate = self
        service.uploadImage(image: image)
    }
    internal func responseData(imgUrl: String) {
        editorViewDelegate?.returnImageUrl(imgUrl: imgUrl)
    }
    
    func postContentSuccess(withMessage message: String) {
        editorViewDelegate?.postContentSuccess(withMessage: message)
    }
}
