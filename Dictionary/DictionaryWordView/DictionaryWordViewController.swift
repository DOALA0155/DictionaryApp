import UIKit
import Firebase

class DictionaryWordViewController: UIViewController {

    @IBOutlet weak var wordNameLabel: UILabel!
    @IBOutlet weak var wordExplanationView: UITextView!
    var wordName = ""
    var wordExplanation = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        wordNameLabel.text! = wordName
        wordExplanationView.text! = wordExplanation
        
    }
    @IBAction func logOut(_ sender: Any) {
        let alert = UIAlertController(title: "ログアウト", message: "本当にログアウトしますか？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            try? Auth.auth().signOut()
            let StartViewController: StartViewController = self.storyboard?.instantiateViewController(identifier: "start") as! StartViewController
            self.navigationController?.pushViewController(StartViewController, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
