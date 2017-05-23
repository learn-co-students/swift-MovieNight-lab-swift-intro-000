//
//  SearchViewController.swift
//  MovieSong
//
//  Created by Jim Campagno on 8/20/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import UIKit

protocol SearchDelegate {
    func search(withTitle title: String)
}

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var mainView: UIView!
    
    var searchDelegate: SearchDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.layer.cornerRadius = 10.0
        mainView.layer.masksToBounds = true
        searchTextField.returnKeyType = .search
        searchTextField.delegate = self
        searchTextField.becomeFirstResponder()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        gestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    func dismissView() {
        searchTextField.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    func search() {
        searchDelegate?.search(withTitle: searchTextField.text ?? " ")
        dismissView()
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        dismissView()
    }
    
}

// MARK: Text Field Delegate Methods

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search()
        return false
    }
    
}
