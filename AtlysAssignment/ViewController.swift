//
//  ViewController.swift
//  AtlysAssignment
//
//  Created by Harshvardhan Sharma on 16/10/24.
//

import UIKit

class ViewController: UIViewController {
    
    // Array of images
    private var imagesArray = [UIImage(named: "photo1"), UIImage(named: "photo2"), UIImage(named: "photo3")].compactMap { $0 }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the carousel view
        let carouselView = CarouselView(images: self.imagesArray)
        self.view.backgroundColor = .white
        self.view.addSubview(carouselView)
        
        // Enable Auto Layout for the carousel view
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up the constraints
        NSLayoutConstraint.activate([
            carouselView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            carouselView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            carouselView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9), // Adjust width to 90% of the screen
            carouselView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.4) // Adjust height to 40% of the screen
        ])
    }
}

