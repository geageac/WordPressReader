//
//  Sources.swift
//  LNPopupControllerExample
//
//  Created by Tezz on 1/7/20.
//  Copyright © 2020 Leo Natan. All rights reserved.
//

import Foundation
import UIKit

class SourcesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let tableview: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.addBlur()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        title = "Sources"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: nil)
    }

    func setupTableView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        view.addSubview(tableview)
        
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableview.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableview.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
        tableview.tableFooterView = UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        return sites.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentSite = sites[indexPath.row]
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 2
        let cell = tableview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
        let imageView = UIImageView()
        let source = sites[indexPath.row]
        if let url = URL(string: source.logoURL!) {
            imageView.contentMode = .scaleAspectFit
            imageView.sd_setImage(with: url, completed: nil)
            imageView.image = imageView.image?.maskWithColor(color: .systemPink)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
        stackView.addArrangedSubview(imageView)
        cell.addSubview(stackView)
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

class SourceCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
