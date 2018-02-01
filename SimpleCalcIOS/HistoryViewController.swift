//
//  HistoryViewController.swift
//  SimpleCalcIOS
//
//  Created by JJ Guo on 1/31/18.
//  Copyright © 2018 JJ Guo. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    var wordBank:[String] = ["Hello", "JJ"]
    override func viewDidLoad() {
        super.viewDidLoad()
        for index in 0...wordBank.count - 1 {
            let label = UILabel(frame: CGRect(x: 50, y: index * 25 + 50, width: 300, height: 40))
            label.text = wordBank[index]
            view.addSubview(label)
            scrollView.addSubview(label)
        }
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let talkView = segue.destination as! ViewController
        talkView.wordBank = wordBank
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
