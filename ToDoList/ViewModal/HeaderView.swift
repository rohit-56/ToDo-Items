//
//  HeaderView.swift
//  ToDoList
//
//  Created by Rohit Sharma on 04/01/23.
//

import Foundation
import UIKit

protocol HeaderViewDelegate {
    
    func addItemOnListAndReLoadList(_ view : HeaderView)
}

class HeaderView : UIView {
    
    private var label : UILabel = {
       let label = UILabel()
        label.text = "ToDo Items"
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.backgroundColor = .systemGray6
        return label
    }()
    
    private var addItem : UIButton = {
       let button = UIButton()
        button.setTitle("+", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGray3
        button.titleLabel?.font = .systemFont(ofSize: 40, weight: .medium)
        button.addTarget(self, action: #selector(addItemOnList), for: .touchUpInside)
        return button
    }()
    
    var delegate : HeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        addSubview(addItem)
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    
    func applyConstraints(){
        let addItemConstraints = [
            addItem.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            addItem.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            addItem.heightAnchor.constraint(equalToConstant: 50),
            addItem.widthAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(addItemConstraints)
    }
    
    @objc func addItemOnList(){
        delegate?.addItemOnListAndReLoadList(self)
    }
}
