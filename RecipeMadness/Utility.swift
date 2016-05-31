//
//  Utility.swift
//  RecipeMadness
//
//  Created by Gondela,Chaitanya on 4/15/15.
//  Copyright (c) 2015 Tejesh Kumar Ramisetty. All rights reserved.
//

import UIKit

class Utility: NSObject
{
    class func acceptOnlyCharacter(textField:UITextField)
    {
        var textValue = textField.text
        if(textValue!.utf16.count > 0)
        {
            let char = String(textValue![textValue!.startIndex.advancedBy(textValue!.utf16.count-1)]).unicodeScalars
            var uniVal = char[char.startIndex].value
            if(!((uniVal >= 65 && uniVal <= 90) || (uniVal >= 97 && uniVal <= 122) || uniVal == 32))
            {
                textField.deleteBackward()
            }
        }
    }

    class func acceptOnlyCharacterFollowedByNumbers(textField:UITextField)
    {
        var textValue = textField.text
        if(textValue!.utf16.count > 0)
        {
            let char = String(textValue![textValue!.startIndex.advancedBy(textValue!.utf16.count-1)]).unicodeScalars
            var uniVal = char[char.startIndex].value
            if(textValue!.utf16.count == 1)
            {
                if(!((uniVal >= 65 && uniVal <= 90) || (uniVal >= 97 && uniVal <= 122)))
                {
                    textField.deleteBackward()
                }
            }
            else
            {
                if(!((uniVal >= 48 && uniVal <= 57) || (uniVal >= 65 && uniVal <= 90) || (uniVal >= 97 && uniVal <= 122) || uniVal == 32))
                {
                    textField.deleteBackward()
                }

            }
        }
    }

    class func getDateFromString(string: String) -> NSDate
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        return dateFormatter.dateFromString(string)!
    }
    
    class func getStringFromDate(date: NSDate) -> String
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        return dateFormatter.stringFromDate(date)
    }
}
