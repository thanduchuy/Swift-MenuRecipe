import UIKit
import RxSwift
import RxCocoa
import Then
import MGArchitecture
import Reusable
import NSObject_Rx
import SDWebImage

class OrderViewController: UIViewController, Bindable {
    @IBOutlet weak var nameRecipeLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var nameUserTextField: UITextField!
    @IBOutlet weak var phoneUserTextField: UITextField!
    @IBOutlet weak var addressUserTextField: UITextField!
    @IBOutlet weak var plusAmountButton: UIButton!
    @IBOutlet weak var minusAmountButton: UIButton!
    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var orderButton: UIButton!
    
    var viewModel: OrderViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configImageView()
        configButton()
    }
    
    func bindViewModel() {
        let input = OrderViewModel.Input(loadView: Driver.just(()),
                                         minusTrigger: minusAmountButton.rx.tap.asDriver(),
                                         plusTrigger: plusAmountButton.rx.tap.asDriver(),
                                         backTrigger: goBackButton.rx.tap.asDriver(),
                                         textFieldTrigger: Driver.combineLatest(nameUserTextField.rx.text.orEmpty.asDriver(),
                                                                                phoneUserTextField.rx.text.orEmpty.asDriver(),
                                                                                addressUserTextField.rx.text.orEmpty.asDriver()),
                                         orderTrigger: orderButton.rx.tap.asDriver())
        
        let output = viewModel.transform(input, disposeBag: rx.disposeBag)
        
        output.$recipe
            .asDriver()
            .drive(recipeBinding)
            .disposed(by: rx.disposeBag)
        
        output.$amount
            .asDriver()
            .map { String($0) }
            .drive(amountLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        output.$total
            .asDriver()
            .map { "\($0) $" }
            .drive(totalLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        output.$activeButton
            .asDriver()
            .drive(orderButton.rx.isEnabled)
            .disposed(by: rx.disposeBag)
    }
}

extension OrderViewController {
    var recipeBinding: Binder<Recipe> {
        return Binder(self) { viewController, recipe in
            viewController.recipeImageView.sd_setImage(with: URL(string: recipe.image), completed: nil)
            viewController.nameRecipeLabel.text = recipe.title
        }
    }
    
    func configView() {
        configTextField()
        configLabel()
    }
    
    func configTextField() {
        [("Enter Name User", nameUserTextField),
         ("Enter Phone User", phoneUserTextField),
         ("Enter Adress User", addressUserTextField)].forEach {
            $0.1?.customPlaceHoder(text: $0.0, color: .grayDesign)
            $0.1?.shadowField()
         }
    }
    
    func configLabel() {
        totalLabel.do {
            $0.addShadowView(radius: $0.frame.height / 2)
        }
    }
    
    func configImageView() {
        recipeImageView.cornerCircle()
    }
    
    func configButton() {
        orderButton.cornerCircle()
    }
}

extension OrderViewController: StoryboardSceneBased {
    static var sceneStoryboard = StoryBoardReference.oder.storyBoard
}
