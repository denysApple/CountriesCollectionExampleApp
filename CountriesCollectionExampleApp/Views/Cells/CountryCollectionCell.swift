//
//  CustomCollectionViewCell.swift
//  CountriesCollectionExampleApp
//
//  Created by Denys on 17.10.2023.
//

import Foundation
import UIKit

final class CountryCollectionCell: UICollectionViewCell {
    static let reuseId = "countryCell"
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let checkBox: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle")
        imageView.tintColor = .blue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let handle: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "line.horizontal.3") // Using SF Symbols for handle
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func configure(with section: Rubrique) {
        titleLabel.text = section.title
        if section.isSelected {
            checkBox.image = UIImage(systemName: "checkmark.circle.fill")
            checkBox.tintColor = .blue
        } else {
            checkBox.image = UIImage(systemName: "circle")
            checkBox.tintColor = .gray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(checkBox)
        addSubview(titleLabel)
        addSubview(handle)
        addSubview(separator)
        
        // Constraints
        NSLayoutConstraint.activate([
            checkBox.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            checkBox.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkBox.heightAnchor.constraint(equalToConstant: 24),
            checkBox.widthAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            handle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            handle.centerYAnchor.constraint(equalTo: centerYAnchor),
            handle.heightAnchor.constraint(equalToConstant: 24),
            handle.widthAnchor.constraint(equalToConstant: 24),
            
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            separator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}
