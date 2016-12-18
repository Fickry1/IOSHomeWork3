//
//  HomeTableViewCell.swift
//  Article Management
//
//  Created by Sim Fickry on 12/13/16.
//  Copyright © 2016 HRD. All rights reserved.
//

import UIKit
import Kingfisher

class HomeTableViewCell: UITableViewCell {

    //  Mark IBOutlet
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleCreatedDateLabel: UILabel!
    @IBOutlet weak var articleDescriptionLabel: UILabel!
    
    func customCell(article: ArticleModel) {

        articleTitleLabel.text = article.title?.capitalized
        articleDescriptionLabel.text = article.description
        imageView?.kf.setImage(with: URL(string: (article.image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!))
        
        // Format Date
        let today = Date()
        let date = article.createdDate!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let dateObj = dateFormatter.date(from: date)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        var result = formatter.string(from: dateObj!)
        
        if result == formatter.string(for: today) {
            formatter.dateFormat = "HH:mm:ss"
            result = formatter.string(for: dateObj)!
            articleCreatedDateLabel.text = result
        } else {
            articleCreatedDateLabel.text = result
        }
        
        
    }
    
    
}
