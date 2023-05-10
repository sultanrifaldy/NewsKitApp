//
//  NewsViewCell.swift
//  NewsKit
//
//  Created by Sultan Rifaldy on 10/05/23.
//

import UIKit

protocol NewsViewCellDelegate: AnyObject {
    func newsViewCellBookmarkButtonTapped (_ cell: NewsViewCell)
}

class NewsViewCell: UITableViewCell {
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titileLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    weak var delegate: NewsViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup () {
        thumbImageView.layer.cornerRadius = 8
        thumbImageView.layer.masksToBounds = true
    }
    
    var bookmarkButtonGotTapped : (() -> ()) = {}
    
    @IBAction func bookmarkButtonTapped(_ sender: Any) {
       bookmarkButtonGotTapped()
    }
    
}
