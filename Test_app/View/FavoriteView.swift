import UIKit
import Foundation
import WebKit

class FavoriteView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var networkManager = Network()
    var saved = fetchArticles.shared.fetch()
    var cacheManager = cachePage()
    
    lazy var webView: WKWebView = {
        return WKWebView.init(frame: UIScreen.main.bounds)
    }()
    
    @IBOutlet weak var viewTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewTable.reloadData()
        viewTable.delegate = self
        viewTable.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return saved.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellView
        let page = saved[indexPath.row]
        
        cell.inform.text = page.title
        cell.button.tag = indexPath.row
        cell.button.setTitle("", for: .normal)
        cell.button.setImage (UIImage (named: "delete"), for: .normal)
        cell.button.addTarget(self, action: #selector(deleteButton), for: .touchUpInside)
        
        return cell
    }

    @objc func deleteButton(sender : UIButton){
        let indexpath = IndexPath(row:sender.tag,section:0)
     
        cacheManager.removeWebPageFromCache(urlString: saved[indexpath.row].url!)
        fetchArticles.shared.deletaOne(with: Int64(saved[indexpath.row].id))
        saved = fetchArticles.shared.fetch()
        
        viewTable.reloadData()
    }
    
    func goToWebview(with url: String) {
        webView.load(URLRequest.init(url: URL.init(string: url)!))
        UIViewController().view.addSubview(webView)
        self.present(UIViewController(),animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToWebview(with: saved[indexPath.row].url ?? "")
    }
}



