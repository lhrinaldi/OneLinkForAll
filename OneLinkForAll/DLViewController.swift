import UIKit
import AppsFlyerLib

class DLViewController: UIViewController {
    
    var deepLinkData: DeepLink? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func attributionDataToString() -> NSMutableAttributedString {
        let newString = NSMutableAttributedString()
        let boldAttribute = [
           NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 18.0)!
        ]
        let regularAttribute = [
           NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 18.0)!
        ]
        for (key, value) in deepLinkData!.clickEvent {
            print("ViewController", key, ":",value)
            let keyStr = key
            let boldKeyStr = NSAttributedString(string: keyStr, attributes: boldAttribute)
            newString.append(boldKeyStr)
            let valueStr = value as? String ?? "null"
            let normalValueStr = NSAttributedString(string: ": \(valueStr)\n", attributes: regularAttribute)
            newString.append(normalValueStr)
        }
        return newString
    }
}
