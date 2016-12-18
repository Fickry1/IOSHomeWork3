//
//  HomeTableViewController.swift
//  Article Management
//
//  Created by Sim Fickry on 12/13/16.
//  Copyright © 2016 HRD. All rights reserved.
//

import UIKit
import Kingfisher

protocol HomeTableViewDelegate {
    func articleLoad(article: [ArticleModel])
    func articlePosted()
    func deleteData(id: Int)
    func DeleteContentSuccess(withMessage message:String)
}

class HomeTableViewController: UITableViewController {

    var eventHandler: HomeTableViewPresenter!
    var articles = [ArticleModel]()
    var editorViewDelegate: EditorViewDelegate!
    var editor : EditorViewController?
    override func viewDidLoad() {
        super.viewDidLoad()

        eventHandler = HomeTableViewPresenter()
        eventHandler.articleLoad(viewInterface: self)
        eventHandler.getData()
    }
    
    @IBAction func AddArticleButton(_ sender: Any) {
        performSegue(withIdentifier: "gogo", sender: self)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableCell", for: indexPath) as! HomeTableViewCell

        cell.customCell(article: articles[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        func edit() {
            let article = articles[indexPath.row]
            performSegue(withIdentifier: "gogo", sender: article)
        }
        func delete() {
            var articleToDelete: ArticleModel!
            articleToDelete = articles[indexPath.row]
            if let article = articleToDelete {
                deleteData(id: article.id!)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                print("IDDD: ", article.id!)
            }
        }
        let moreRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Edit", handler:{action, indexpath in
            edit()
        });
        moreRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler:{action, indexpath in
            delete()
        });
        return [deleteRowAction, moreRowAction];
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gogo" {
            if let destination = segue.destination as? EditorViewController {
                if let article = sender as? ArticleModel {
                    destination.articleToEdit = article
                }
            }
        }
    }
}

extension HomeTableViewController: HomeTableViewDelegate {
    internal func DeleteContentSuccess(withMessage message: String) {
        print(message)
    }
    internal func deleteData(id: Int) {
        eventHandler.deleteData(id: id)
    }
    internal func articlePosted() {
        self.tableView.reloadData()
    }
    func articleLoad(article: [ArticleModel]) {
        if article.count > 0 {
            self.articles = article
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

