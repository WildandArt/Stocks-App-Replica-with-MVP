//
//  SearchResultVC.swift
//  Stocks App Replica with MVP
//
//  Created by Artemy Ozerski on 06/12/2022.
//

import UIKit

class SearchResultVC: UIViewController {
    var results = [SearchResult]()
    weak var searchDelegate : searchResultDelegate?

    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    func updateWithResults(results : [SearchResult]){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.results = results
            self.tableView.reloadData()
        }
    }
    func setupViews(){
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
extension SearchResultVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as? SearchCell else {fatalError("Cell reuse error")}
        var conf = cell.defaultContentConfiguration()
        conf.text = "\(results[indexPath.row].symbol)"
        cell.contentConfiguration = conf
        return cell
    }
}
