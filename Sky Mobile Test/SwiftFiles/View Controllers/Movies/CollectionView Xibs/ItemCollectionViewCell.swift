//
//  ItemCollectionViewCell.swift
//  Sky Mobile Test
//
//  Created by Vitor Augusto Araujo Silva on 30/10/20.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImage: UIImageView!
    
    @IBOutlet weak var movieTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
