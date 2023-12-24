import UIKit

final class ContextMenuConfigurator {
    static func setupMenu(
        alertPresenter: AlertPresenterProtocol,
        pinAction: ( () -> Void )? = nil,
        willPin: ( () -> Bool )? = nil,
        editAction: @escaping () -> Void,
        removeMessage: String,
        removeAction: @escaping () -> Void
    ) -> UIContextMenuConfiguration {
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil
        ) { _ -> UIMenu? in
            
            var actions = [UIAction]()
            
            if let pinAction, let willPin {
                let _willPin = willPin()
                let pin = UIAction(
                    title: _willPin ? "Закрепить" : "Открепить",
                    image: _willPin ? UIImage(systemName: "pin.fill") : UIImage(systemName: "pin.slash.fill")
                ) { _ in
                    pinAction()
                }
                actions.append(pin)
            }
            
            let edit = UIAction(
                title: "Редактировать",
                image: UIImage(systemName: "pencil")
            ) { _ in
                editAction()
            }
            actions.append(edit)

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
            actions.append(remove)
            
            return UIMenu(title: "", children: actions)
        }
    }
}
