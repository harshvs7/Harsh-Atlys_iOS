//
//  ViewController.swift
//  AtlysAssignment
//
//  Created by Harshvardhan Sharma on 16/10/24.
//

import UIKit

class ViewController: UIViewController {
    
    // Array containing the images
    //Compact Map was added to make sure there are no optional in this array, so that i can be passed into initialisers
    private var imagesArray = [UIImage(named: "photo1"), UIImage(named: "photo2"), UIImage(named: "photo3")].compactMap { $0 }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
}

//MARK: I tend to make extensions for similar functions for code modularity
extension ViewController {
    
    //Using function to setup UI so viewDidLoad is consise
    private func setupUI() {
        // Setting up the carousel view using initialiser
        let carouselView = CarouselView(images: self.imagesArray)
        self.view.backgroundColor = .white
        self.view.addSubview(carouselView)
        
        // Set up the constraints
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            carouselView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            carouselView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            carouselView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9), // Adjust width to 90% of the screen
            carouselView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.4) // Adjust height to 40% of the screen
        ])
    }
}
