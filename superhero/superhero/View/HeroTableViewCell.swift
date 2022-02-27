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
    @IBOutlet weak var heroImageView: CustomImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageContainerView.layer.cornerRadius = 35
        heroImageView.layer.cornerRadius = 35
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
