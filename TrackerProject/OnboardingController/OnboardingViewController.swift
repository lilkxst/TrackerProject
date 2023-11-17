//
//  OnboardingViewController.swift
//  TrackerProject
//
//  Created by Артём Костянко on 15.11.23.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    
    private lazy var pages: [UIViewController] = {
        var firstPage = OnboardingPageViewController(imageView: UIImage(named: "BlueOnboarding") ?? UIImage(), text: "Отслеживайте только то, что хотите")
        var secondPage = OnboardingPageViewController(imageView: UIImage(named: "RedOnboarding") ?? UIImage(), text: "Даже если это не литры воды и йога")
        return [firstPage, secondPage]
    }()
    
    private lazy var closeOnboardingButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "Black")
        button.setTitle("Вот это технологии!", for: .normal)
        button.setTitleColor(UIColor(named: "White"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapCloseOnboardingButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor(named: "Black")
        pageControl.pageIndicatorTintColor = UIColor(named: "")
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true)
        }
        
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(closeOnboardingButton)
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            closeOnboardingButton.heightAnchor.constraint(equalToConstant: 60),
            closeOnboardingButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            closeOnboardingButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            closeOnboardingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -134),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        closeOnboardingButton.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc private func didTapCloseOnboardingButton() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Unable create window")
        }
        window.rootViewController = TabBarController()
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
            return pages.last
        }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else {
            return pages.first
        }
        return pages[nextIndex]
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
