
//  Created by Airtemium

import Foundation
import UIKit

extension UIStoryboard {

    func instantiateViewController<T: UIViewController>(ofType _: T.Type, withIdentifier identifier: String? = nil) -> T {
        let identifier = identifier ?? String(describing: T.self)
        return instantiateViewController(withIdentifier: identifier) as! T
    }
}

extension UIViewController {

    func presentWireframe(_ wireframe: BaseWireframe, animated: Bool = true, completion: (() -> Void)? = nil)
    {
//        present(wireframe.viewController, animated: animated, completion: completion)
    }

    var topbarHeight: CGFloat {
        // NOTE: statusBarFrame was deprecated in iOS13
        if #available(iOS 13.0, *) {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        } else {
            return UIApplication.shared.statusBarFrame.size.height +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        }
    }
}

extension UINavigationController {

    func pushWireframe(_ wireframe: BaseWireframe, animated: Bool = true)
    {
//        self.pressesBegan(<#T##presses: Set<UIPress>##Set<UIPress>#>, with: <#T##UIPressesEvent?#>)
        
//        self.pushViewController(wireframe.viewController, animated: animated)
    }

    func setRootWireframe(_ wireframe: BaseWireframe, animated: Bool = true)
    {
//        self.setViewControllers([wireframe.viewController], animated: animated)
    }

}

extension Data {
    
    func toModel<T: Decodable>(_ model: T.Type) throws -> T? {
        return try JSONDecoder().decode(model, from: self)
    }
    
}

extension String {
    
    func localizedString() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
}
