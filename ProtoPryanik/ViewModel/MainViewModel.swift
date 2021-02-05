//
//  MainViewModel.swift
//  ProtoPryanik
//
//  Created by user166683 on 2/3/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel: PryanikRequestObserver{
    var id: Int = 1
    ///Collection of data
    var data: PublishSubject<[Datum]> = PublishSubject<[Datum]>()
    ///Collection of selection
    var selection: PublishSubject<[Variant]> = PublishSubject<[Variant]>()
    ///Indicator of loading process
    var showLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: true)
    ///Title for VC
    var title: String = "Pryanik"
    
    init(){
        PryanikRequestService.shared.attach(self)
        PryanikRequestService.shared.getPryanik()
        showLoading.accept(true)
    }
    
    //TODO: remove force unwrapping
    func update(data: Pryanik) {
        self.data.onNext(data.data)
        for item in data.data{
            if item.type == PryanikDataType.selector{
                selection.onNext(item.data.variants!)
            }
        }
        showLoading.accept(false)
    }
}
