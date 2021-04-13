//
//  OrderPlacedCell.swift
//  LookingMenuRX
//
//  Created by than.duc.huy on 13/04/2021.
//

import UIKit
import Reusable
import SDWebImage

class OrderPlacedCell: UICollectionViewCell, NibReusable {
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(order: Order) {
        layer.borderWidth = 2
        layer.borderColor = UIColor.grayDesign.cgColor
        layer.cornerRadius = 10
        statusImageView.image = UIImage(named: order.status)
        recipeImageView.sd_setImage(with: URL(string: order.imageFood),
                                    completed: nil)
        recipeTitleLabel.text = order.titleFood
        totalLabel.text = "$\(order.total)"
        amountLabel.text = "Count: \(order.amount)"
    }
}
