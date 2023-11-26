import UIKit

class CategorySetterViewController: UIViewController {
    
    private var initCategory: TrackerCategory?
    
    private let presenter = Creator.injectCategorySetterPresenter()

    private var categoryCollection: UICollectionView!
    
    private let placeholder = Placeholder()
    
    private var addCategoryButton: UIButton!
    
    private var selectedCategoryForContextMenu: TrackerCategory?
    
    private var onSetCategory: ( (TrackerCategory) -> Void )?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureCollectionView()
        setObservers()
        
        presenter.onViewLoaded()
    }
    
    func setInitCategory(_ category: TrackerCategory?) {
        self.initCategory = category
    }
    
    func onSetCategory(_ completion: @escaping (TrackerCategory) -> Void) {
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
        controller.onCategoryCreated {[weak self] category in
            guard let self else { return }
            initCategory = category
            self.categoryCollection.reloadData()
            self.onSetCategory?(category)
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
            forCellWithReuseIdentifier: CategoryCell.Identifier
        )
        
        categoryCollection.register(
            TitleSupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TitleSupplementaryView.Identifier
        )
        
        categoryCollection.register(
            TitleSupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: TitleSupplementaryView.Identifier
        )
    }
}

//MARK: - UICollectionViewDataSource
extension CategorySetterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int
    ) -> Int {
        return presenter.getCategoryList().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let categoryList = presenter.getCategoryList()
   
        guard let
            cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CategoryCell.Identifier,
                    for: indexPath
            ) as? CategoryCell else {
                return UICollectionViewCell()
            }
        if categoryList.isEmpty { return cell }
        
        cell.setDelegates(cellDelegate: self, contextMenuDelegate: self)
        cell.setCategory(categoryList[indexPath.item])
        
        if let initCategory {
            if initCategory.id == categoryList[indexPath.item].id {
                cell.check()
            }
        }
        
        if categoryList.count == 1 {
            cell.initCell(.single)
            return cell
        }
        
        switch indexPath.item {
        case 0:
            cell.initCell(.first)
        case categoryList.count - 1:
            cell.initCell(.last)
        default:
            cell.initCell(.regular)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let element = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleSupplementaryView.Identifier, for: indexPath) as? TitleSupplementaryView else {
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
        selectedCategoryForContextMenu = presenter.getCategoryList()[indexPath.item]
        return true
    }
}

//MARK: - UIContextMenuInteractionDelegate
extension CategorySetterViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint
    ) -> UIContextMenuConfiguration? {
        return ContextMenuConfigurator.setupMenu(
            alertPresenter: self,
            editAction: {
                guard let category = self.selectedCategoryForContextMenu else { return }
                self.launchCategoryCreator(category)
            },
            removeMessage: "Эта категория точно не нужна?",
            removeAction: {
                guard let category = self.selectedCategoryForContextMenu else { return }
                if self.presenter.removeCategory(categoryID: category.id) {
                    self.categoryCollection.reloadData()
                } else {
                    AlertController.showNotification(
                        alertPresenter: self,
                        title: "Невозможно удалить категорию!",
                        message: "Категория \(category.title) содержит трекеры.\nЧтобы удалить эту категорию сначала необходимо переместить из неё все трекеры"
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
