//
//  Document.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 12/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import Foundation

let documentNames: [String] = [
    
    "PICTOGRAMU7U8",
    "PICTOGRAMU9",
    "PICTOGRAMU10U12",
    "VHLSHOOTOUTS",
    "VHLRULESU7U12",
    "VHLRULESU14U19",
    "KBHBRULES"
]

let database: [String: (buttonTitle: String, urlString: String)] = [
    
    documentNames[0] : (LS_DOCUMENTNAME_PICTOGRAMU7U8, "http://www.hockey.be/tiny_mce/plugins/filemanager/files/web/Spelregels/2016/Spelregels_Jeugd/Pictogrammen/Pictogram_spelregels_U7-U8.pdf"),
    documentNames[1] : (LS_DOCUMENTNAME_PICTOGRAMU9, "http://www.hockey.be/tiny_mce/plugins/filemanager/files/web/Spelregels/2016/Spelregels_Jeugd/Pictogrammen/Pictogram_spelregels_U9.pdf"),
    documentNames[2] : (LS_DOCUMENTNAME_PICTOGRAMU10U12, "http://www.hockey.be/tiny_mce/plugins/filemanager/files/web/Spelregels/2016/Spelregels_Jeugd/Pictogrammen/Pictogram_spelregels_U10-U12.pdf"),
    documentNames[3] : (LS_DOCUMENTNAME_VHLSHOOTOUTS, "http://www.hockey.be/tiny_mce/plugins/filemanager/files/web/Documenten/Jeugdcommissie/2015/KBHB_SO_U10_officieeldoc.pdf"),
    documentNames[4] : (LS_DOCUMENTNAME_VHLRULESU7U12, "http://www.hockeyvl.be/tiny_mce/plugins/filemanager/files/web/Reglementen/2015_2016/Table_Parents-Umpires_-_NL_-_less_U14_-_v1.3.pdf"),
    documentNames[5] : (LS_DOCUMENTNAME_VHLRULESU14U19, "http://www.hockeyvl.be/tiny_mce/plugins/filemanager/files/web/Reglementen/2015_2016/Table_Parents-Umpires_-_NL_-_above_U14_-_V1.1.pdf"),
    documentNames[6] : (LS_DOCUMENTNAME_KBHBRULES, "http://www.hockey.be/tiny_mce/plugins/filemanager/files/web/Spelregels/2016/2016-2017_-_BEL_Outdoor_Rules_-_NL.pdf")

]

struct Document {
    
    
    // MARK: - Properties
    
    var name: String!
    var buttonTitle: String!
    var url: String!
    
    
    // MARK: - Initializing
    
    init(name: String) {
        
        self.name = name
        self.buttonTitle = database[name]?.buttonTitle ?? "NO TITLE"
        self.url = database[name]?.urlString ?? "NO URL"
    }
    
    
    // MARK: - Static func
    
    static func allDocuments() -> [Document] {
        
        var documents: [Document] = []
        for name in documentNames {
            documents.append(Document(name: name))
        }
        return documents
    }

    
    
}
