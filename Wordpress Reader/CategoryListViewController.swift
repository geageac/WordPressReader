//
//  CategoryListViewController.swift
//  Wordpress Reader
//
//  Created by Tezz on 1/9/20.
//  Copyright © 2020 UVC Media. All rights reserved.
//

import Foundation

class CategoryListViewController: UITableViewController {
    public var cachedCategories : [Category]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categories"
        view.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(tableCell.self, forCellReuseIdentifier: "tableCell")
        tableView.backgroundColor = .secondarySystemBackground
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cachedCategories!.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! tableCell
        let category = cachedCategories?[indexPath.row]
        cell.configureWith(category: category)
        cell.backgroundColor = .clear
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CategoryViewController()
        let cell = tableView.cellForRow(at: indexPath) as! tableCell
        vc.category = cell.category
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

class tableCell : UITableViewCell {
    var category: Category?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel?.font = UIFont.boldSystemFont(ofSize: textLabel?.font.pointSize ?? 22.0)
    }
    
    public func configureWith(category: Category?) {
        self.category = category
        if let c = category {
            textLabel?.text = c.name // + " ›"
        }
    }
}
