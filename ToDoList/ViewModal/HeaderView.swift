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
    
    func dismissToDoVC(_ view : HeaderView)
    
    func queryOfItemInList(_ view : HeaderView , with title : String)
    
    func toShowOriginalItemList(_ view : HeaderView)
}

class HeaderView : UIView {
    
    public var label : UILabel = {
       let label = UILabel()
        label.text = "ToDo Items"
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.backgroundColor = .systemGray6
        return label
    }()
    
    public var addItem : UIButton = {
       let button = UIButton()
        button.setTitle("+", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGray3
        button.titleLabel?.font = .systemFont(ofSize: 40, weight: .medium)
        button.addTarget(self, action: #selector(addItemOnList), for: .touchUpInside)
        return button
    }()
    
    public var back : UIButton = {
        let button = UIButton()
         button.setTitle("Back", for: .normal)
         button.translatesAutoresizingMaskIntoConstraints = false
         button.backgroundColor = .systemGray3
         button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
         button.addTarget(self, action: #selector(backToCategoryVC), for: .touchUpInside)
         return button
    }()
    
    public var searchBar : UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.placeholder = "Search..."
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.becomeFirstResponder()
        return searchBar
    }()
    
    var delegate : HeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        addSubview(addItem)
        addSubview(searchBar)
        addSubview(back)
        searchBar.delegate = self
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: This function handling constraints for all components in HeaderView
    
    func applyConstraints(){
        let addItemConstraints = [
            addItem.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            addItem.topAnchor.constraint(equalTo: topAnchor, constant: 25),
            addItem.heightAnchor.constraint(equalToConstant: 40),
            addItem.widthAnchor.constraint(equalToConstant: 40)
        ]
        
        let searchBarConstraints = [
            searchBar.topAnchor.constraint(equalTo: topAnchor, constant: 80),
            searchBar.widthAnchor.constraint(equalToConstant: bounds.width)
        ]
        
        let labelConstraints = [
            label.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            label.widthAnchor.constraint(equalToConstant: bounds.width),
            label.heightAnchor.constraint(equalToConstant: 80)
        ]
        
        let backButtonConstraints = [
            back.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            back.leftAnchor.constraint(equalTo: leftAnchor, constant: 5)
        ]
        NSLayoutConstraint.activate(addItemConstraints)
        NSLayoutConstraint.activate(searchBarConstraints)
        NSLayoutConstraint.activate(labelConstraints)
        NSLayoutConstraint.activate(backButtonConstraints)
    }
    
    @objc func addItemOnList(){
        delegate?.addItemOnListAndReLoadList(self)
    }
    
    @objc func backToCategoryVC(){
        delegate?.dismissToDoVC(self)
    }
}

//MARK: - Extension to handle all the methods related with UISearchBar

extension HeaderView : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let title = searchBar.text else {return}
        delegate?.queryOfItemInList(self, with: title)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            DispatchQueue.main.async { [self] in
                searchBar.resignFirstResponder()
                delegate?.toShowOriginalItemList(self)
            }
        }
    }
}
