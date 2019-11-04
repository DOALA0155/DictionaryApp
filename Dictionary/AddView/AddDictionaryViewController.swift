import UIKit
import Firebase
import FirebaseFirestore

class AddDictionaryViewController: UIViewController, UITextFieldDelegate {
    
    var dictionary: Dictionary<String, Dictionary<String, String>> = [:]
    var database: Firestore!
    var me: AppUser!
    
    @IBOutlet weak var dictionaryNameField: UITextField!
    @IBOutlet weak var dictionaryLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    var allData: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database = Firestore.firestore()
        dictionaryNameField.delegate = self
    }
    
    
    @IBAction func addDictionary(_ sender: Any) {
        let dictionaryName = dictionaryNameField.text!
        dictionaryNameField.text! = ""
        database.collection(me.userId).getDocuments{(snapshot, error) in if error == nil, let snapshot = snapshot{
            self.allData = []
            print(snapshot.documents)
            for documet in snapshot.documents{
                let data = documet.data()
                self.allData.append(data["dictionaryName"] as! String)
            }
            if self.allData.contains(dictionaryName) || dictionaryName == ""{            let alert = UIAlertController(title: "追加エラー", message: "その名前の辞書は既に存在しているか、辞書名が空欄です。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                let saveDocument = self.database.collection(self.me.userId).document(dictionaryName)
                saveDocument.setData([
                    "dictionaryName": dictionaryName,
                    "dictionaryWord": [:] as! Dictionary<String, String>
                ]){ error in if error == nil{
                    self.navigationController?.popViewController(animated: true)
                    }}
            }
            }
            
        }
        
        }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    

