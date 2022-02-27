//
//  HeroTableViewCell.swift
//  superhero
//
//  Created by Bhanu Kaushik on 27/02/22.
//

import UIKit

class HeroTableViewCell: UITableViewCell {

    @IBOutlet weak var mainbgView: UIView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
