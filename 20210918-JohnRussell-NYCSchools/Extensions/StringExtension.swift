//
//  StringExtension.swift
//  20210918-JohnRussell-NYCSchools
//
//  Created by john Russell on 9/20/21.
//

import UIKit


extension String
{
      func trim() -> String{
         return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
       }

    
}
