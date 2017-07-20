//
//  CityTableViewController.swift
//  Hyena
//
//  Created by kbala on 2017/7/19.
//  Copyright © 2017年 kbala. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class CityTableViewController: UITableViewController {

    @IBOutlet weak var tView: UITableView!
    
    var spotArray: Array<SpotMO> = [] //SpotMO Class define in CityModel->Spot
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "hasInitial")
        {
            return
        }
        
        // instantiateViewController 要注意跨Storyboard查詢
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let pageViewController = sb.instantiateViewController(withIdentifier: "WalkthroughController") as? WalkthroughPageViewController{
            present(pageViewController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadCoreData()
        if(spotArray.count==0)
        {
            self.loadWebData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadWebData()
    {
        print("Load data...")
        Alamofire.request( "http://data.ntpc.gov.tw/api/v1/rest/datastore/382000000A-002492-001") .responseJSON { response in
            
            if let json1 = response.result.value as? Dictionary<String,AnyObject>
            {
               if let result = json1["result"] as? Dictionary<String,AnyObject>
               {
                    if let arrayOfDic = result["records"] as? [Dictionary<String,AnyObject>]
                    {
                        for aDic in arrayOfDic
                        {
//                        print(aDic)//print each of the dictionaries
                        
                            var tmpSpot: SpotMO!
                            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
                            {
                                tmpSpot = SpotMO(context: appDelegate.persistentContainer.viewContext) //宣告實體來儲存json資料
                                if let tmp = aDic["Name"] as? String { tmpSpot.name = tmp }
                                else {
                                    continue
                                } // name is necessary
                                
                                if let tmp = aDic["Description"] as? String { tmpSpot.desc = tmp }
                                if let tmp = aDic["Tel"] as? String { tmpSpot.tel = tmp }
                                if let tmp = aDic["Add"] as? String { tmpSpot.addr = tmp }
                                if let tmp = aDic["Zipcode"] as? String { tmpSpot.zipcode = tmp }
                                self.spotArray.append(tmpSpot)
                                
                                // save data to DB
                                appDelegate.saveContext()
                            }
                        } //end of for loop
                    }
                } //end of result
                self.tableView.reloadData()
            }
        }
        print("Data loaded!")
        
    }
    
    func loadCoreData()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext

        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Spot")
        
        do {
            let fetchResult = try managedContext.fetch(fetchRequest)
            spotArray = fetchResult as! [SpotMO]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return spotArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)

        // Configure the cell...

        cell.textLabel?.text = spotArray[indexPath.row].name
        return cell
    }
    
    // segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cityDetail"{
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let name = spotArray[indexPath.row].name
                (segue.destination as! CityDetailViewController).in_name = name!
                let desc = spotArray[indexPath.row].desc
                (segue.destination as! CityDetailViewController).in_des = desc!
            }
        }
    }
   

}