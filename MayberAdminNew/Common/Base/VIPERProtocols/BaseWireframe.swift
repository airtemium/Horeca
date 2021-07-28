import UIKit

protocol WireframeProtocol: AnyObject
{
    func popFromNavigationController(animated: Bool)
    func dismiss(animated: Bool)

    func showErrorAlert(with message: String?)
    func showAlert(with title: String?, message: String?)
    func showAlert(with title: String?, message: String?, actions: [UIAlertAction])
}

enum BaseWireframeControllerTransition
{
    case Left
    case Right
    case None
}

class BaseWireframe
{
    var viewController: UIViewController?

    //to retain view controller reference upon first access
//    fileprivate var _temporaryStoredViewController: UIViewController?
    
    private var _name = ""
    
    var GetName: String
    {
        get
        {
            return _name
        }
    }
    
    func ReloadParams(params:  [String: Any])
    {
        
    }

    init(viewController: UIViewController, name: String)
    {
        print("*** BaseWireframe INIT \(name)")
        
        _name = name
        
//        _temporaryStoredViewController = viewController
        
        self.viewController = viewController
    }
    
    func ChangeController(name: String, transition: BaseWireframeControllerTransition)
    {
        NotificationCenter.default.post(name: Constants.Notify.ChangeController, object: nil, userInfo: ["name": name, "transition": transition])
    }
    
    func ChangeController(name: String,
                          params: [String: Any],
                          transition: BaseWireframeControllerTransition)
    {
        NotificationCenter.default.post(name: Constants.Notify.ChangeController, object: nil, userInfo: ["name": name, "params": params, "transition": transition])
    }
    
    func RemoveController(name: String, transition: BaseWireframeControllerTransition = .None)
    {
        NotificationCenter.default.post(name: Constants.Notify.RemoveController, object: nil, userInfo: ["name": name, "transition": transition])
    }
}

extension BaseWireframe: WireframeProtocol
{
    func popFromNavigationController(animated: Bool)
    {
        _ = navigationController?.popViewController(animated: animated)
    }

    func dismiss(animated: Bool)
    {
        navigationController?.dismiss(animated: animated)
    }

    func showErrorAlert(with message: String?)
    {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        showAlert(with: "Something went wrong", message: message, actions: [okAction])
    }

    func showAlert(with title: String?, message: String?) {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        showAlert(with: title, message: message, actions: [okAction])
    }

    func showAlert(with title: String?, message: String?, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        navigationController?.present(alert, animated: true, completion: nil)
    }
}

extension BaseWireframe {

//    var viewController: UIViewController?
//    {
////        print("*** BaseWireframe viewController \(_name)")
//        defer
//        {
//            print("*** BaseWireframe viewController defer \(_name)")
////            print("*** BaseWireframe DEFER")
//
////            _temporaryStoredViewController?.view.removeFromSuperview()
//
//            _temporaryStoredViewController = nil
//        }
//        guard let c = viewController else {
//            return nil
//        }
//
//        return c
//    }

    var navigationController: UINavigationController?
    {
        guard let c = viewController else {
            return nil
        }
        
        return c.navigationController
    }

}
