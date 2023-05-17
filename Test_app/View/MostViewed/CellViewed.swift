import Foundation
import UIKit

class CellViewed: UITableViewCell {
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var faworit: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
