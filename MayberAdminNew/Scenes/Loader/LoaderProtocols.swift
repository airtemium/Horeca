//
//  MainProtocols.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation
import UIKit

protocol LoaderWireframeProtocol: WireframeProtocol
{
    func switchToMain()
}

protocol LoaderViewProtocol: ViewProtocol {

}

protocol LoaderPresenterProtocol: PresenterProtocol
{
    func switchToMain()
}

protocol LoaderInteractorProtocol: InteractorProtocol
{

}
