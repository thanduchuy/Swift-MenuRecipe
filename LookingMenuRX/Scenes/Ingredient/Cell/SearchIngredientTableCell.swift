import UIKit
import Reusable

final class SearchIngredientTableCell: UITableViewCell, Reusable  {
    @IBOutlet weak private var titleIngredientLabel: UILabel!
    @IBOutlet weak private var ingredientBackgroundView: UIView!
    
    weak var delegateHandleIngredient: IngredientTableViewDelegate?
    var titleIngredient = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configCell(title: String) {
        titleIngredient = title
        titleIngredientLabel.text = titleIngredient
        ingredientBackgroundView.layer.cornerRadius = 10
    }
    
    @IBAction func tapRemoveCell(_ sender: Any) {
        delegateHandleIngredient?.removeIngredientCell(title: titleIngredient)
    }
}
