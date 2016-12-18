//
//  HomeTableViewPresenter.swift
//  Article Management
//
//  Created by Sim Fickry on 12/13/16.
//  Copyright © 2016 HRD. All rights reserved.
//

import Foundation

protocol HomeTableViewPresenterDelegate {
    func responseData(data: [ArticleModel])
    func DeleteContentSuccess(withMessage message: String)
}

class HomeTableViewPresenter: HomeTableViewPresenterDelegate {
    var homeTableViewDelegate: HomeTableViewDelegate?
    var service: Service?
    
    func articleLoad(viewInterface: HomeTableViewDelegate) {
        homeTableViewDelegate = viewInterface
        service = Service()
        service?.homePresenterDelegate = self
    }
    
    func getData() {
        service?.getData()
    }
    
    func deleteData(id: Int) {
        service?.deleteData(id: id)
    }
    
    func responseData(data: [ArticleModel]) {
        
        homeTableViewDelegate?.articleLoad(article: data)
    }
    
    func DeleteContentSuccess(withMessage message: String) {
        homeTableViewDelegate?.DeleteContentSuccess(withMessage: message)
    }

    
}


