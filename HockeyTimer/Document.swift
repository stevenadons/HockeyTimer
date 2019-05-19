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
    "KBHBRULES",
    "LADIES",
    "GENTS"
]

let database: [String: (buttonTitle: String, urlString: String)] = [
    
    documentNames[0] : (LS_DOCUMENTNAME_PICTOGRAMU7U8, "https://www.hockey.be/app/uploads/2018/05/Pictogram_spelregels_U7-U8-1.pdf"), // http://www.hockey.be/tiny_mce/plugins/filemanager/files/web/Spelregels/2016/Spelregels_Jeugd/Pictogrammen/Pictogram_spelregels_U7-U8.pdf
    documentNames[1] : (LS_DOCUMENTNAME_PICTOGRAMU9, "https://www.hockey.be/app/uploads/2018/05/Pictogram_spelregels_U9-1.pdf"), // http://www.hockey.be/tiny_mce/plugins/filemanager/files/web/Spelregels/2016/Spelregels_Jeugd/Pictogrammen/Pictogram_spelregels_U9.pdf
    documentNames[2] : (LS_DOCUMENTNAME_PICTOGRAMU10U12, "https://www.hockey.be/app/uploads/2018/05/Pictogram_spelregels_U10-U12-1.pdf"), // "http://www.hockey.be/tiny_mce/plugins/filemanager/files/web/Spelregels/2016/Spelregels_Jeugd/Pictogrammen/Pictogram_spelregels_U10-U12.pdf"
    documentNames[3] : (LS_DOCUMENTNAME_VHLSHOOTOUTS, "https://www.hockey.be/app/uploads/2018/06/spelregels_jeugd_NL01092014.pdf"), // http://www.hockey.be/tiny_mce/plugins/filemanager/files/web/Documenten/Jeugdcommissie/2015/KBHB_SO_U10_officieeldoc.pdf"
    documentNames[4] : (LS_DOCUMENTNAME_VHLRULESU7U12, "https://www.hockey.be/app/uploads/2018/05/Table_Parents-Umpires_-_NL_-_less_U14_-_v1.5.pdf"), // http://www.hockey.be/tiny_mce/plugins/filemanager/files/web/Spelregels/2017/Table_Parents-Umpires_-_NL_-_less_U14_-_v1.5.pdf
    documentNames[5] : (LS_DOCUMENTNAME_VHLRULESU14U19, "https://www.hockey.be/app/uploads/2018/05/Table_Parents-Umpires_-_NL_-_above_U14_-_V1.2.pdf"), // http://www.hockey.be/tiny_mce/plugins/filemanager/files/web/Spelregels/2016/Spelregels_Jeugd/Table_Parents-Umpires_-_NL_-_above_U14_-_V1.1.pdf
    documentNames[6] : (LS_DOCUMENTNAME_FIHRULES, "https://www.hockey.be/app/uploads/2019/04/fih-rules-of-hockey-2019-final-5.pdf"), // http://www.hockey.be/tiny_mce/plugins/filemanager/files/web/Spelregels/2016/2016-2017_-_BEL_Outdoor_Rules_-_NL.pdf
    documentNames[7] : (LS_DOCUMENTNAME_LADIES, "https://www.hockey.be/app/uploads/2018/06/Ladies_rules_NL_2017-2018.pdf"),
    documentNames[8] : (LS_DOCUMENTNAME_GENTS, "https://www.hockey.be/app/uploads/2018/06/Gents_rules_NL_2017-2018-1.pdf")
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
