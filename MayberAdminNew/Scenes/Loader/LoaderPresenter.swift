//
//  MainPresenter.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation

final class LoaderPresenter
{

    // MARK: - Private properties -

    private unowned let view: LoaderViewProtocol
    
    private let interactor: LoaderInteractorProtocol
    
    private let wireframe: LoaderWireframeProtocol

    // MARK: - Lifecycle -

    init(view: LoaderViewProtocol, interactor: LoaderInteractorProtocol, wireframe: LoaderWireframeProtocol)
    {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -
extension LoaderPresenter: LoaderPresenterProtocol
{
    func switchToMain()
    {
        self.wireframe.switchToMain()
    }    
}
