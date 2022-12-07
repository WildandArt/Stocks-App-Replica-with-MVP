//
//  MainViewCell.swift
//  Stocks App Replica with MVP
//
//  Created by Artemy Ozerski on 07/12/2022.
//

import UIKit

class MainViewCell: UITableViewCell {

    static let identifier = String(describing: MainViewCell.self)

    var symbolLabel : UILabel = {
        var label =  UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var chartView : UIView = {
        var chartView = UIView()
        chartView.backgroundColor = .blue
        chartView.translatesAutoresizingMaskIntoConstraints = false

        return chartView
    }()
    var priceLabel : UILabel = {
        var label =  UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        configureConstraints()

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureViews(){
        contentView.addSubviews(views: symbolLabel, priceLabel)
    }
    func configureConstraints(){
        NSLayoutConstraint.activate([
            symbolLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            symbolLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)

//            chartView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            chartView.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor)
        ])

    }

}
