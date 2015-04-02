//
//  RecordedAudio.swift
//  Pitch Perfect v2
//
//  Created by Forlì Damiano on 3/26/15.
//  Copyright (c) 2015 GE. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}