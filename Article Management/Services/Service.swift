//
//  Service.swift
//  Article Management
//
//  Created by Sim Fickry on 12/13/16.
//  Copyright © 2016 HRD. All rights reserved.
//

import Foundation

class Service {
    
    //  Mark Instance
    var articles = [ArticleModel]()
    var homePresenterDelegate: HomeTableViewPresenterDelegate?
    var editorViewPresenterDelegate: EditorViewPresenterDelegate?
    
    //  Get Data
    func getData() {
        let url = URL(string:  "\(Constant.URL.ARTICLE)")
        var request = URLRequest(url: url!)
        request.setValue("\(Constant.URL.headers)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
            guard error == nil && data != nil else {
                print("Error:", error)
                return
            }
            let httpStatus = response as? HTTPURLResponse
            if  httpStatus!.statusCode == 200 {
                if data?.count != 0 {
                    let responeString = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                    let jsonData = responeString["DATA"] as! [AnyObject]
                    for responseData in jsonData {
                        self.articles.append(ArticleModel(JSON: responseData as! [String : Any])!)
                    }
                    //  Notify to presenter
                  self.homePresenterDelegate?.responseData(data: self.articles)
                } else {
                    print("No data got from url!")
                }
            } else {
                print("error httpstatus code is :",httpStatus!.statusCode)
            }
        }
        task.resume()
    }
    
    
    // Post Data
    func postData(title: String, description: String, image: String) {
        let newData = ["TITLE": title, "DESCRIPTION": description, "IMAGE": image]
        
        let url = URL(string:  "\(Constant.URL.ARTICLE)")
        var request = URLRequest(url: url!)
        request.setValue("\(Constant.URL.headers)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: newData, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        let postTask = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                if data != nil {
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                        print("statusCode should be 200, but is \(httpStatus.statusCode)")
                        print("response = \(response)")
                    }
                    self.editorViewPresenterDelegate?.postContentSuccess(withMessage: "Success")
                }
            }
        }
        postTask.resume()
    }
    
    //Upload Image
    func uploadImage(image: Data) {
        var jsonData: String?
        let urlImage = URL(string: "\(Constant.URL.UPLOAD_IMAGE)")
        var uploadImage = URLRequest(url: urlImage!)
        let boundary = "Boundary-\(UUID().uuidString)"
        uploadImage.setValue("\(Constant.URL.headers)", forHTTPHeaderField: "Authorization")
        uploadImage.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        uploadImage.httpMethod = "POST"
        uploadImage.addValue("application/json", forHTTPHeaderField: "Accept")
        var formData = Data()
        let mimeType = "image/png"
        // Image
        formData.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        formData.append("Content-Disposition: form-data; name=\"FILE\"; filename=\"Image.png\"\r\n".data(using: .utf8)!)
        formData.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        formData.append(image)
        formData.append("\r\n".data(using: .utf8)!)
        formData.append("--\(boundary)--\r\n".data(using: .utf8)!) 
        do {
            uploadImage.httpBody = formData
        } catch let error {
            print(error.localizedDescription)
        }
        let uploadTask = URLSession.shared.dataTask(with: uploadImage) {
            (data, response, error) in
            if error != nil {
                print(error as Any)
            } else {
                if let urlContent = data {
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                        print("statusCode should be 200, but is \(httpStatus.statusCode)")
                        print("response = \(response)")
                    }
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
                        jsonData = jsonResult["DATA"] as? String
                        //  Notify to presenter
                        self.editorViewPresenterDelegate?.responseData(imgUrl: jsonData!)
                    } catch {
                        print("JSON Processing Failed")    
                    }
                }
            }
        }
        uploadTask.resume()
    }
    
    
    //Put Data
    func putData(id: Int, title: String, description: String, image: String) {
        let url = URL(string: "\(Constant.URL.ARTICLE)/\(id)")
        var request = URLRequest(url: url!)
        request.setValue("\(Constant.URL.headers)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let dict = ["TITLE": title, "DESCRIPTION": description, "IMAGE": image]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        let putTask = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                if data != nil {
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                        print("statusCode should be 200, but is \(httpStatus.statusCode)")
                        print("response = \(response)")
                    }
                    self.editorViewPresenterDelegate?.postContentSuccess(withMessage: "Success")
                }
            }
        }
        putTask.resume()
    }
    
    //Delete Data
    func deleteData(id: Int) {
        let url = URL(string: "\(Constant.URL.ARTICLE)/\(id)")
        var request = URLRequest(url: url!)
        request.setValue("\(Constant.URL.headers)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let deleteTask = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                if data != nil {
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                        print("statusCode should be 200, but is \(httpStatus.statusCode)")
                        print("response = \(response)")
                    }
                self.homePresenterDelegate?.DeleteContentSuccess(withMessage: "Delete Success")
                }
            }
        }
        deleteTask.resume()
    }
}
