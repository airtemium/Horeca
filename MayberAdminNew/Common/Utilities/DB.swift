
//  Copyright © 2021 Airtemium. All rights reserved.
//

import Firebase
import RealmSwift

class DB: NSObject
{
    static let shared = DB()
    
    private override init() {}
    
    // MARK: - Realm -
    
    var _realm: Realm?
    
    var SCHEMA_VERSION: UInt64 = 14

    var getRealm: Realm?
    {
        get
        {
            guard let r = self._realm else
            {
                return self.initDB()
            }

            return r
        }
    }
    
    func initDB() -> Realm?
    {
        let config = Realm.Configuration(
            schemaVersion: SCHEMA_VERSION,
            migrationBlock: { migration, oldSchemaVersion in

            }
        )

        do
        {
            Realm.Configuration.defaultConfiguration = config
            
            self._realm = try Realm()
            
            let folderPath = self._realm?.configuration.fileURL!.deletingLastPathComponent().path
            
            print("** REALM PATH \(folderPath!)/default.realm")
            
            try! FileManager.default.setAttributes([FileAttributeKey.protectionKey: FileProtectionType.none], ofItemAtPath: folderPath!)
            
            return self._realm!

        }
        catch
        {
            Logger.log("*** Init realm error: \(error).")
            return nil
        }
    }
    
    // MARK: - Firebase -
    
    private var _firestore: Firestore!
    
    var getFirestore: Firestore
    {
        if(self._firestore == nil)
        {
            self.initFirebase()
        }
        
        return self._firestore
    }
    
    func initFirebase()
    {
        FirebaseApp.configure()
              
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = false        
        Firestore.firestore().settings = settings

        _firestore = Firestore.firestore()
    }
}
