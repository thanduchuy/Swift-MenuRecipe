//
//  OrderPlacedViewController.swift
//  LookingMenuRX
//
//  Created by than.duc.huy on 13/04/2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Then
import MGArchitecture
import Reusable
import NSObject_Rx
import ESPullToRefresh

final class OrderPlacedViewController: UIViewController, Bindable {
    var viewModel: OrderPlacedViewModel!
    @IBOutlet weak var orderPlaceCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    func bindViewModel() {
        let input = OrderPlacedViewModel.Input(loadView: Driver.just(()))
        
        let output = viewModel.transform(input, disposeBag: rx.disposeBag)
        
        output.$orderPlaces
            .asDriver()
            .drive(orderPlaceCollectionView.rx.items) { collectionView, index, item in
                collectionView.dequeueReusableCell(
                    for: IndexPath(item: index, section: 0),
                    cellType: OrderPlacedCell.self)
                    .then {
                        $0.configCell(order: item)
                    }
            }
            .disposed(by: rx.disposeBag)
        
        orderPlaceCollectionView
            .rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)
        
        output.$loading
            .asDriver()
            .drive(rx.isLoading)
            .disposed(by: rx.disposeBag)
    }
}

extension OrderPlacedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width - 32, height: 130)
    }
}

extension OrderPlacedViewController {
    func configView() {
        configCollectionView()
    }
    
    func configCollectionView() {
        orderPlaceCollectionView.do {
            $0.register(cellType: OrderPlacedCell.self)
        }
    }
}

extension OrderPlacedViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = StoryBoardReference.oder.storyBoard
}
