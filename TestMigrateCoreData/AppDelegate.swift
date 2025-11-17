//
//  AppDelegate.swift
//  TestMigrateCoreData
//
//  Created by Thạnh Dương Hoàng on 17/11/25.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Core Data Stack (Thành phần quản lý chính)
    lazy var persistentContainer: NSPersistentContainer = {
        // CHUẨN: Thay thế "NotesDataModel" bằng tên file .xcdatamodeld của bạn
        let container = NSPersistentContainer(name: "ModelTest")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Xử lý lỗi nghiêm trọng trong quá trình tải Persistent Store
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving Support (Hàm chuẩn để lưu dữ liệu)
    func saveContext () {
        // Lấy Managed Object Context (View Context)
        let context = persistentContainer.viewContext
        
        // Chỉ lưu nếu có thay đổi
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                // Xử lý lỗi khi lưu
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

