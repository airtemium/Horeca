//
//  MainPresenter.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation

final class OrdersPresenter
{
    private var _data = [TableOrders]()
    
    // MARK: - Private properties -

    private unowned let view: OrdersViewProtocol
    
    private let interactor: OrdersInteractorProtocol
    
    private let wireframe: OrdersWireframeProtocol

    // MARK: - Lifecycle -

    init(view: OrdersViewProtocol, interactor: OrdersInteractorProtocol, wireframe: OrdersWireframeProtocol)
    {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
        
        _reloadData()
    }
    
    private func _reloadData()
    {
        guard let r = DB.shared.getRealm, let place = r.objects(UsersPlaceModel.self).first else {
            return
        }
        
        var data = [TableOrders]()
        
        let checkins = self.interactor.getCheckins()
        
        let tables = self.interactor.getTables()
        
        var orderItems = self.interactor.getOrderItems()
        
        for item in tables
        {
            let tableChekins = checkins.filter({ $0.tableUid == item.uid })

//            var tableOrderItems = orderItems.filter({ $0. })
            
            if(tableChekins.count == 0)
            {
                continue
            }
            
            let total = tableChekins.reduce(0) { $0 + $1.total }
            
            let table1 = TableOrders()
            table1.AmountTotal = total
            table1.TableUID = item.uid
            table1.AmountTotalCurrency = place.Currency
            table1.GuestCount = tableChekins.count
            table1.PartyName = item.partyName
            table1.Status = ""
            table1.TableNumber = item.parameters.number

            data.append(table1)
        }

        _data = data.sorted(by: { $0.TableNumber < $1.TableNumber })

    }
}

// MARK: - Extensions -
extension OrdersPresenter: OrdersPresenterProtocol
{
//    func CloseCheckinsAsPaidByTableUID(tableUID: String, finishWithSuccess: @escaping () -> (), finishWithError: @escaping () -> ()) {
//        <#code#>
//    }
    
    func SwitchToProfile()
    {
        self.wireframe.SwitchToProfile()
    }
    
    func SwitchTomap()
    {
        self.wireframe.SwitchTomap()
    }
    
    func getCheckinsCount() -> Int
    {
        return _data.reduce(0) { $0 + $1.GuestCount }
    }
    
    func reloadOrders()
    {
        _reloadData()
    }
    
    func OpenTable(tableUID: String, prev: String)
    {
        self.wireframe.OpenTable(tableUID: tableUID, prev: prev)
    }
    
    func getDataItem(idx: Int) -> TableOrders
    {
        return _data[idx]
    }
    
    func getOrdersCount() -> Int
    {
        return _data.count
    }
    
    func getOorderAmount() -> Double
    {
        return interactor.getCheckins().reduce(0) { $0 + $1.total }
    }
    
    func getPlaceCurrency() -> String
    {
        return self.interactor.getPlaceCurrency()
    }
    
    func CloseCheckinsAsPaidByTableUID(tableUID: String, leftUnpaid: Bool, payedByCash: Bool, comment: String, finishWithSuccess: @escaping () -> (), finishWithError: @escaping () -> ())
    {
        print("*** CloseCheckinsAsPaidByTableUID 1")
        
        
        
        let checkins = self.interactor.getCheckins()
        
        let tableChekins = checkins.filter({ $0.tableUid == tableUID })
        
        print(tableChekins)
        
        if(tableChekins.count == 0)
        {
            print("*** CloseCheckinsAsPaidByTableUID 2")
            
            finishWithError()
            return
        }

        // TODO
        let unpaidCheckins = tableChekins.filter({ $0.status == "approved" || $0.status == "new" && $0.leftToPay > 0  })
        
//        let unpaidCheckins = tableChekins.filter({ $0.leftToPay > 0 })
        
        if(unpaidCheckins.count == 0)
        {
            print("*** CloseCheckinsAsPaidByTableUID 3")
            finishWithError()
            return
        }
        
        let placeUID = unpaidCheckins.first?.placeUid
        
//        var checkinsToPay = unpaidCheckins.compactMap { $0.checkinUid }
        
        var orderItemsToPay = [String]()
        
        var unpaidInvoisesUIDs = [String]()
        
        var unpaidCheckinsIDs = [String]()
        
        let dg = DispatchGroup()
                        
        for i in unpaidCheckins
        {
            print("*** UNPAID CHECKIN \(i.checkinUid)")
            
            let orderItems = self.interactor.getOrderItemsByCheckin(checkinUID: i.checkinUid)
            
//            print(orderItems)
            
            unpaidCheckinsIDs.append(i.checkinUid)
            
            orderItems.forEach {
                if($0.InvoiceUID.isEmpty)
                {
                    orderItemsToPay.append($0.UID)
                }
                else
                {
                    if(!unpaidInvoisesUIDs.contains($0.InvoiceUID))
                    {
                        unpaidInvoisesUIDs.append($0.InvoiceUID)
                    }
                }
                
                
            }
            
//            if(orderItemsToPay.count > 0)
//            {
                print("*** CloseCheckinsAsPaidByTableUID 4")
                let dataToSend: [String: Any] = [
                    "checkin_uid": i.checkinUid,
                    "item_uids": orderItemsToPay,
                    "place_uid": placeUID!,
                    "user_uid": self.interactor.getUserUID()
                ]

                dg.enter()

                self.interactor.PayCheckins(data: dataToSend) { invoiceUID in
                    print("*** CloseCheckinsAsPaidByTableUID 5")
                    unpaidInvoisesUIDs.append(invoiceUID)

                    dg.leave()
                } completitionWithError: { error in
                    print("*** CloseCheckinsAsPaidByTableUID 6")
                    dg.leave()
                }
//            }
//            else
//            {
//                print("*** CloseCheckinsAsPaidByTableUID 7")
//                dg.enter()
//                dg.leave()
//            }
        }
        
        dg.notify(queue: DispatchQueue.main) {
            print("*** CloseCheckinsAsPaidByTableUID 8")
//            if(unpaidInvoisesUIDs.count > 0)
//            {
                print("*** CloseCheckinsAsPaidByTableUID 9")
                self.setInvoiseStatusAndClose(invoicesUIDs: unpaidInvoisesUIDs, checkinsUIDs: unpaidCheckinsIDs, leftUnpaid: leftUnpaid, payedByCash: payedByCash, comment: comment, placeUID: placeUID!)
                {
                    print("*** CloseCheckinsAsPaidByTableUID 10")
                    finishWithSuccess()
                }
//            }
//            else
//            {
//                print("*** CloseCheckinsAsPaidByTableUID 11")
//                finishWithSuccess()
//            }
        }
    }
    
    func setInvoiseStatusAndClose(invoicesUIDs: [String], checkinsUIDs: [String],  leftUnpaid: Bool, payedByCash: Bool, comment: String, placeUID: String, finish: @escaping () -> ())
    {
        let dg = DispatchGroup()
        
        for i in invoicesUIDs
        {
            let dataToSend: [String: Any] = [
                "invoice_uid": i,
                "left_unpaid": leftUnpaid,
                "payed_by_cash": payedByCash,
                "payment_comment": comment,
                "place_uid": placeUID
            ]
            
            dg.enter()
            self.interactor.SetInvoiceStatus(payload: dataToSend) {
                dg.leave()
            }
        }
        
//        Date().description(with: .current)
        
        let dataToSend: [String: Any] = [
            "checkin_uids": checkinsUIDs,
            "checkout_date": Date().iso8601withFractionalSeconds,
            "place_uid": placeUID
        ]
                
        dg.notify(queue: DispatchQueue.main) {
            self.interactor.InvoicesCancel(payload: dataToSend) {
                finish()
            }
        }
    }
}


