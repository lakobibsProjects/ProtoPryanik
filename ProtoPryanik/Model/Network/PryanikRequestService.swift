//
//  PryanikRequestService.swift
//  ProtoPryanik
//
//  Created by user166683 on 2/4/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import Foundation
import Alamofire

class PryanikRequestService{
    private let url = "https://pryaniky.com/static/json/sample.json"
    var userResponse: Pryanik?
    
    //singleton
    private init(){
        
    }
    
    static var shared: PryanikRequestService = {
        let instance = PryanikRequestService()
        return instance
    }()
    
    ///Find user and notify
    func getPryanik() {
        let request =  AF.request(url)
        request.responseDecodable(of: Pryanik.self) { (response) in
            print(response.error?.localizedDescription ?? "")
            guard let response = response.value else {
                print("fail to response user of url: \(self.url)")
                let dialogMessage = UIAlertController(title: "", message: "Somthing wrong in interaction with server when request info about user" , preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default)
                dialogMessage.addAction(ok)
                UIApplication.shared.windows.last?.rootViewController?.present(dialogMessage, animated: true)
                return }
            self.userResponse = response
            self.notify(data: response)
        }
    }
    
    //observerPattern
    var state: Int = { return Int(arc4random_uniform(10)) }()
    
    private lazy var observers = [PryanikRequestObserver]()
    
    func attach(_ observer: PryanikRequestObserver) {
        observers.append(observer)
    }
    
    func detach(_ observer: PryanikRequestObserver) {
        observers = observers.filter({$0.id != observer.id})
    }
    
    func notify(data: Pryanik) {
        observers.forEach({ $0.update(data: data)})
    }
}

protocol PryanikRequestObserver{
    var id: Int {get}
    func update(data: Pryanik)
}
