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
    
    var searchDelegate: SearchDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func searchTapped(sender: UIButton) {
        let title = searchTextField.text ?? " "
        searchDelegate?.search(withTitle: title)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelTapped(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }

}