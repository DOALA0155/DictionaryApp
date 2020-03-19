import UIKit
import GoogleSignIn
import Firebase
import FirebaseFirestore

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UISearchBarDelegate {

    var dictionary: Dictionary<String, Dictionary<String, String>> = [:]
    @IBOutlet weak var dictionaryList: UITableView!
    var me: AppUser!
    var auth: Auth!
    var database: Firestore!
    var searchResult: [String]!
    var dictionaries: Array<String> = []
    let dictionarySearchBar: UISearchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        auth = Auth.auth()
        self.navigationItem.hidesBackButton = true
        database = Firestore.firestore()
        dictionarySearchBar.delegate = self
        dictionaryList.delegate = self
        dictionaryList.dataSource = self
        dictionaryList.register(UINib(nibName: "DictionaryTableViewCell", bundle: nil), forCellReuseIdentifier: "DictionaryTableViewCell")
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        me = AppUser(data: ["userId": auth.currentUser!.uid])
        database.collection(me.userId).getDocuments{ (snapshot, error) in if error == nil, let snapshot = snapshot{
            for document in snapshot.documents{
                let data = document.data()
                let dictionaryName = data["dictionaryName"]
                let dictionaryWord = data["dictionaryWord"]
                self.dictionary.updateValue(dictionaryWord as! Dictionary<String, String>, forKey: dictionaryName as! String)
                let keys = Array(self.dictionary.keys)
                self.dictionaries = []
                for key in keys{
                    self.dictionaries.append(key)
                }
            }
            self.dictionaryList.reloadData()
            }}
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        searchBar.showsCancelButton = true
        self.searchResult = dictionaries.filter{
            $0.lowercased().contains(searchBar.text!.lowercased())
        }
        
        self.dictionaryList.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        self.view.endEditing(true)
        searchBar.text = ""
        self.dictionaryList.reloadData()
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dictionarySearchBar.text! == ""{
            return dictionaries.count
        }
        else{
            return searchResult.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DictionaryTableViewCell", for: indexPath) as! DictionaryTableViewCell
        if dictionarySearchBar.text! == ""{
            cell.dictionaryName.text = self.dictionaries[indexPath.row]
        }else{
            cell.dictionaryName.text = self.searchResult[indexPath.row]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        dictionarySearchBar.placeholder = "辞書を検索"
        return dictionarySearchBar
    }
    @IBAction func goToAddView(_ sender: Any) {
        performSegue(withIdentifier: "toAddView", sender: dictionary)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddView"{
            let AddViewController = segue.destination as! AddDictionaryViewController
            AddViewController.me = me
        }else if segue.identifier == "toDictionaryView"{
            let DictionaryViewController = segue.destination as! DictionaryViewController
            DictionaryViewController.dictionaryName = (sender as! String)
            DictionaryViewController.me = me
            
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            let alert = UIAlertController(title: "削除", message: "本当に削除しますか？", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                (action: UIAlertAction!) -> Void in
                if self.dictionarySearchBar.text ==  ""{
                    self.dictionaries.remove(at: indexPath.row)
                    let keys = Array(self.dictionary.keys)
                    self.dictionary[keys[indexPath.row]] = nil
                    self.database.collection(self.me.userId).document(keys[indexPath.row]).delete()
                }else{
                    if let index = self.dictionaries.firstIndex(of: self.searchResult[indexPath.row]){
                        self.dictionaries.remove(at: index)
                    }
                    self.dictionary[self.searchResult[indexPath.row]] = nil
                    self.database.collection(self.me.userId).document(self.searchResult[indexPath.row]).delete()
                    self.searchResult.remove(at: indexPath.row)
                }
                tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
                
            }))
            alert.addAction(UIAlertAction(title: "キャンセル", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let keys = Array(self.dictionary.keys)
        if dictionarySearchBar.text == ""{
            performSegue(withIdentifier: "toDictionaryView", sender: keys[indexPath.row])
        }else{
            performSegue(withIdentifier: "toDictionaryView", sender: searchResult[indexPath.row])
        }
        
    }
    
}
