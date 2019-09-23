//
//  FeedItemTableViewCell.swift
//  Reddit-reader
//
//  Created by Madhu on 23/09/19.
//  Copyright © 2019 task. All rights reserved.
//

import UIKit

class FeedItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var upVoteBtn: UIButton!
    
    @IBOutlet weak var scoreLbl: UILabel!
    
    @IBOutlet weak var downVoteBtn: UIButton!
    
    @IBOutlet weak var auotherLbl: UILabel!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
