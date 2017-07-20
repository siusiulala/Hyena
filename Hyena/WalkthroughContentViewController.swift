//
//  WalkthroughContentViewController.swift
//  Hyena
//
//  Created by kbala on 2017/7/19.
//  Copyright © 2017年 kbala. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: UIViewController {

    @IBOutlet var pageControl: UIPageControl!
    
    @IBOutlet weak var header: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var content: UILabel!
    
    @IBOutlet weak var btn: UIButton!
    var index = 0
    var head = ""
    var imageFile = ""
    var cont = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        header.text = head
        content.text = cont
        img.image = UIImage(named: imageFile)
        
        pageControl.currentPage = index
        
        switch index {
        case 0...1:
            btn.setTitle("Next", for: .normal)
        case 2:
            btn.setTitle("Done", for: .normal)
        default:
            break
        }
    }
    
    @IBAction func nextBtnTapped(sender: UIButton)
    {
        switch index {
        case 0...1:
            let pageViewController = parent as!WalkthroughPageViewController
            pageViewController.forward(index: index)
        case 2:
            UserDefaults.standard.set(true, forKey: "hasInitial")
            dismiss(animated: true, completion: nil)
        default:
            break
        }
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
