//
//  CarouselView.swift
//  AtlysAssignment
//
//  Created by Harshvardhan Sharma on 16/10/24.
//

import UIKit

class CarouselView: UIView {
    
    
    fileprivate var scrollView: UIScrollView  = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    fileprivate var stackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    fileprivate var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        return pageControl
    }()
    
    private var images: [UIImage]
    private let imageWidth: CGFloat = 250
    private let imageHeight: CGFloat = 150
    private let scaleFactor: CGFloat = 1.2
    private let itemSpacing: CGFloat = 20
    private var currentPage: Int = 0
    
    init(images: [UIImage]) {
        self.images = images
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CarouselView {
    
    //Setting up UI
    private func setupView() {
        scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.decelerationRate = .fast
        addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = itemSpacing
        scrollView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        for image in images {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 12
            imageView.isUserInteractionEnabled = false
            stackView.addArrangedSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: imageWidth),
                imageView.heightAnchor.constraint(equalToConstant: imageHeight)
            ])
        }
        
        pageControl = UIPageControl()
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .systemBlue
        pageControl.pageIndicatorTintColor = .lightGray
        addSubview(pageControl)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 40)
        ])
    }
    
    //Updating PageControl
    private func updateCurrentPage() {
        let width = imageWidth + itemSpacing
        let pageIndex = Int(round(scrollView.contentOffset.x / width))
        pageControl.currentPage = pageIndex
        currentPage = pageIndex
    }
}

extension CarouselView: UIScrollViewDelegate {

    //Delegate function for letting know scroll happened
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = imageWidth + itemSpacing
        let centerX = scrollView.contentOffset.x + (scrollView.frame.size.width / 2)

        for view in stackView.arrangedSubviews {
            let distanceFromCenter = abs(centerX - view.center.x)
            let scale = max(1 - (distanceFromCenter / width), 0.75) * scaleFactor
            view.transform = CGAffineTransform(scaleX: scale, y: scale)
            let alpha = max(1 - (distanceFromCenter / (width * 1.5)), 0.5)
            view.alpha = alpha
        }
    }

    //Delegate function to know scrolling is going to end
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let width = imageWidth + itemSpacing
        let targetX = targetContentOffset.pointee.x + scrollView.frame.size.width / 2
        var closestIndex = Int((targetX / width) + (velocity.x > 0 ? 0.3 : -0.3))
        closestIndex = max(0, min(closestIndex, images.count - 1))
        if currentPage == 0 && velocity.x < 0 {
            targetContentOffset.pointee.x = scrollView.contentOffset.x
            return
        }

        if currentPage == images.count - 1 && velocity.x > 0 {
            closestIndex = images.count - 1
        }

        let targetOffset = CGFloat(closestIndex) * width - (scrollView.frame.size.width / 2) + (imageWidth / 2)
        targetContentOffset.pointee.x = targetOffset

        pageControl.currentPage = closestIndex
        currentPage = closestIndex
    }

    //Delegate function to know scrolling did end
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = imageWidth + itemSpacing
        let pageIndex = Int(round(scrollView.contentOffset.x / width))
        pageControl.currentPage = pageIndex
        currentPage = pageIndex
    }

    //Delegate function to know the scrolling animation has ended
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updateCurrentPage()
    }
}


