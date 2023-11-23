//
//  OneLinkForAllApp.swift
//  OneLinkForAll
//
//  Created by Lucas Rinaldi on 17/11/23.
//

import SwiftUI
import SwiftData
import UIKit
import AppsFlyerLib


class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        AppsFlyerLib.shared().appsFlyerDevKey = "37jJ3BoPEypZYaUUiRxXYV"
        AppsFlyerLib.shared().appleAppID = "id6472668802"
        AppsFlyerLib.shared().isDebug = true
        
        AppsFlyerLib.shared().deepLinkDelegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didBecomeActiveNotification),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        print("Opening deep links")
        AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
        return true
    }
    
    @objc func didBecomeActiveNotification() {
        AppsFlyerLib.shared().start()
    }
}

extension AppDelegate: DeepLinkDelegate {
    func didResolveDeepLink(_ result: DeepLinkResult) {
        
        switch result.status {
        case .notFound:
            NSLog("[AFSDK] Deep link not found")
            return
        case .failure:
            print("Error %@", result.error!)
            return
        case .found:
            NSLog("[AFSDK] Deep link found")
        }
        
        guard let deepLinkObj:DeepLink = result.deepLink else {
            NSLog("[AFSDK] Could not extract deep link object")
            return
        }
        
        if deepLinkObj.clickEvent.keys.contains("deep_link_sub2") {
            let ReferrerId:String = deepLinkObj.clickEvent["deep_link_sub2"] as! String
            NSLog("[AFSDK] AppsFlyer: Referrer ID: \(ReferrerId)")
        } else {
            NSLog("[AFSDK] Could not extract referrerId")
        }
        
        let deepLinkStr:String = deepLinkObj.toString()
        NSLog("[AFSDK] DeepLink data is: \(deepLinkStr)")
            
        if( deepLinkObj.isDeferred == true) {
            NSLog("[AFSDK] This is a deferred deep link")
        }
        else {
            NSLog("[AFSDK] This is a direct deep link")
        }
        
    }
}


@main
struct OneLinkForAllApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
