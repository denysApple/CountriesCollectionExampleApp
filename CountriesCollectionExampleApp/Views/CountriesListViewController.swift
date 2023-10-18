//
//  RubriqueCollectionViewController.swift
//  CountriesCollectionExampleApp
//
//  Created by Denys on 17.10.2023.
//

import UIKit
import Combine

final class CountriesListViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    var viewModel = CountriesListViewModel()
    var collectionView: UICollectionView!
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("Confirm", for: .normal)
        button.backgroundColor = .purple
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func loadView() {
        super.loadView()
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CountryCollectionCell.self,
                                forCellWithReuseIdentifier: CountryCollectionCell.reuseId)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        view.addSubview(confirmButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.$sections.sink { [weak self] _ in
            self?.collectionView.reloadData()
        }
        .store(in: &cancellables)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, 
                                                            action: #selector(handleLongGesture(gesture:)))
        collectionView.addGestureRecognizer(longPressGesture)
        confirmButton.addTarget(self, action: #selector(didTapConfirm), for: .touchUpInside)
        
        setupLayout()
    }
    
    private func setupLayout() {
        let resetButton = UIBarButtonItem(title: "Reset",
                                          style: .plain,
                                          target: self,
                                          action: #selector(resetButtonTapped))
        navigationItem.rightBarButtonItem = resetButton
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

//MARK: COLLECTION VIEW DELEGATES

extension CountriesListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CountryCollectionCell.reuseId,
            for: indexPath
        ) as! CountryCollectionCell
        cell.configure(with: viewModel.sections[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        moveItemAt sourceIndexPath: IndexPath,
                        to destinationIndexPath: IndexPath) {
        let item = viewModel.sections.remove(at: sourceIndexPath.item)
        viewModel.sections.insert(item, at: destinationIndexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        didSelectItemAt indexPath: IndexPath) {
        viewModel.sections[indexPath.row].isSelected.toggle()
        collectionView.reloadData()
    }
}

//MARK: ACTIONS

private extension CountriesListViewController {
    @objc func didTapConfirm() {
        let selectedTags = viewModel.sections.filter { $0.isSelected }.count
        if selectedTags < 3 {
            let alert = UIAlertController(title: "Error", message: "Please select at least three tags.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            print("SUCCESS!")
            // Handle the next steps after confirming the selection
        }
    }
    
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(
                at: gesture.location(in: collectionView)
            )
            else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            guard let gestureView = gesture.view else { return }
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gestureView))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    @objc func resetButtonTapped() {
        viewModel.resetToOriginal()
    }
}
