import UIKit
import Foundation
import WebKit

class StateViewMonth: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let cacheManager = cachePage()
    
    var combinedPages = [Article]() {
        didSet {
            viewTable.reloadData()
        }
    }
    
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
        return combinedPages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellView
        let dateFormatter = DateFormatter()
        let Month = Calendar.current.dateComponents([.month], from: Date()).month ?? 0
        let CheckImg = fetchArticles.shared.searchObjectByID(id: Int64(combinedPages[indexPath.row].id))
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let unwrappedPublishedDate = dateFormatter.date(from: combinedPages[indexPath.row].published_date) else {
            return cell
        }

        let publishedMonth = Calendar.current.component(.month, from: unwrappedPublishedDate)

        if Month == publishedMonth {
            cell.inform.text = combinedPages[indexPath.row].title
            cell.button.tag = indexPath.row
            cell.button.setTitle("", for: .normal)
           
            if CheckImg == false {
                cell.button.setImage(UIImage(named: "fav1"), for: .normal)
            } else {
                cell.button.setImage(UIImage(named: "fav2"), for: .normal)
            }
            cell.button.addTarget(self, action: #selector(addtoButton), for: .touchUpInside)
        } else {
            fetchArticles.shared.deletaOne(with: Int64(combinedPages[indexPath.row].id))
        }
        
        return cell
    }

    @objc func addtoButton(sender : UIButton){
        let indexpath = IndexPath(row:sender.tag,section:0)
        let page = combinedPages[indexpath.row]
        let chec = fetchArticles.shared.searchObjectByID(id: Int64(page.id))
        
        if chec == false{
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
        goToWebview(with: combinedPages[indexPath.row].url)
    }
}

