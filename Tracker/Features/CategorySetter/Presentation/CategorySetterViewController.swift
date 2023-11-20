import UIKit

class CategorySetterViewController: UIViewController {
    
    private var initCategory: TrackerCategory?
    
    private let presenter = Creator.injectCategorySetterPresenter()

    private var categoryCollection: UICollectionView!
    
    private let placeholder = Placeholder()
    
    private var addCategoryButton: UIButton!
    
    private var currentCheckedCell: IndexPath?
    
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
        let controller = CategoryCreatorViewController()
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
        view.backgroundColor = .ypWhite
        
        categoryCollection = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        categoryCollection.backgroundColor = .clear
        
        view.addSubView(
            categoryCollection,
            top: AnchorOf(view.topAnchor),
            bottom: AnchorOf(view.bottomAnchor),
            leading: AnchorOf(view.leadingAnchor, 16),
            trailing: AnchorOf(view.trailingAnchor, -16)
        )
        categoryCollection.showsVerticalScrollIndicator = false
        
        placeholder.image.image = UIImage(named: "TrackerPlaceholder")
        placeholder.label.text = "Привычки и события можно\nобъединить по смыслу"
        view.addSubView(
            placeholder.view, width: 175, heigth: 125,
            centerX: AnchorOf(view.centerXAnchor),
            centerY: AnchorOf(view.centerYAnchor)
        )
        
        addCategoryButton = UIButton.systemButton(
            with: UIImage(), target: nil, action: #selector(onAddCategoryButtonClick)
        )
        addCategoryButton.layer.cornerRadius = 16
        addCategoryButton.backgroundColor = .ypBlack
        addCategoryButton.setTitle("Добавить категорию", for: .normal)
        addCategoryButton.tintColor = .ypWhite
        addCategoryButton.titleLabel?.font = Font.ypMedium16
        view.addSubView(
            addCategoryButton, heigth: 60,
            bottom: AnchorOf(view.bottomAnchor, -50),
            leading: AnchorOf(view.leadingAnchor, 16),
            trailing: AnchorOf(view.trailingAnchor, -16)
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
        
        cell.setDelegate(self)
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
