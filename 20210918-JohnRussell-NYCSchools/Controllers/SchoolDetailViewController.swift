//
//  SchoolDetailViewController.swift
//  20210918-JohnRussell-NYCSchools
//
//  Created by john Russell on 9/18/21.
//

import UIKit
import MessageUI

class SchoolDetailViewController: UIViewController, MFMailComposeViewControllerDelegate {

    //https://data.cityofnewyork.us/resource/f9bf-2cp4.json
    
    var dataObject:SchoolDataModel!
    private var serviceWrapper : ServiceWrapper = ServiceWrapper()
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var dialPhoneButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Prompts
    //@IBOutlet weak var campusNamePromptLabel: UILabel!
    @IBOutlet weak var cityPromptLabel: UILabel!
    @IBOutlet weak var neighborhoodPromptLabel: UILabel!
    @IBOutlet weak var zipPromptLabel: UILabel!
    @IBOutlet weak var gradesPromptLabel: UILabel!
    @IBOutlet weak var studentsPromptLabel: UILabel! // Todo: used to set width in order to handle some form factors gracefully
    @IBOutlet weak var graduationRatePromptLabel: UILabel!
    @IBOutlet weak var satPromptLabel: UILabel!
    
    // Data
    @IBOutlet weak var schoolNameLabel: UILabel!
    //@IBOutlet weak var campusNameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var neighborhoodLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var gradesLabel: UILabel!
    @IBOutlet weak var studentCountLabel: UILabel!
    @IBOutlet weak var graduationRateLabel: UILabel!
    @IBOutlet weak var satLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        self.setupUI()
   }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.fetchData()
    }
    
    func setupUI()
    {
        title = "Details"
        
        satLabel.text = "... calculating"
        
        activityIndicator.color = .NYCorangeColor
        
        view.backgroundColor = .NYClightGrayColor2
        
        
        self.formatButton(button: dialPhoneButton)
        
        self.setupDataLabels()
        self.adjustSpacing()
        
        websiteButton.isHidden = (dataObject.website.trim().isEmpty)
        emailButton.isHidden = (!MFMailComposeViewController.canSendMail())
        
        if !websiteButton.isHidden && emailButton.isHidden
        {
            self.formatButton(button: websiteButton)
        }
        
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
  
    
    func adjustSpacing()
    {
        // Make labels (stack  views) fit on screen by adjust vertical spacing between labels,  multiplying by .5 has been tested on smallest and largest form factors.
        
        let screenHeight = UIScreen.main.nativeBounds.height
        let adjustmentFactor = (screenHeight > 1334) ? 0.4 : 0.35
        
        let subviewsCount = mainStackView.subviews.count
        let overallHeight = self.view.frame.height
        var calc = (overallHeight / CGFloat(subviewsCount)) as CGFloat
        calc = calc * CGFloat(adjustmentFactor) //Todo: calc this rather than using magic number
        mainStackView.spacing = calc

        //stackView.setCustomSpacing(30.0, after: stackView.subviews[0])
    }
    
    func setupDataLabels()
    {
        //campusNameLabel.text = dataObject.campusName
        cityLabel.text = dataObject.city
        neighborhoodLabel.text = dataObject.neighborhood
        zipLabel.text = dataObject.zip
        studentCountLabel.text = dataObject.total_students
        gradesLabel.text = dataObject.finalGrades
        
        let schoolNameAndCampus = (dataObject.campusName.trim().isEmpty) ? dataObject.school_name.trim() : "\(dataObject.school_name)\n-\(dataObject.campusName)"
        schoolNameLabel.text = schoolNameAndCampus
        schoolNameLabel.textColor = .NYCdarkBlueColor
        
        let screenHeight = UIScreen.main.nativeBounds.height
        if (screenHeight > 1334)
        {
            // leave font untouched
        }
        else
        {
            let font = schoolNameLabel.font.familyName
            let size = schoolNameLabel.font.pointSize
            let newSize = size * 0.8
            schoolNameLabel.font = UIFont(name:font, size: newSize)
        }
        
        cityPromptLabel.textColor = .NYCorangeColor
        neighborhoodPromptLabel.textColor = cityPromptLabel.textColor
        zipPromptLabel.textColor = cityPromptLabel.textColor
        studentsPromptLabel.textColor = cityPromptLabel.textColor
        gradesPromptLabel.textColor = cityPromptLabel.textColor
        graduationRatePromptLabel.textColor = cityPromptLabel.textColor
        satPromptLabel.textColor = cityPromptLabel.textColor
        
        cityLabel.textColor = schoolNameLabel.textColor
        neighborhoodLabel.textColor = schoolNameLabel.textColor
        zipLabel.textColor = schoolNameLabel.textColor
        studentCountLabel.textColor = schoolNameLabel.textColor
        gradesLabel.textColor = schoolNameLabel.textColor
        graduationRateLabel.textColor = schoolNameLabel.textColor
        satLabel.textColor = schoolNameLabel.textColor


        self.formatGradRate()

        dialPhoneButton.setTitle(dataObject.phone_number, for: .normal)
        
    }
    
//    func formatGradRate()
//    {
//        // Special handling for grad rate
//        var gradRate = dataObject.graduation_rate
//
//        gradRate = gradRate.replacingOccurrences(of: ".", with: "")
//        var gradRateTemp = gradRate.prefix(2)
//
//        if gradRateTemp.count == 1
//        {
//            gradRateTemp = gradRate + "0"
//        }
//        graduationRateLabel.text = String(gradRateTemp)
//    }
    
    func formatGradRate()
    {
        // Special handling for grad rate
        var gradRate = dataObject.graduation_rate
        
        //gradRate = "" // for testing purposes only
        
        if gradRate.trim().isEmpty
        {
            graduationRateLabel.text = "not available"
        }
        else
        {
            var floatGradRate = Float(gradRate)
            
            floatGradRate = floatGradRate! * 100
            
            //floatGradRate = floatGradRate!/10 // for testing purposes only
            
            let numberOfChars = (floatGradRate! < 10) ? 3 : 2
            
            gradRate = "\(floatGradRate!)"
            
            
            var gradRateTemp = gradRate.prefix(numberOfChars)
            
            
            print(gradRateTemp)
            
            graduationRateLabel.text = String(gradRateTemp)
        }
    }
    
    func formatButton(button:UIButton)
    {
        button.backgroundColor = .NYClightBlueColor
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = button.backgroundColor?.cgColor
        
        button.setTitleColor(.white, for: UIControl.State.normal)

    }
    

    @IBAction func dialPhoneButtonPressed(_ sender: Any)
    {
        // Todo: Test this
        
        let phoneNumber = dataObject.phone_number
        if let url = NSURL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url as URL)
        {
            UIApplication.shared.open(url as URL)
        }
    }
    
    @IBAction func emailSchoolButtonPressed(_ sender: Any)
    {
        if MFMailComposeViewController.canSendMail()
        {
            let emailaddress = dataObject.school_email
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([emailaddress])
            mail.setSubject("Information Request")
            mail.setMessageBody("<p>I'd like information about your school!</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    @IBAction func loadWebsiteButtonPressed(_ sender: Any)
    {
        // Todo: change name of this app so it's not so long in the status bar when loading a page in Safari, for example
        // Todo: spoend more time on this ... some urls seem to need to be cleaned up or validated at runtime
                
        let urlString = dataObject.website
        
        let alert = UIAlertController(title: "School's website is:", message: urlString, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        self.present(alert, animated: true)
    }
    
    

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func fetchData()
    {
        // Todo: implement timeout
        // Todo: Implement app tokens for services
        
        self.showHUD()
        
//        let quoted = """
//                    """
    
        let dbnQuoted = """
        \(dataObject.dbn)
        """

        var urlString = "https://data.cityofnewyork.us/resource/f9bf-2cp4.json"
        urlString = urlString + "?dbn=" + dbnQuoted
        
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
                     var satString = ""

                     for item in json
                     {
                        print(item)
                         if let object = item as? [String: Any]
                         {
                            let sat_math_avg_score = object["sat_math_avg_score"] as? String ?? ""
                            let sat_critical_reading_avg_score = object["sat_critical_reading_avg_score"] as? String ?? ""
                            let sat_writing_avg_score = object["sat_writing_avg_score"] as? String ?? ""

                            satString = "M: \(sat_math_avg_score)  R: \(sat_critical_reading_avg_score)  W: \(sat_writing_avg_score)"
                         }
                     }
                    
                    DispatchQueue.main.async(execute:
                    {
                        if satString.isEmpty
                        {
                            satLabel.text = "Not Available"
                        }
                        else
                        {
                            satLabel.text = satString
                        }
                    })
                    
                 }
                else
                {
                    // Todo: handle this gracefully - notify user to try again, hide tableview.
                    print("could not serialize")
                    
                    DispatchQueue.main.async(execute:
                    {
                        satLabel.text = "Not Available"
                    })
                    
                }
                }
//               catch let error as NSError {
//                    print("Failed to load: \(error.localizedDescription)")
//                }

                DispatchQueue.main.async(execute:
                {
                    // show data
                    self.hideHUD()
                })
            }


        }) { (error) in

            print("Error")

            DispatchQueue.main.async(execute:
            {
                
                // Todo: add niceties here - show error message
//                self.cityNameLabel.text = error.debugDescription
//                self.cityNameLabel.isHidden = false
                self.hideHUD()
            })

            //failure(error)
        }
    }
    
    
    
}
