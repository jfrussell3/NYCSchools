//
//  ViewController.swift
//  20210918-JohnRussell-NYCSchools
//
//  Created by john Russell on 9/18/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var schoolList:[SchoolDataModel]!
        
    private let tableFooterLinePixels :CGFloat = 2.0
    
    @IBOutlet weak var tableView: UITableView!
        
    private var serviceWrapper : ServiceWrapper = ServiceWrapper()

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Todo: Implement search, filter, sort features
        
        self.setupUI()
        
        //self.generateTestData()
        
        self.fetchData()
    }
    
    func setupUI()
    {
        activityIndicator.color = .NYCorangeColor
        
        self.view.bringSubviewToFront(self.activityIndicator)
        activityIndicator.isHidden = true
                
        self.title = "Schools List"
        
        schoolList = []
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .NYClightGrayColor2
                
        tableView.separatorInset = .zero
        tableView.separatorColor = .darkGray
                
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34, weight: .bold) ]
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.barTintColor = .NYCdarkBlueColor
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
    }

    
    func fetchSavedData()
    {
        // Todo: fetch data from user defaults, etc here
        // Todo: hide tableview until some data is available
        

    }
    
    func generateTestData()
    {
        // for testing purposes just generate test data for now
        let school1 = SchoolDataModel(school_name: "School for Legal Studies", dbn:"14K477", zip: "11211", borough: "BROOKLYN", neighborhood: "Bushwick", city: "Brooklyn", primaryAddressLine1: "850 Grand Street", phone_number: "718-387-2800", website: "www.thesls.net", total_students: "509", campusName: "Grand Street Educational Campus", school_email: "mail@thesls.net", graduation_rate: ".4409080706", finalGrades: "9-12" )

        let school2 = SchoolDataModel(school_name: "School for Business Studies", dbn:"99999999", zip: "11211", borough: "MANHATTAN", neighborhood: "Little Norway", city: "Manhattan",  primaryAddressLine1: "851 main Street", phone_number: "512-788-4429", website: "schools.nyc.gov/SchoolPortals/08/X349", total_students: "501", campusName: "Grand Street Business Campus", school_email: "jfrussell3@gmail.com", graduation_rate: ".5", finalGrades: "10-12")

        schoolList = [school1, school2]
    }
    
        
    func showHUD()
    {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    
    func hideHUD()
    {
       self.activityIndicator.stopAnimating()
    }
  
    
    func fetchData()
    {
        // Todo: Implement a scheme where data is restored when app loads (and persisted when fresh data is fetched) so that user can see something immediately; all while fresh data is fetched
        // Todo: implement timeout
        // Todo: Implement app tokens for services
        
        self.showHUD()
        
        self.fetchSavedData()

        let urlString = "https://data.cityofnewyork.us/resource/s3k6-pzi2.json"

        guard let url = URL(string:urlString)
        else
        {
            self.hideHUD()
            return

        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"

        serviceWrapper.fetchDataWithDataTask(with: urlRequest, success: { [self] (data) in

            if let myData = data
            {
               do
               {
                 if let json = try! JSONSerialization.jsonObject(with: myData, options: .allowFragments) as? [Any]
                 {
                     var array = [SchoolDataModel]()
                     for item in json
                     {
                         if let object = item as? [String: Any]
                         {
                            let school_name = object["school_name"] as? String ?? ""
                            let dbn = object["dbn"] as? String ?? ""
                            let zip = object["zip"] as? String ?? ""
                            let borough = object["borough"] as? String ?? ""
                            let neighborhood = object["neighborhood"] as? String ?? ""
                            let city = object["city"] as? String ?? ""
                            let primaryAddressLine1 = object["primaryAddressLine1"] as? String ?? ""
                            let phone = object["phone_number"] as? String ?? ""
                            let website = object["website"] as? String ?? ""
                            let total_students = object["total_students"] as? String ?? ""
                            let campus_name = object["campus_name"] as? String ?? "" // Todo: dig into why some have this field and others not
                            let school_email = object["school_email"] as? String ?? ""
                            let graduation_rate = object["graduation_rate"] as? String ?? ""
                            let finalgrades = object["finalgrades"] as? String ?? ""
                            
                            // For testing purposes only
                            //borough = "OVERRIDDEN !!!!!!!!!!!"
                            
                            if borough.lowercased() != city.lowercased()
                            {
                                print("\(dbn) borough = \(borough) city = \(city)")
                            }
                            
                            //borough = borough.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet)
                            
                            let dataObject = SchoolDataModel(school_name: school_name, dbn:dbn, zip: zip, borough: borough.trim(), neighborhood: neighborhood, city: city.trim(), primaryAddressLine1: primaryAddressLine1, phone_number: phone, website: website, total_students: total_students, campusName: campus_name, school_email: school_email, graduation_rate: graduation_rate, finalGrades: finalgrades)
                             
                            array.append(dataObject)
                         }
                     }
                    schoolList = array
                 }
                else
                {
                    // Todo: handle this gracefully - notify user to try again, hide tableview.
                    print("could not serialize")
                }
                }

                DispatchQueue.main.async(execute:
                {
                    
                    tableView.reloadData()
                    
                    self.hideHUD()
                })
            }


        }) { (error) in

            print("Error")

            DispatchQueue.main.async(execute:
            {
                
                // Todo: add niceties here - show error message
                self.hideHUD()
            })

            //failure(error)
        }
    }
    

    // MARK: -  Tableview
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return schoolList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "SchoolListCell", for: indexPath)
        //        cell.textLabel?.text = dataObject.school_name
        //        cell.detailTextLabel?.text = dataObject.city + ", " + dataObject.borough + ", " + dataObject.zip

        let cell = tableView.dequeueReusableCell(withIdentifier: "SchoolListCell", for: indexPath) as! SchoolListTableViewCell
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = .NYClightGrayColor
        
        let dataObject = schoolList[indexPath.row]
        
        // Todo: seek to understand data and determine of Borough should be displayed here and on detail screen ... and if label should say Borough or  City
        // Test this ... still having an issue
        if dataObject.borough.lowercased() == dataObject.city.lowercased()
        {
            cell.zipLabel.text = dataObject.city + ", " + dataObject.zip
        }
        else
        {
            print(dataObject.borough.lowercased())
            print(dataObject.city.lowercased())
            
            cell.zipPromptLabel.text = "C,B,Z"
            cell.zipLabel.text = dataObject.borough + ", " + dataObject.city + ", " + dataObject.zip
        }
                
        cell.middleRowLabel.text = dataObject.neighborhood
        
        cell.nameLabel.text = dataObject.school_name
        
        cell.namePromptLabel.textColor = .NYCorangeColor
        cell.middleRowPromptLabel.textColor = cell.namePromptLabel.textColor
        cell.zipPromptLabel.textColor = cell.namePromptLabel.textColor
        
        cell.nameLabel.textColor = .NYClightBlueColor 
        cell.middleRowLabel.textColor = cell.nameLabel.textColor
        cell.zipLabel.textColor = cell.nameLabel.textColor
        
        cell.nameLabel.font = UIFont.italicSystemFont(ofSize: cell.nameLabel.font.pointSize)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "SchoolDetailViewController") as? SchoolDetailViewController
        else
        {
            // Todo: notify user gracefully
            return
        }

        controller.dataObject = schoolList[indexPath.row]
        
        controller.modalPresentationStyle = .fullScreen
        
        self.navigationItem.title = "List"
        
        self.navigationController!.pushViewController(controller, animated: true)        
    }


}

