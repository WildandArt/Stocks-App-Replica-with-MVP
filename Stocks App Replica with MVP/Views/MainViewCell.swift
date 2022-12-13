//
//  MainViewCell.swift
//  Stocks App Replica with MVP
//
//  Created by Artemy Ozerski on 07/12/2022.
//

import UIKit

class MainViewCell: UITableViewCell {

    static let identifier = String(describing: MainViewCell.self)
    var changeColor : UIColor?
    lazy var priceStackView : UIStackView = {
        let stackV = UIStackView()
        stackV.axis = .vertical
        stackV.alignment = .trailing
        stackV.distribution = .equalCentering
        stackV.addArrangedSubview(priceLabel)
        stackV.addArrangedSubview(priceChangeLabel)
        stackV.translatesAutoresizingMaskIntoConstraints = false

        return stackV
    }()

    var symbolLabel : UILabel = {
        var label =  UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var priceChangeLabel : UILabel = {
        var label =  UILabel()
        label.textAlignment = .center
        label.textColor = .label
        label.numberOfLines = 0
        //label.backgroundColor = .systemGreen
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        label.font = .systemFont(ofSize: 13, weight: .semibold)
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
        contentView.addSubviews(views: symbolLabel, priceStackView)
    }
    func configureConstraints(){
        NSLayoutConstraint.activate([
            symbolLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            symbolLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            priceChangeLabel.widthAnchor.constraint(equalToConstant: 60),
            priceChangeLabel.heightAnchor.constraint(equalToConstant: 20),

            priceStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            priceStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
//            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)

//            chartView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            chartView.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor)
        ])
    }

}
