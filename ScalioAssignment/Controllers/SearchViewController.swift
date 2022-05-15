//
//  SearchViewController.swift
//  ScalioAssignment
//
//  Created by gnc on 12/05/2022.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    @IBOutlet weak var txtArea: UITextView!
    @IBOutlet weak var btnSubmit: UIButton!
    var bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSubmit.setBorder()
        txtArea.setBorder()
        btnSubmit.rx.tap.subscribe { _ in
            DispatchQueue.main.async {
                if !SCNetworkManager.shared.isConnectedToNetwork() {
                    self.view.showToast(message: "Internet not connected", font: UIFont.systemFont(ofSize: 15))
                    return
                }
                
                if (self.txtArea.text.isEmpty) {
                    self.view.showToast(message: "Please enter search text.", font: UIFont.systemFont(ofSize: 15))
                } else {
                    self.performSegue(withIdentifier: "results", sender: self)
                }
            }
        } onError: { error in
            print("error")
        } onCompleted: {
            print("complete")
        } onDisposed: {
            
        }.disposed(by: bag)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "results" {
            let resultvc = segue.destination as! ResultsViewController
            resultvc.searchText = self.txtArea.text;
        }
    }
}
