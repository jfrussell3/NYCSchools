//
//  SchoolDataModel.swift
//  20210918-JohnRussell-NYCSchools
//
//  Created by john Russell on 9/18/21.
//

import Foundation

struct SchoolDataModel : Codable
{
    var school_name:String
    var dbn:String
    var zip:String
    var borough:String
    var neighborhood:String
    var city:String
    var primaryAddressLine1:String
    var phone_number:String
    var website:String
    var total_students:String
    var campusName:String
    var school_email:String
    var graduation_rate:String
    var finalGrades:String
    
    init(school_name:String , dbn:String, zip:String , borough:String, neighborhood:String , city:String, primaryAddressLine1:String, phone_number:String, website:String,  total_students:String, campusName:String, school_email:String, graduation_rate:String, finalGrades:String)
    {
        self.school_name = school_name
        self.dbn = dbn
        self.zip = zip
        self.borough = borough
        self.neighborhood = neighborhood
        self.city = city
        self.primaryAddressLine1 = primaryAddressLine1
        self.phone_number = phone_number
        self.website = website
        self.total_students = total_students
        self.campusName = campusName
        self.school_email = school_email
        self.graduation_rate = graduation_rate
        self.finalGrades = finalGrades
        
    }
}
