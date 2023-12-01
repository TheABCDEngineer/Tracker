import UIKit

final class ContextMenuConfigurator {
    static func setupMenu(
        alertPresenter: AlertPresenterProtocol,
        editAction: @escaping () -> Void,
        removeMessage: String,
        removeAction: @escaping () -> Void
    ) -> UIContextMenuConfiguration {
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil
        ) { actions -> UIMenu? in
            
            let edit = UIAction(
                title: "Редактировать",
                image: UIImage(systemName: "pencil")
            ) { _ in
                editAction()
            }

            let remove = UIAction(
                title: "Удалить",
                image: UIImage(systemName: "trash.fill"),
                attributes: .destructive
            ) { _ in
                AlertController.removeObject(
                    alertPresenter: alertPresenter,
                    title: removeMessage
                ) {
                    removeAction()
                }
            }
            
            return UIMenu(title: "", children: [edit, remove])
        }
    }
}
