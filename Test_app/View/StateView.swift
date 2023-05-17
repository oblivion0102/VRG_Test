import UIKit
import Foundation
import WebKit

class StateView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var pages = [Article]()
    var cacheManager = cachePage()
    
    lazy var webView: WKWebView = {
        return WKWebView.init(frame: UIScreen.main.bounds)
    }()
    
    @IBOutlet weak var viewTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewTable.delegate = self
        viewTable.dataSource = self
        
        self.viewTable.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  pages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellView
        let CheckImg = fetchArticles.shared.searchObjectByID(id: Int64(pages[indexPath.row].id))
        
        if CheckImg == false {
            cell.button.setImage (UIImage (named: "fav1"), for: .normal)
        } else {
            cell.button.setImage (UIImage (named: "fav2"), for: .normal)
        }
        
        cell.button.addTarget(self, action: #selector(addtoButton), for: .touchUpInside)
        cell.inform.text = pages[indexPath.row].title
        cell.button.tag = indexPath.row
        cell.button.setTitle("", for: .normal)
        
        return cell
    }
    
    @objc func addtoButton(sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let page = pages[indexPath.row]
        let isFavorited = fetchArticles.shared.searchObjectByID(id: Int64(page.id))
        
        if isFavorited == false {
            cacheManager.cacheWebPage(urlString: page.url)
            fetchArticles.shared.create(id: Int64(page.id), url: page.url, title: page.title)
            fetchArticles.shared.updata(with: Int64(page.id), nevFav: true)
        } else {
            cacheManager.removeWebPageFromCache(urlString: page.url)
            fetchArticles.shared.deletaOne(with: Int64(page.id))
        }
        
        self.viewTable.reloadData()
    }
    
    func goToWebview(with url: String) {
        webView.load(URLRequest.init(url: URL.init(string: url)!))
        UIViewController().view.addSubview(webView)
        self.present(UIViewController(),animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToWebview(with: pages[indexPath.row].url)
    }
}
