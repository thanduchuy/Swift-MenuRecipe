import Foundation
import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD
import RealmSwift

extension Reactive where Base: UIViewController {
    var isLoading: Binder<Bool> {
        return Binder(base) { viewController, isLoading in
            if isLoading {
                let hud = MBProgressHUD.showAdded(to: viewController.view, animated: true)
                hud.offset.y = -30
            } else {
                MBProgressHUD.hide(for: viewController.view, animated: true)
            }
        }
    }
}

extension UIViewController {
    func showAlert(title: String,
                   message: String,
                   style: UIAlertController.Style) {
        let alert = UIAlertController
            .createDefaultAlert(title: title, message: message, style: style)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertAgree(title: String,
                   message: String,
                   style: UIAlertController.Style) -> Observable<Bool>{
        return Observable.create { [unowned self] observer in
            let alert = UIAlertController.createDefaultAlert(title: title,
                                                             message: message,
                                                             style: style)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {  action in
                observer.onNext(true)
                observer.onCompleted()
            }))
            
            present(alert, animated: true, completion: nil)
            
            return Disposables.create {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func showAlertTextField(recipes: [RecipeSession]) -> Observable<Diet> {
        return Observable.create { [unowned self] observer in
            let alert = UIAlertController.createDefaultAlert(title: "Agree Add Diet ? ",
                                                             message: "What's name diet?",
                                                             style: .alert)
            
            alert.addTextField(configurationHandler: { textField in
                textField.placeholder = "Input diet name here..."
            })
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {  action in
                if let name = alert.textFields?.first?.text {
                    let diet = Diet()
                    let list = List<RecipeSession>()
                    
                    recipes.forEach {
                        list.append($0)
                    }
                    
                    diet.name = name
                    diet.recipeSessions = list
                    observer.onNext(diet)
                    observer.onCompleted()
                }
            }))
            
            present(alert, animated: true, completion: nil)
            
            return Disposables.create {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
}
