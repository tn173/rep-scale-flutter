import UIKit

class NextController: UIViewController {
    @IBOutlet var status: UILabel!
    @IBOutlet var weight: UILabel!
    @IBOutlet var age: UILabel!
    @IBOutlet var height: UILabel!
    @IBOutlet var gender: UILabel!

    var onClose: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func done(segue _: UIStoryboardSegue) {
        dismiss(animated: true, completion: { [weak self] () in
            self?.onClose?()
        })
    }
    
    @IBAction func cancel(segue _: UIStoryboardSegue) {
        dismiss(animated: true, completion:nil)
    }
}
