import UIKit
import RxSwift
import RxCocoa
import Then
import MGArchitecture
import Reusable
import NSObject_Rx

private enum ConstantIngredientView {
    static let radiusButton: CGFloat = 15
    static let radiusTableView: CGFloat = 20
    static let heightTableIngredient: CGFloat = 60
}

protocol IngredientTableViewDelegate: class {
    func removeIngredientCell(title: String)
}

final class IngredientController: UIViewController, Bindable {
    @IBOutlet weak private var proteinPickerView: UIPickerView!
    @IBOutlet weak private var vitaminPickerView: UIPickerView!
    @IBOutlet weak private var addProteinButton: UIButton!
    @IBOutlet weak private var addVitaminButton: UIButton!
    @IBOutlet weak private var searchIngredientTableView: UITableView!
    @IBOutlet weak private var searchRecipeByIngredientButton: UIButton!
    
    var viewModel: IngredientViewModel!
    let itemWillRemove = PublishRelay<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    func bindViewModel() {
        let input = IngredientViewModel.Input(
            loadTrigger: Driver.just(()),
            selectProtein: proteinPickerView.rx
                .itemSelected
                .map{$0.row}
                .asDriverOnErrorJustComplete(),
            selectVitamin: vitaminPickerView.rx
                .itemSelected
                .map{$0.row}
                .asDriverOnErrorJustComplete(),
            tapProteinButton: addProteinButton.rx.tap.asDriver(),
            tapVitaminButton: addVitaminButton.rx.tap.asDriver(),
            searchTrigger: searchRecipeByIngredientButton.rx.tap.asDriver(),
            itemWillRemove: itemWillRemove.asDriverOnErrorJustComplete())
        
        let output = viewModel.transform(input, disposeBag: rx.disposeBag)
        
        output.$dataTable.asDriver().drive(searchIngredientTableView.rx.items) { tableView, index, data in
            return tableView.dequeueReusableCell(
                for: IndexPath(row: index, section: 0),
                cellType: SearchIngredientTableCell.self)
                .then {
                    $0.configCell(title: data)
                    $0.delegateHandleIngredient = self
                }
        }
        .disposed(by: rx.disposeBag)
        
        searchIngredientTableView.endUpdates()
        
        output.$protein
            .asDriver()
            .drive(proteinPickerView.rx.itemTitles) { $1 }
            .disposed(by: rx.disposeBag)
        
        output.$vitamin
            .asDriver()
            .drive(vitaminPickerView.rx.itemTitles) { $1 }
            .disposed(by: rx.disposeBag)
    }
}

extension IngredientController {
    private func configView() {
        configNavigation()
        configButton()
        configTableView()
    }
    
    private func configButton() {
        [addProteinButton, addVitaminButton].forEach {
            $0?.layer.cornerRadius = ConstantIngredientView.radiusButton
        }
        
        searchRecipeByIngredientButton.do{
            $0.cornerCircle()
            $0.setImage(UIImage(named: "magnifier")?.withRenderingMode(.alwaysTemplate),
                                  for: .normal)
            $0.tintColor = .white
        }
    }
    
    private func configNavigation() {
        navigationController?.do {
            $0.setNavigationBarHidden(true, animated: true)
        }
    }
    
    private func configTableView() {
        searchIngredientTableView.do {
            $0.rowHeight = ConstantIngredientView.heightTableIngredient
            $0.layer.cornerRadius = ConstantIngredientView.radiusTableView
            $0.beginUpdates()
        }
    }
}

extension IngredientController: StoryboardSceneBased {
    static var sceneStoryboard = StoryBoardReference.ingredient.storyBoard
}

extension IngredientController: IngredientTableViewDelegate {
    func removeIngredientCell(title: String) {
        itemWillRemove.accept(title)
    }
}
