import UIKit

final class AlertController {
    static func removeObject(
        alertPresenter: AlertPresenterProtocol,
        title: String,
        _ completion: @escaping () -> Void
    ) {
        let alert = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .actionSheet
        )
         
        alert.addAction(UIAlertAction(title: localized("delete"), style: .destructive) { _ in
            completion()
        })
        alert.addAction(UIAlertAction(title: localized("cancel"), style: .cancel, handler: nil))
         
        alertPresenter.present(alert: alert, animated: true)
    }
    
    static func showNotification(
        alertPresenter: AlertPresenterProtocol,
        title: String,
        message: String,
        _ completion: ( () -> Void )? = nil
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
         
        alert.addAction(UIAlertAction(title: localized("ok"), style: .default) { _ in
            completion?()
        })
         
        alertPresenter.present(alert: alert, animated: true)
    }
}
