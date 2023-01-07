//
//  CategoryHeaderView.swift
//  ToDoList
//
//  Created by Rohit Sharma on 06/01/23.
//

import Foundation
import UIKit


protocol CategoryHeaderViewDelegate {
    func addCategoryOnListAndReLoadList(_ view : CategoryHeaderView)
}

class CategoryHeaderView : UIView {
    
    private var label : UILabel = {
       let label = UILabel()
        label.text = "Todo App"
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
    
    var delegate : CategoryHeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        addSubview(addItem)
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func applyConstraints(){
        let addItemConstraints = [
            addItem.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            addItem.topAnchor.constraint(equalTo: topAnchor, constant: 25),
            addItem.heightAnchor.constraint(equalToConstant: 40),
            addItem.widthAnchor.constraint(equalToConstant: 40)
        ]
        
        let labelConstraints = [
            label.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            label.widthAnchor.constraint(equalToConstant: bounds.width),
            label.heightAnchor.constraint(equalToConstant: 80)
        ]
        NSLayoutConstraint.activate(addItemConstraints)
        NSLayoutConstraint.activate(labelConstraints)
    }
    
    @objc func addItemOnList(){
        delegate?.addCategoryOnListAndReLoadList(self)
    }
}
