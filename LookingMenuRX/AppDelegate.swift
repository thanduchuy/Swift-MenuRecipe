import UIKit
import RxCocoa
import RxSwift
import MGArchitecture
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        FirebaseApp.configure()
        bindViewModel()
        return true
    }
    
    private func bindViewModel() {
        guard let window = window else { return }
        let navigator = AppNavigator(window: window)
        let viewModel = AppViewModel(navigator: navigator)
        let input = AppViewModel.Input(loadTrigger: Driver.just(()))
        let output = viewModel.transform(input, disposeBag: rx.disposeBag)
        output.toMain
            .drive()
            .disposed(by: rx.disposeBag)
    }
}
