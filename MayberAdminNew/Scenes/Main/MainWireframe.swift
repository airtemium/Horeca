//
//  MainWireframe.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

final class MainWireframe: BaseWireframe, MainWireframeProtocol
{

    // MARK: - Private properties -

    // MARK: - Module setup -
    
    init()
    {
        let mainViewController = MainViewController()
        super.init(viewController: mainViewController, name: "main")

        let interactor = MainInteractor()
        let presenter = MainPresenter(view: mainViewController, interactor: interactor, wireframe: self)
        mainViewController.presenter = presenter
        
    }
    
    override func ReloadParams(params: [String : Any])
    {
        
    }
    
    // TODO:- нужно вероятно сделать лоадер, и потом от ситуации, либо на логин экран , либо схема зала
    
    func switchToStartController()
    {        
        ChangeController(name: "loader", transition: .None)
    }
}
