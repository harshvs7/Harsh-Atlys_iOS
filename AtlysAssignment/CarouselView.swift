//
//  CarouselView.swift
//  AtlysAssignment
//
//  Created by Harshvardhan Sharma on 16/10/24.
//

import UIKit

class CarouselView: UIView, UIScrollViewDelegate {

    private var scrollView: UIScrollView!
    private var stackView: UIStackView!
    private var pageControl: UIPageControl!
    private var images: [UIImage]

    private let imageWidth: CGFloat = 250 // Fixed width for images
    private let imageHeight: CGFloat = 150 // Fixed height for images
    private let scaleFactor: CGFloat = 1.2 // Scale factor for center image
    private let itemSpacing: CGFloat = 20 // Spacing between images

    private var currentPage: Int = 0 // Track current page

    init(images: [UIImage]) {
        self.images = images
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        // Initialize scrollView
        scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.bounces = false // Disable bouncing effect
        scrollView.decelerationRate = .fast // Faster deceleration for smoother scrolling
        addSubview(scrollView)

        // Add constraints to scrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Initialize stackView
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = itemSpacing // Add some space between images
        scrollView.addSubview(stackView)

        // Add constraints to stackView
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor) // Stack height matches scroll view
        ])

        // Add images to the stackView and disable user interaction on them
        for image in images {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 12
            imageView.isUserInteractionEnabled = false // Disable interactions on the images
            stackView.addArrangedSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false

            // Set image view constraints for fixed width and height
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: imageWidth), // Fixed width
                imageView.heightAnchor.constraint(equalToConstant: imageHeight) // Fixed height
            ])
        }

        // Initialize pageControl
        pageControl = UIPageControl()
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .systemBlue
        pageControl.pageIndicatorTintColor = .lightGray
        addSubview(pageControl)

        // Add constraints to pageControl
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 40)
        ])
    }

    // UIScrollViewDelegate method for scaling images based on center position
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = imageWidth + itemSpacing
        let centerX = scrollView.contentOffset.x + (scrollView.frame.size.width / 2)

        for view in stackView.arrangedSubviews {
            let distanceFromCenter = abs(centerX - view.center.x)

            // Scale images based on distance from the center
            let scale = max(1 - (distanceFromCenter / width), 0.75) * scaleFactor
            view.transform = CGAffineTransform(scaleX: scale, y: scale)

            // Adjust alpha for adjacent images
            let alpha = max(1 - (distanceFromCenter / (width * 1.5)), 0.5)
            view.alpha = alpha
        }
    }

    // Refined snapping logic with reduced swipe requirement
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let width = imageWidth + itemSpacing
        let targetX = targetContentOffset.pointee.x + scrollView.frame.size.width / 2

        // ** Lowering the threshold to require less swipe to snap to the next/previous image **
        var closestIndex = Int((targetX / width) + (velocity.x > 0 ? 0.3 : -0.3))  // Reduced swipe threshold

        // Ensure closest index stays within bounds
        closestIndex = max(0, min(closestIndex, images.count - 1))

        // ** Prevent wrap-around behavior at boundaries **
        if currentPage == 0 && velocity.x < 0 {
            // Prevent swiping left on the first image
            targetContentOffset.pointee.x = scrollView.contentOffset.x
            return
        }

        if currentPage == images.count - 1 && velocity.x > 0 {
            // Prevent swiping right on the last image (no skipping to the first)
            closestIndex = images.count - 1
        }

        // Snap to the closest image without skipping
        let targetOffset = CGFloat(closestIndex) * width - (scrollView.frame.size.width / 2) + (imageWidth / 2)
        targetContentOffset.pointee.x = targetOffset

        // Update page control and current page tracking
        pageControl.currentPage = closestIndex
        currentPage = closestIndex
    }

    // Update current page when scrolling stops
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = imageWidth + itemSpacing
        let pageIndex = Int(round(scrollView.contentOffset.x / width))
        pageControl.currentPage = pageIndex
        currentPage = pageIndex
    }

    // Ensure page control updates correctly when the user finishes dragging
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updateCurrentPage()
    }

    private func updateCurrentPage() {
        let width = imageWidth + itemSpacing
        let pageIndex = Int(round(scrollView.contentOffset.x / width))
        pageControl.currentPage = pageIndex
        currentPage = pageIndex
    }
}


