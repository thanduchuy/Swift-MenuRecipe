import Foundation
import RxSwift
import RxCocoa
import MGArchitecture

struct IngredientViewModel {
    let navigator: IngredientNavigationType
}

extension IngredientViewModel: ViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let selectProtein: Driver<Int>
        let selectVitamin: Driver<Int>
        let tapProteinButton: Driver<Void>
        let tapVitaminButton: Driver<Void>
        let searchTrigger: Driver<Void>
        let itemWillRemove: Driver<String>
    }
    
    struct Output {
        @Property var protein = [String]()
        @Property var vitamin = [String]()
        @Property var dataTable = [String]()
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        let selectProtein = BehaviorRelay<String>(value: "chicken")
        let selectVitamin = BehaviorRelay<String>(value: "carrot")
        
        input.loadTrigger
            .map {
                [ "chicken",
                  "duck",
                  "beef",
                  "pork",
                  "fish",
                  "shrimp",
                  "crab",
                  "egg",
                  "milk"]
            }
            .drive(output.$protein)
            .disposed(by: disposeBag)
        
        input.loadTrigger
            .map {
                [ "carrot",
                  "corn",
                  "broccoli",
                  "asparagus",
                  "lettuce",
                  "potato",
                  "tomato",
                  "garlic",
                  "chili"]
            }
            .drive(output.$vitamin)
            .disposed(by: disposeBag)
        
        input.selectProtein
            .withLatestFrom(output.$protein.asDriver()) {
                $1[$0]
            }
            .drive(selectProtein)
            .disposed(by: disposeBag)
        
        input.selectVitamin
            .withLatestFrom(output.$vitamin.asDriver()) {
                $1[$0]
            }
            .drive(selectVitamin)
            .disposed(by: disposeBag)
        
        input.tapProteinButton
            .withLatestFrom(selectProtein.asDriver())
            .drive {
                var data = output.dataTable
                if !data.contains($0) {
                    data.append($0)
                    output.$dataTable.accept(data)
                }
            }
            .disposed(by: disposeBag)
        
        input.tapVitaminButton
            .withLatestFrom(selectVitamin.asDriver())
            .drive {
                var data = output.dataTable
                if !data.contains($0) {
                    data.append($0)
                    output.$dataTable.accept(data)
                }
            }
            .disposed(by: disposeBag)
        
        input.searchTrigger
            .withLatestFrom(output.$dataTable.asDriver()) { _, datas in
                datas.joined(separator: ",")
            }
            .drive { navigator.goSearchView(query: $0) }
            .disposed(by: disposeBag)
        
        input.itemWillRemove
            .drive { (text) in
                output.$dataTable.accept(output.dataTable.filter { $0 != text })
        }
        .disposed(by: disposeBag)
        
        return output
    }
}
