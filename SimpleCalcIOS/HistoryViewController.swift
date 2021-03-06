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
    var wordBank:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if wordBank.count > 0 {
            for index in 0...wordBank.count - 1 {
                let label = UILabel(frame: CGRect(x: 50, y: index * 25 + 50, width: 300, height: 40))
                label.text = wordBank[index]
                view.addSubview(label)
                scrollView.addSubview(label)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: 321, height: 1000)
        scrollView.showsVerticalScrollIndicator = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let talkView = segue.destination as! ViewController
        talkView.wordBank = wordBank
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
