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
import SwiftyJSON

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

//        self.loadCoreData()
//        if(spotArray.count==0)
//        {
//            self.loadWebData()
//        }
         self.loadWebData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadWebData()
    {
        print("Load data...")
        Alamofire.request( "http://data.ntpc.gov.tw/api/v1/rest/datastore/382000000A-002492-001") .responseJSON { response in
            
            let swiftyJsonVar = JSON(response.result.value!)
            if let records = swiftyJsonVar["result"]["records"].arrayObject {
                for record in records
                {
                    let recordJson = JSON(record)
                    var tmpSpot: SpotMO!
                    if let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
                    {
                        tmpSpot = SpotMO(context: appDelegate.persistentContainer.viewContext) //宣告實體來儲存json資料
                        if let tmp = recordJson["Name"].string { tmpSpot.name = tmp }
                        else {
                            continue
                        } // name is necessary
                        
                        if let tmp = recordJson["Description"].string { tmpSpot.desc = tmp }
                        if let tmp = recordJson["Tel"].string { tmpSpot.tel = tmp }
                        if let tmp = recordJson["Add"].string { tmpSpot.addr = tmp }
                        if let tmp = recordJson["Zipcode"].string { tmpSpot.zipcode = tmp }
                        self.spotArray.append(tmpSpot)
                        
                        // save data to DB
                        appDelegate.saveContext()
                    }
                }
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
