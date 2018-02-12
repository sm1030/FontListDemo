//
//  ViewController.swift
//  FontListDemo
//
//  Created by Alexandre Malkov on 11/02/2018.
//  Copyright © 2018 iosSolutionBox. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var previewTextFiled: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    let fullFontList = UIFont.getFullFontList()
    var tableData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        updateTableData()
        
        setupKeyboardObservers()
        setupViewTapGestureRecognizer()
    }

    func updateTableData() {
        if let filterText = searchTextField?.text?.lowercased() {
            if filterText.count > 0 {
                tableData = fullFontList.filter({ (fontName) -> Bool in
                    fontName.lowercased().contains(filterText)
                })
            } else {
                tableData = fullFontList
            }
            tableView?.reloadData()
        }
    }
    
    @IBAction func filterTextChanged(_ sender: UITextField) {
        updateTableData()
    }
    
    @IBAction func previewTextChanged(_ sender: UITextField) {
        updateTableData()
    }
    
}

/*
 This extension will handle tableView datasource
 **/
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fontName = tableData[indexPath.row]
        let previewText = (previewTextFiled.text?.count ?? 0) > 0 ? previewTextFiled.text! : ""
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.font = UIFont(name: fontName, size: 20)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.text = previewText.count > 0
            ? "\(fontName)\n\(previewText)"
            : fontName
        return cell
    }
}

/*
 This extension will handle tableView layout adjustment when keyboard appear/disappear
 **/
extension ViewController {
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver( self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver( self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func setupViewTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(handleViewTap(sender:)))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleKeyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            tableViewBottomConstraint.constant = -keyboardRectangle.height
        }
    }
    
    @objc func handleKeyboardWillHide(_ notification: Notification) {
        tableViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.5, animations: { self.view.layoutIfNeeded() })
    }
    
    @objc func handleViewTap(sender: UITapGestureRecognizer) {
        searchTextField.resignFirstResponder()
        previewTextFiled.resignFirstResponder()
    }
}

