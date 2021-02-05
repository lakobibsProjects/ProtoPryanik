//
//  MainViewController.swift
//  ProtoPryanik
//
//  Created by user166683 on 2/3/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import Kingfisher

class MainViewController: UIViewController {
    weak var coordinator: MainCoordinator?
    var vm: MainViewModel!
    private let disposeBag = DisposeBag()
    
    var table: UITableView!
    var descriptionPlug: UIView!
    var descriptionView: UIView!
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    private var nameLabel: UILabel!
    private var contentView: UIView!
    private var doneButton: UIButton!
    private var textLabel: UILabel!
    private var pictureImage: UIImageView!
    private var selectorTableView: UITableView!
    private var selectedChoiseLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVC()
    }
    
    
    //MARK: - Support Functions
    ///setup all views
    private func setupVC(){
        initViews()
        setupViews()
        setupConstraints()
    }
    
    ///initialization and set default state for view and each subview
    private func initViews(){
        self.view.backgroundColor = .lightGray
        self.navigationController?.title = vm.title
        
        table = UITableView()
        table.delegate = self
        table.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        table.register(PryanikTableViewCell.self, forCellReuseIdentifier: "PryanikTableViewCell")
        table.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                let cell = self?.table.cellForRow(at: indexPath) as! PryanikTableViewCell
                if let data = cell.data{
                    self?.descriptionPlug.isHidden = false
                    self?.configureDescription(with: data)
                }
            }).disposed(by: disposeBag)
        
        vm.data.bind(to: table.rx.items(cellIdentifier: "PryanikTableViewCell", cellType: PryanikTableViewCell.self)) {  (row,data,cell) in
            cell.configureCell(with: data)
        }.disposed(by: disposeBag)
        
        table.rx.willDisplayCell
            .subscribe(onNext: ({ (cell,indexPath) in
                cell.alpha = 0
                let transform = CATransform3DTranslate(CATransform3DIdentity, 0, -250, 0)
                cell.layer.transform = transform
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    cell.alpha = 1
                    cell.layer.transform = CATransform3DIdentity
                }, completion: nil)
            })).disposed(by: disposeBag)
        
        //description on table tap
        descriptionPlug = UIView()
        descriptionPlug.isHidden = true
        descriptionPlug.backgroundColor = #colorLiteral(red: 0.7233502538, green: 0.7233502538, blue: 0.7233502538, alpha: 0.33)
        descriptionView = UIView()
        descriptionView.backgroundColor = .darkGray
        
        contentView = UIView()
        contentView.layer.cornerRadius = 8
        nameLabel = UILabel()
        doneButton = UIButton()
        textLabel = UILabel()
        textLabel.numberOfLines = 0
        pictureImage = UIImageView()
        pictureImage.contentMode = .scaleAspectFit
        selectedChoiseLabel = UILabel()
        selectorTableView = UITableView()
        selectorTableView.delegate = self
        selectorTableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        selectorTableView.register(SelectorTableViewCell.self, forCellReuseIdentifier: "SelectorTableViewCell")
        selectorTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                let cell = self?.selectorTableView.cellForRow(at: indexPath) as! SelectorTableViewCell
                if let data = cell.data{
                    self?.selectedChoiseLabel.text = "Selected id: \(data.id)"
                }
            }).disposed(by: disposeBag)
        
        vm.selection.bind(to: selectorTableView.rx.items(cellIdentifier: "SelectorTableViewCell", cellType: SelectorTableViewCell.self)){  (row, variants, cell) in
            cell.configureCell(with: variants)
        }
        
        selectorTableView.rx.willDisplayCell
            .subscribe(onNext: ({ (cell,indexPath) in
                cell.alpha = 0
                let transform = CATransform3DTranslate(CATransform3DIdentity, 0, -250, 0)
                cell.layer.transform = transform
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    cell.alpha = 1
                    cell.layer.transform = CATransform3DIdentity
                }, completion: nil)
            })).disposed(by: disposeBag)
        
        //Activity indicator
        activityIndicator.center = CGPoint(x: view.frame.size.width*0.5, y: view.frame.size.height*0.5)
        activityIndicator.startAnimating()
        vm?.showLoading.asObservable().observeOn(MainScheduler.instance).bind(to: activityIndicator.rx.isHidden).disposed(by: disposeBag)
    }
    
    //cofigure content of descriptionView independ of PryanikDataType
    func configureDescription(with data: Datum){
        nameLabel.text = data.name
        doneButton.layer.cornerRadius = 8
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        if let type = data.type{
            switch type {
            case .hz:
                setupHz(with: data.data)
            case .selector:
                setupSelector(with: data.data)
            case .picture:
                setupPicture(with: data.data)
            }
        }
    }
    
    //MARK: - DescriptionView change
    private func setupHz(with data: DataClass){
        if let text = data.text{
            textLabel.text = text
        }
        contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
    
    private func setupSelector(with data: DataClass){
        selectedChoiseLabel.text = "Selected id: "
        contentView.addSubview(selectedChoiseLabel)
        contentView.addSubview(selectorTableView)
        self.view.layoutIfNeeded()
        let tableHieight = selectorTableView.numberOfRows(inSection: 0) * 53
        let viewHeight = tableHieight + 128
        descriptionView.snp.removeConstraints()
        descriptionView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.greaterThanOrEqualTo(viewHeight)
        })
        
        selectedChoiseLabel.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(32)
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
        })
        
        selectorTableView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.height.greaterThanOrEqualTo(tableHieight)
            $0.top.equalTo(selectedChoiseLabel.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().inset(64)
        })
    }
    
    private func setupPicture(with data: DataClass){
        if let text = data.text{
            textLabel.text = text
        }
        
        if let url = data.url{
            pictureImage.kf.indicatorType = .activity
            pictureImage.kf.setImage(with: ImageResource(downloadURL: URL(fileURLWithPath: url)), placeholder: UIImage(named: "placeholderImage")){ result in
                switch result {
                case .success(let value):
                    print("Image: \(value.image). Got from: \(value.cacheType)")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
        
        contentView.addSubview(textLabel)
        contentView.addSubview(pictureImage)
        textLabel.snp.makeConstraints({
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(32)
        })
        pictureImage.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(doneButton.snp.top).offset(8)
            $0.top.equalTo(textLabel.snp.bottom).offset(8)
            $0.height.greaterThanOrEqualTo(64)
        })
        descriptionView.snp.removeConstraints()
        descriptionView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.greaterThanOrEqualTo(168)
        })
        self.view.setNeedsLayout()
    }
    
    //MARK: - Event Handlers
    @objc private func doneButtonPressed(){
        self.descriptionPlug.isHidden = true
        self.contentView.subviews.map({ $0.removeFromSuperview() })
        descriptionView.snp.removeConstraints()
        descriptionView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(128)
        })
        self.view.setNeedsLayout()
    }
}

//MARK: - Layout
extension MainViewController{
    ///setup hierarchy of views
    private func setupViews(){
        self.view.addSubview(table)
        self.view.addSubview(descriptionPlug)
        
        descriptionPlug.addSubview(descriptionView)
        
        descriptionView.addSubview(nameLabel)
        descriptionView.addSubview(contentView)
        descriptionView.addSubview(doneButton)
    }
    
    ///set constraints for all views
    private func setupConstraints(){
        table.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(32)
            $0.top.equalToSuperview().inset(128)
        })
        
        descriptionPlug.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(32)
            $0.top.equalToSuperview().inset(128)
        })
        
        descriptionView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.greaterThanOrEqualTo(128)
        })
        
        nameLabel.snp.makeConstraints({
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(32)
        })
        
        contentView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.height.greaterThanOrEqualTo(32)
        })
        
        doneButton.snp.makeConstraints({
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(2)
            $0.height.equalTo(48)
        })
    }
}

//MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate{   
}
