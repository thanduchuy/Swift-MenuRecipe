import UIKit
import RxSwift
import RxCocoa
import Reusable
import NSObject_Rx
import MGArchitecture

private enum ConstantFavourite {
    static let heightFavouriteRecipeCell: CGFloat = 100
}

final class FavouriteController: UIViewController, Bindable {
    @IBOutlet weak private var favouriteRecipeTableView: UITableView!
    
    var viewModel: FavouriteViewModel!
    @Property var refershData = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        $refershData.accept(1)
    }
    
    func bindViewModel() {
        let input = FavouriteViewModel.Input(
            loadTrigger: Driver.just(()),
            notification: $refershData.asDriver(),
            selectTrigger: favouriteRecipeTableView.rx.itemSelected.asDriver(),
            deleteTrigger: favouriteRecipeTableView.rx.itemDeleted.asDriver())
        
        let output = viewModel.transform(input, disposeBag: rx.disposeBag)
        
        output.$recipes
            .asDriver()
            .drive(favouriteRecipeTableView.rx.items) { tableView, index, recipe in
                tableView.dequeueReusableCell(
                    for: IndexPath(row: index, section: 0),
                    cellType: FavouriteRecipeTableCell.self)
                    .then {
                        $0.configFavouriteRecipeCell(item: recipe)
                        $0.selectionStyle = .none
                    }
            }
            .disposed(by: rx.disposeBag)
        favouriteRecipeTableView.endUpdates()
    }
}

extension FavouriteController {
    private func configView() {
        configTableView()
        configNavigator()
    }
    
    private func configNavigator() {
        navigationController?.do {
            $0.setNavigationBarHidden(true, animated: true)
        }
    }
    
    private func configTableView() {
        favouriteRecipeTableView.do {
            $0.register(cellType: FavouriteRecipeTableCell.self)
            $0.rowHeight = ConstantFavourite.heightFavouriteRecipeCell
            $0.beginUpdates()
        }
    }
}

extension FavouriteController: StoryboardSceneBased {
    static var sceneStoryboard = StoryBoardReference.favourite.storyBoard
}
