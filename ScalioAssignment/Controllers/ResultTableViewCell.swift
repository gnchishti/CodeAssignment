//
//  ResultTableViewCell.swift
//  ScalioAssignment
//
//  Created by gnc on 13/05/2022.
//

import UIKit
import RxSwift
import RxCocoa

class ResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelLogin: UILabel!
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var imgAvatar: UIImageView!
    
    var viewModel: ResultTableViewCellViewModel! {
        didSet {
            activity.hidesWhenStopped = true
            self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.height/2
            self.viewModel.login.asObservable().bind(to: self.labelLogin.rx.text).disposed(by: bag)
            self.viewModel.type.asObservable().bind(to: self.labelType.rx.text).disposed(by: bag)
            self.viewModel.avatar_url.subscribe { stringurl in
                DispatchQueue.main.async {
                    self.activity.isHidden = false
                    self.activity.startAnimating()
                    self.imgAvatar.image = UIImage.init(named: "avatar")
                    SCNetworkManager.shared.loadImage(strImageUrl: stringurl) { img in
                        self.activity.stopAnimating()
                        self.imgAvatar.image = img
                    } errorHandler: { errorString in
                        self.activity.stopAnimating()
                    }
                }
            } onError: { error in
                print("error")
            } onCompleted: {
                print("complete")
            } onDisposed: {
                
            }.disposed(by: bag)
        }
    }
    let bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

