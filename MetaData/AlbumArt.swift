import RealmSwift
//
//  AlbumArt.swift
//  MetaData
//
//  Created by Melanija Grunte on 12/02/2018.
//  Copyright © 2018 Melanija Grunte. All rights reserved.
//

import UIKit

class AlbumArt: UIViewController {

    var image: UIImage? = nil
    // var song: Song?

    @IBOutlet weak var bigAlbumArt: UIImageView!
    @IBOutlet weak var albumArtfilename: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if image != nil {
            bigAlbumArt.image = image
            //albumArtfilename.text = song.albumArtImage

            view.backgroundColor = .clear // In order for the UIVisualEffectView to actually blur the content, its superview must be transparent. To do this, you change the background color to be clear.
            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            view.addSubview(blurEffectView)

            blurEffectView.superview?.bringSubview(toFront: bigAlbumArt)
        } else {
            print("image not found")
        }

    }

    @IBAction func pressToDismiss(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}

