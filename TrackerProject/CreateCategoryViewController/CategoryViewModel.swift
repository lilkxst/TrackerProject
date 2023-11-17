//
//  CreateCategoryViewModel.swift
//  TrackerProject
//
//  Created by Артём Костянко on 13.11.23.
//

import Foundation

protocol CategoryViewModelDelegate: AnyObject {
    func updateCategory(newCategoryTitle: String?)
}

final class CategoryViewModel {
    
    weak var delegate: CategoryViewModelDelegate?
    
    private let trackerCategoryStore = TrackerCategoryStore()
    
    @Observable
    private(set) var categories: [CategoryModel] = []
    
    @Observable
    private(set) var selectedCategory: CategoryModel?
    
    init() {
        categories = trackerCategoryStore.trackerCategories.map { CategoryModel(categoryName: $0.title) }
    }
    
    func selectCategory(category: String?) {
        guard let category else { return }
        selectedCategory = CategoryModel(categoryName: category)
        delegate?.updateCategory(newCategoryTitle: category)
    }
}

extension CategoryViewModel: CreateCategoryViewControllerDelegate {
    func updateNewCategory(newCategoryTitle: String) {
        let newCategory = CategoryModel(categoryName: newCategoryTitle)
        if !categories.contains(where: { $0.categoryName == newCategoryTitle } ) {
            categories.insert(newCategory, at: 0)
            try? trackerCategoryStore.saveNewTrackerCategory(categoryTitle: newCategoryTitle)
        }
        selectedCategory = newCategory
    }
}
