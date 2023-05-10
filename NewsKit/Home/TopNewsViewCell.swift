//
//  TopNewsViewCell.swift
//  NewsKit
//
//  Created by Sultan Rifaldy on 10/05/23.
//

import UIKit

class TopNewsViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    
    func setup() {
        thumbImageView.layer.cornerRadius = 8
        thumbImageView.layer.masksToBounds = true
    }
}
