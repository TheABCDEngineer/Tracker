import UIKit

class CategorySetterViewController: UIViewController {
    
    private var initCategory: TrackerCategory?
    
    private let presenter = Creator.injectCategorySetterPresenter()
    
    private let dataProvoder = Creator.injectCategoryDataProvider()

    private var categoryCollection: UICollectionView!
    
    private let placeholder = Placeholder()
    
    private var addCategoryButton: UIButton!
    
    private var selectedIndexPathForContextMenu: IndexPath?
    
    private var onSetCategory: ( (TrackerCategory?) -> Void )?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureCollectionView()
        setObservers()
        
        dataProvoder.setDelegate(self)
        presenter.onViewLoaded()
    }
    
    func setInitCategory(_ category: TrackerCategory?) {
        self.initCategory = category
    }
    
    func onSetCategory(_ completion: @escaping (TrackerCategory?) -> Void) {
        self.onSetCategory = completion
    }
    
    private func updateScreenState(_ state: CategorySetterScreen.State) {
        placeholder.view.isHidden = !state.placeholderVisibility
    }
    
    private func setObservers() {
        presenter.observeScreenState {[weak self] state in
            guard let self, let state else { return }
            updateScreenState(state)
        }
    }
    
    @objc
    private func onAddCategoryButtonClick() {
        launchCategoryCreator()
    }
    
    private func launchCategoryCreator(_ modifyingCategory: TrackerCategory? = nil) {
        let controller = CategoryCreatorViewController()
        controller.setCategoryIfModify(modifyingCategory)
        controller.onCreateCategoryRequest {[weak self] categoryTitle in
            guard let self else { return }
            let newCategory = dataProvoder.addCategory(title: categoryTitle)
            initCategory = newCategory
            self.onSetCategory?(newCategory)
            self.dismiss(animated: false)
        }
        self.present(controller, animated: true)
    }
    
    private func configureLayout() {
        categoryCollection = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        
        addCategoryButton = UIButton.systemButton(
            with: UIImage(), target: nil, action: #selector(onAddCategoryButtonClick)
        )
        
        self.view = setupLayout(
            for: self.view,
            categoryCollection: categoryCollection,
            placeholder: placeholder,
            addCategoryButton: addCategoryButton
        )
    }
    
    private func configureCollectionView() {
        categoryCollection.dataSource = self
        categoryCollection.delegate = self
        
        categoryCollection.register(
            CategoryCell.self,
            forCellWithReuseIdentifier: CategoryCell.identifier
        )
        
        categoryCollection.register(
            TitleSupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TitleSupplementaryView.identifier
        )
        
        categoryCollection.register(
            TitleSupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: TitleSupplementaryView.identifier
        )
    }
}

//MARK: - UICollectionViewDataSource
extension CategorySetterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int
    ) -> Int {
        return dataProvoder.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let itemsCount = collectionView.numberOfItems(inSection: indexPath.section)
        
        guard let
            cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CategoryCell.identifier,
                    for: indexPath
            ) as? CategoryCell else {
                return UICollectionViewCell()
            }

        if itemsCount == 0 { return cell }
        guard let category = dataProvoder.object(at: indexPath) else { return cell }
        
        cell.setDelegates(cellDelegate: self, contextMenuDelegate: self)
        cell.setCategory(category)
        
        if let initCategory {
            if initCategory.id == category.id {
                cell.check()
            }
        }
        
        if itemsCount == 1 {
            cell.initCell(.single)
            return cell
        }
        
        switch indexPath.item {
        case 0:
            cell.initCell(.first)
        case itemsCount - 1:
            cell.initCell(.last)
        default:
            cell.initCell(.regular)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let element = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleSupplementaryView.identifier, for: indexPath) as? TitleSupplementaryView else {
            return UICollectionReusableView()
        }
        
        if kind == UICollectionView.elementKindSectionHeader {
            element.label.text = "Категория"
        }
        
        return element
    }
}

//MARK: - CategorySetterCellDelegate
extension CategorySetterViewController: CategorySetterCellDelegate {
    func setChekedCategory(_ category: TrackerCategory) {
        onSetCategory?(category)
        dismiss(animated: true)
    }
}

//MARK: - UICollectionViewDelegate
extension CategorySetterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath
    ) -> Bool {
        selectedIndexPathForContextMenu = indexPath
        return true
    }
}

//MARK: - CategoryDataProviderDelegate
extension CategorySetterViewController: CategoryDataProviderDelegate {
    func update(handleType: ItemHandleType,
                indexPath: IndexPath,
                indexPathForReconfigure: IndexPath?,
                reconfiguredCellType: SettingsMenuCellType
    ) {
        categoryCollection.performBatchUpdates {
            if handleType == .insert { categoryCollection.insertItems(at: [indexPath]) }
            if handleType == .delete { categoryCollection.deleteItems(at: [indexPath]) }
        }
                
        guard let indexPathForReconfigure else { return }
        guard let reconfiguredCell = categoryCollection.cellForItem(at: indexPathForReconfigure) as? CategoryCell else { return }
        
        reconfiguredCell.prepareForReuse()
        reconfiguredCell.initCell(reconfiguredCellType)
    }
}

//MARK: - UIContextMenuInteractionDelegate
extension CategorySetterViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint
    ) -> UIContextMenuConfiguration? {
        return ContextMenuConfigurator.setupMenu(
            alertPresenter: self,
            editAction: { [weak self] in
                guard let self else { return }
                guard let indexPath = self.selectedIndexPathForContextMenu else { return }
                guard let category = self.dataProvoder.object(at: indexPath) else { return }
                self.launchCategoryCreator(category)
            },
            removeMessage: "Эта категория точно не нужна?",
            removeAction: { [weak self] in
                guard let self else { return }
                guard let indexPath = self.selectedIndexPathForContextMenu else { return }
                guard let deletedCategory = self.dataProvoder.object(at: indexPath) else { return }
                if self.dataProvoder.removeCategory(at: indexPath) {
                    if self.initCategory?.id == deletedCategory.id {
                        self.initCategory = nil
                        self.onSetCategory?(nil)
                        if self.dataProvoder.numberOfItems() == 0 {
                            self.presenter.onViewLoaded()
                        }
                    }
                } else {
                    let categoryTitle = self.dataProvoder.object(at: indexPath)?.title ?? ""
                    AlertController.showNotification(
                        alertPresenter: self,
                        title: "Невозможно удалить категорию!",
                        message: "Категория \(categoryTitle) содержит трекеры.\nЧтобы удалить эту категорию сначала необходимо переместить из неё все трекеры"
                    )
                }
            }
        )
    }
}

//MARK: - AlertPresenterProtocol
extension CategorySetterViewController: AlertPresenterProtocol {
    func present(alert: UIAlertController, animated: Bool) {
        self.present(alert, animated: animated)
    }
}
