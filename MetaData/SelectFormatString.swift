//
//  SelectFormatString.swift
//  MetaData
//
//  Created by Melanija Grunte on 01/02/2018.
//  Copyright © 2018 Melanija Grunte. All rights reserved.
//

import UIKit
import os.log
import RealmSwift

class SelectFormatString: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var selectFormatStringView: UIView!
    @IBOutlet weak var selectFormatStringTableView: UITableView!

    @IBOutlet weak var tableViewWidth: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    
    enum filenameType: String {
        case artistAlbumTrackTitle = "artist - album - track - title"
        case artistAlbumTitle = "artist - album - title"
        case artistTitle = "artist - title"
        case albumTrackTitle = "album - track - title"
        case albumTitle = "album - title"
        case trackTitle = "track - title"
        case title = "title"
        case artistTrackAlbum = "artist - track - album"
        case defaultString = "your default format style"
    }
    
    func filenameString(for type: filenameType) -> String {
        switch type {
        case .artistAlbumTrackTitle:
            return "{artistDescription} - {albumDescription} - {trackDescription} - {titleDescription}"
        case .artistAlbumTitle:
            return "{artistDescription} - {albumDescription} - {titleDescription}"
        case .artistTitle:
            return "{artistDescription} - {titleDescription}"
        case .albumTrackTitle:
            return "{albumDescription} - {trackDescription} - {titleDescription}"
        case .albumTitle:
            return "{albumDescription} - {titleDescription}"
        case .trackTitle:
            return "{trackDescription} - {titleDescription}"
        case .title:
            return "{titleDescription}"
        case .artistTrackAlbum:
            return "{artistDescription} - {trackDescription} - {albumDescription}"
        case .defaultString:
            let realm = try! Realm()
            var customFormatString: Results<CustomFormatStringStyle>?
            customFormatString = realm.objects(CustomFormatStringStyle.self)
            let style = customFormatString?.last
            return style!.stringStyle
        }
    }
    
    let types: [filenameType] = [
        .artistAlbumTrackTitle,
        .artistAlbumTitle,
        .artistTitle,
        .albumTrackTitle,
        .albumTitle,
        .trackTitle,
        .title,
        .artistTrackAlbum,
        .defaultString
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.popViewController(animated: true)
        selectFormatStringTableView.dataSource = self
        selectFormatStringTableView.delegate = self
        selectFormatStringTableView.layer.cornerRadius = 10
        selectFormatStringTableView.layer.masksToBounds = true
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIScreen.main.bounds.size.height == 568 { // iPhone SE
            return 35
        } else { // IPhone 8 ; iPhone 6s Plus ; iPhone 6 Plus ; iPhone 7 ; iPhone 6s ; iPhone 6 ; IPhone 8 Plus ; iPhone 7 Plus ; iPhone X
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if UIScreen.main.bounds.size.height == 568 { // iPhone SE
            tableViewHeight.constant = 315
            tableViewWidth.constant = 250
        } else { // IPhone 8 ; iPhone 6s Plus ; iPhone 6 Plus ; iPhone 7 ; iPhone 6s ; iPhone 6 ; IPhone 8 Plus ; iPhone 7 Plus ; iPhone X
            tableViewHeight.constant = 360
            tableViewWidth.constant = 300
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.textAlignment = .center

        cell.textLabel?.text = types[indexPath.row].rawValue
        cell.textLabel?.font = cell.textLabel?.font.withSize(20)

        let realm = try! Realm()

        var fileRenamingChoice: Results<FileRenamingChoice>?
        fileRenamingChoice = realm.objects(FileRenamingChoice.self)
        let format = fileRenamingChoice?.last

        if indexPath == IndexPath(row: (format?.chosenTag)!, section: 0) {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }

        if UIScreen.main.bounds.size.height == 568 { // iPhone SE
            cell.textLabel?.font = cell.textLabel?.font.withSize(15)
        } else {
            cell.textLabel?.font = cell.textLabel?.font.withSize(18)
        }

        var customFormatString: Results<CustomFormatStringStyle>?
        customFormatString = realm.objects(CustomFormatStringStyle.self)
        let style = customFormatString?.last
        if style!.stringStyle == "" && indexPath.row == 8 {
            let customStringStyleCell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cellWithACustomStyle")
            customStringStyleCell.textLabel?.textColor = UIColor(white: 0.75, alpha:1)
            customStringStyleCell.textLabel?.text = types[indexPath.row].rawValue
//            if UIScreen.main.bounds.size.height == 568 { // iPhone SE
//                customStringStyleCell.textLabel?.font = cell.textLabel?.font.withSize(15)
//            } else {
//                customStringStyleCell.textLabel?.font = cell.textLabel?.font.withSize(20)
//            } // man nepatīk, neiedarbojas, !!!
            customStringStyleCell.selectionStyle = UITableViewCellSelectionStyle.gray
            customStringStyleCell.isUserInteractionEnabled = false
            return customStringStyleCell
        }
        return cell
    }
    
    // MARK: actions
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = types[indexPath.row]
        let realm = try! Realm()

        let fileRenamingChoice = realm.objects(FileRenamingChoice.self)
        try! realm.write {
            fileRenamingChoice.setValue(filenameString(for: type), forKeyPath: "chosenStyle")
            fileRenamingChoice.setValue(indexPath.row, forKeyPath: "chosenTag")
        }

        for row in 0...8 {
            tableView.cellForRow(at: IndexPath(row: row, section: 0))?.accessoryType = UITableViewCellAccessoryType.none
        }

        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark

        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}

