//
//  DPPImageEditor.swift
//  MM1.1PickingAnImage
//
//  Created by Andres Kwan on 12/3/15.
//  Copyright © 2015 Kwan. All rights reserved.
//

import Foundation
import imglyKit

internal let PhotoProcessorQueue = dispatch_queue_create("ly.img.SDK.PhotoProcessor", DISPATCH_QUEUE_SERIAL)

class DPPImageEditorViewController: UIViewController {

    // MARK: - Properties
    
    var shouldShowActivityIndicator = true
    
    var updating = false {
        didSet {
            if shouldShowActivityIndicator {
                dispatch_async(dispatch_get_main_queue()) {
                    if self.updating {
                        self.activityIndicatorView.startAnimating()
                    } else {
                        self.activityIndicatorView.stopAnimating()
                    }
                }
            }
        }
    }
    
    var lowResolutionImage: UIImage?

    var enableZoomingInPreviewImage: Bool {
        // Subclasses should override this to enable zooming
        return false
    }

//        private(set) lazy var previewImageView: IMGLYZoomingImageView =
    @IBOutlet weak lazy var previewImageView: IMGLYZoomingImageView? = {
        let imageView = IMGLYZoomingImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.userInteractionEnabled = self.enableZoomingInPreviewImage
        return imageView
    }()
    
    private(set) lazy var bottomContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //TODO: should be disney activity indicator
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationItems()
        configureViewHierarchy()
        configureViewConstraints()
    }

    
    // MARK: - Configuration
    private func configureNavigationItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "tappedDone:")
    }
    //if storyboard, then this is not needed
    private func configureViewHierarchy() {
        view.backgroundColor = UIColor.redColor()
        
        view.addSubview(previewImageView!)
        view.addSubview(bottomContainerView)
        previewImageView!.addSubview(activityIndicatorView)
    }
    //
    private func configureViewConstraints() {
//        let views: [String: AnyObject] = [
//            "previewImageView" : previewImageView,
//            "bottomContainerView" : bottomContainerView,
//            "topLayoutGuide" : topLayoutGuide
//        ]
//        
//        let metrics: [String: AnyObject] = [
//            "bottomContainerViewHeight" : 100
//        ]
//        //Visual format Language
//        // |[]| connection to supperview
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[previewImageView]|", options: [], metrics: nil, views: views))
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[bottomContainerView]|", options: [], metrics: nil, views: views))
//        // V:[][][xxx(==xxxHeight)] vertical layout, metrics
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[topLayoutGuide][previewImageView][bottomContainerView(==bottomContainerViewHeight)]|", options: [], metrics: metrics, views: views))
        
        previewImageView!.addConstraint(NSLayoutConstraint(item: activityIndicatorView, attribute: .CenterX, relatedBy: .Equal, toItem: previewImageView, attribute: .CenterX, multiplier: 1, constant: 0))
        previewImageView!.addConstraint(NSLayoutConstraint(item: activityIndicatorView, attribute: .CenterY, relatedBy: .Equal, toItem: previewImageView, attribute: .CenterY, multiplier: 1, constant: 0))
    }
    

    
}
