//
//  SelectorTableViewCell.swift
//  ProtoPryanik
//
//  Created by user166683 on 2/4/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import UIKit

class SelectorTableViewCell: UITableViewCell {
    var data: Variant?
    var title = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .gray
        self.layer.cornerRadius = 8
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    ///Configure content of cell
    ///
    /// - Parameter with: repo
    func configureCell(with data: Variant){
        self.data = data
        title.text = data.text
    }
    
    //MARK: - Support Functions
    ///setup all views
    private func setup(){
        initViews()
        setupViews()
        setupConstraints()
    }
    
    ///initialization and set default state for view and each subview
    private func initViews(){
        
    }
    
    ///setup hierarchy of views
    private func setupViews(){
        self.addSubview(title)
    }
    
    ///set constraints for all views
    private func setupConstraints(){
        title.snp.makeConstraints({
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(8)
        })
    }
}
