//
//  WalkthroughPageViewController.swift
//  Hyena
//
//  Created by kbala on 2017/7/19.
//  Copyright © 2017年 kbala. All rights reserved.
//

import UIKit

class WalkthroughPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var pageHeader = ["台北河岸音樂祭","夏日原創音樂季","貢寮國際海洋音樂祭"]
    var pageImage = ["ad1","ad2","ad3"]
    var pageContent = ["旋律是生活中奔騰的河， 青春是歲月裡溫柔的歌。 你多久沒有大聲唱出回憶中的歡笑與淚水? 在台北河岸，是否有你無法忘懷的美好時光? 在台北市政府的努力下，台北的明媚水岸、美麗河濱已是一道不可錯過的城市風景，大家更可沿著河岸乘鐵馬追風、體驗各種水上運動、擁抱愜意的生活。 今年，我們再次用音樂與各種有趣精彩的活動豐富台北夏日河岸，邀請各位朋友，回到大河的懷抱。在夕陽映照下的淡水河、基隆河邊，讓我們一起聆賞青春舞曲，一起嬉遊整個夏天。","由新北市政府在淡水漁人碼頭打造的戶外原創音樂基地---淡水漁人舞台，今年即將強勢登場，挾帶著去年的好評與民眾的期待，今年夏日將再次引爆淡水，自7/8(六)起至8/20(日)，每個週六、週日的晚間6點到8點，將有 超過24組的獨立樂團及原創歌手站上這號稱全台最美的戶外表演舞台，揮灑熱血帶來最精彩的演出！","貢寮國際海洋音樂祭為新北市夏季最具知名度之年度大型海岸活動之一，不僅成功地把海洋與獨立音樂創作精神融合成東北角海岸特色，創造大型觀光活動收益，亦提供非主流音樂創作者一個表演舞臺，創造國際化觀光行銷臺灣之魅力。本活動每年皆於7月份舉辦，目的是想於暑假期間，提供熱血青少年一個好去處，同時也為整個夏季新北市北部濱海線的旅遊揭開序幕。"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        
        if let startingViewController = contentViewController(at: 0){
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index -= 1

        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index += 1
        
        return contentViewController(at: index)

    }

    func contentViewController(at index: Int) -> WalkthroughContentViewController?
    {
        if index < 0 || index >= pageHeader.count{
            return nil
        }
        
        if let pageContentViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughContentViewController") as? WalkthroughContentViewController{
            pageContentViewController.imageFile = pageImage[index]
            pageContentViewController.head = pageHeader[index]
            pageContentViewController.cont = pageContent[index]
            pageContentViewController.index = index
            return pageContentViewController
        }
        
        return nil
    }
    
    func forward(index: Int)
    {
        if let nextViewController = contentViewController(at: index + 1)
        {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        if let pageContentViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughContentViewController") as? WalkthroughContentViewController{
//            return pageContentViewController.index
//        }
//        return 0
//    }
//    
//    func presentationCount(for pageViewController: UIPageViewController) -> Int{
//        return pageHeader.count
//    }
    
}
