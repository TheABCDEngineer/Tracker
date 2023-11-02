import UIKit

final class TrackerCreatorViewController: UIViewController {
    var trackerType: TrackerType = .event
    
    private var eventCreatorCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        configureLayout()
    }
}

//MARK: - UICollectionViewDataSource
extension TrackerCreatorViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView
    ) -> Int {
//        return 4
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return trackerType == .habit ? 2 : 1
        case 2:
            return TrackerEmoji.items.count
        case 3:
            return TrackerColors.items.count
        case 4:
            return 1
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        switch indexPath.section {
        case 0:
            return configureTitleCell(for: collectionView, with: indexPath)
        case 1:
            return configureSettingsCell(for: collectionView, with: indexPath)
        case 2:
            return configureEmojiCell(for: collectionView, with: indexPath)
        case 3:
            return configureColorsCell(for: collectionView, with: indexPath)
        case 4:
            return configureButtonsCell(for: collectionView, with: indexPath)
        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch indexPath.section {
        case 0, 1, 4:
            return configureHeader(collectionView: collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
        case 2:
            return configureHeader(title: "Emoji", x: 6, y: 40, collectionView: collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
        case 3:
            return configureHeader(title: "Цвет", x: 6, y: 40, collectionView: collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
        default:
            return UICollectionReusableView()
        }
       
    }

    private func configureTitleCell(for collectionView: UICollectionView, with indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let
                cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: TrackerCreatorTitleCell.Identifier,
                            for: indexPath
                ) as? TrackerCreatorTitleCell else {
                    return UICollectionViewCell()
                }
        cell.eventLable.text = trackerType == .habit ? "Новая привычка" : "Новое нерегулярное событие"
        return cell
    }
    
    private func configureSettingsCell(for collectionView: UICollectionView, with indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let
                cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: TrackerCreatorSettingsCell.Identifier,
                            for: indexPath
                ) as? TrackerCreatorSettingsCell else {
                    return UICollectionViewCell()
                }
        
        switch indexPath.item {
        case 0:
            cell.label.text = "Категория"
            cell.subLabel.text = "Важное"
            
            let cellType: SettingsMenuCellType = trackerType == .event ? .single : .first
            cell.initCell(cellType)
        case 1:
            cell.label.text = "Расписание"
            cell.initCell(.last)
        default: break
        }
        return cell
    }
    
    private func configureEmojiCell(for collectionView: UICollectionView, with indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let
                cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: EmojiCell.Identifier,
                            for: indexPath
                ) as? EmojiCell else {
                    return UICollectionViewCell()
                }
        cell.label.text = TrackerEmoji.items[indexPath.item]
        return cell
    }

    private func configureColorsCell(for collectionView: UICollectionView, with indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let
                cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: ColorsCell.Identifier,
                            for: indexPath
                ) as? ColorsCell else {
                    return UICollectionViewCell()
                }

        cell.view.backgroundColor = TrackerColors.items[indexPath.item].toUIColor()
        return cell
    }

    private func configureButtonsCell(for collectionView: UICollectionView, with indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let
                cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: ButtonsCell.Identifier,
                            for: indexPath
                ) as? ButtonsCell else {
                    return UICollectionViewCell()
                }


        return cell
    }
    
    private func configureHeader(title: String = "", x: CGFloat = 0, y: CGFloat = 0, collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.Identifier, for: indexPath) as? HeaderView else {
            return UICollectionReusableView()
        }

        header.label.text = title
        header.configureLablePosition(x: x, y: y)
        return header
    }

}

//MARK: - UICollectionViewDelegateFlowLayout
extension TrackerCreatorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: collectionView.frame.width, height: 120)
        case 1:
            return CGSize(width: collectionView.frame.width, height: 75)
        case 2:
            return CGSize(width: 52, height: 52)
        case 3:
            return CGSize(width: 52, height: 52)
        case 4:
            return CGSize(width: collectionView.frame.width, height: 60)
        default:
            return CGSize(width: 52, height: 52)
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 0, 1, 4:
            return 0
        case 2:
            return 0
        case 3:
            return 0
        default:
            return 0
        }
        //return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 0, 1, 4:
            return 0
        case 2:
            return 4
        case 3:
            return 4
        default:
            return 4
        }
          //return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0, 1, 4:
            return CGSize(width: collectionView.frame.width, height: 24)
        case 2:
            return CGSize(width: collectionView.frame.width, height: 80)
        case 3:
            return CGSize(width: collectionView.frame.width, height: 80)
        default:
            return CGSize()
        }
        //return CGSize(width: collectionView.frame.width, height: 80)
    }
}

//MARK: - Configure Layout
extension TrackerCreatorViewController {
    private func configureLayout() {        
        eventCreatorCollection = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        eventCreatorCollection.backgroundColor = .clear
        view.addSubView(
            eventCreatorCollection,
            top: AnchorOf(view.topAnchor),
            bottom: AnchorOf(view.bottomAnchor),
            leading: AnchorOf(view.leadingAnchor, 16),
            trailing: AnchorOf(view.trailingAnchor, -16)
        )
        eventCreatorCollection.showsVerticalScrollIndicator = false
        
        eventCreatorCollection.dataSource = self
        eventCreatorCollection.delegate = self
        
        
        eventCreatorCollection.register(
            TrackerCreatorTitleCell.self,
            forCellWithReuseIdentifier: TrackerCreatorTitleCell.Identifier
        )
        eventCreatorCollection.register(
            TrackerCreatorSettingsCell.self,
            forCellWithReuseIdentifier: TrackerCreatorSettingsCell.Identifier
        )
        eventCreatorCollection.register(
            EmojiCell.self,
            forCellWithReuseIdentifier: EmojiCell.Identifier
        )
        eventCreatorCollection.register(
            ColorsCell.self,
            forCellWithReuseIdentifier: ColorsCell.Identifier
        )
        eventCreatorCollection.register(
            ButtonsCell.self,
            forCellWithReuseIdentifier: ButtonsCell.Identifier
        )
        
        eventCreatorCollection.register(
            HeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderView.Identifier
        )
    }
}
