//
//  ResultsViewController.swift
//  ScalioAssignment
//
//  Created by gnc on 12/05/2022.
//

import UIKit
import RxSwift
import RxCocoa
import SystemConfiguration

class ResultsViewController: UIViewController
{
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var buttonPrevious: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var labelPage: UILabel!
    @IBOutlet weak var lblNoUsersExist: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    var searchText:String = ""
    public var viewModel:ResultViewModel = ResultViewModel()
    @IBOutlet weak var tblResults: UITableView!
    private var currPage = 1
    private var currRecords = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUIDesign()
        showActivity()
        activity.hidesWhenStopped = true
        self.perform(#selector(bindTableData), with: nil, afterDelay: 0.2)
        btnClose.rx.tap.subscribe { _ in
            self.dismiss(animated: true)
        } onError: { error in
            print("error")
        } onCompleted: {
            print("complete")
        } onDisposed: {
            
        }.disposed(by: bag)
    }
    
    func setUIDesign() {
        buttonPrevious.setBorder()
        buttonNext.setBorder()
        btnClose.setBorder()
    }
    
    let bag = DisposeBag()
    @objc func bindTableData() {
        self.viewModel.arrItems.asObservable().bind(to: tblResults.rx.items(cellIdentifier: "cell", cellType:ResultTableViewCell.self))
           { (row, item, cell) in
               let cellModel = ResultTableViewCellViewModel()
               cellModel.setItem(item: item)
               cell.viewModel = cellModel
           }.disposed(by: bag)
        tblResults.rx.setDelegate(self).disposed(by: bag)
        fetchRecords(pagenumber: currPage)
    }
    
    func fetchRecords(pagenumber:Int) {
        weak var weakSelf = self
        buttonPrevious.isEnabled = false
        buttonNext.isEnabled = false
        self.lblNoUsersExist.isHidden = true
        self.viewModel.fetchResults(inputText: self.searchText, pageno: pagenumber) { recordsCount in
            DispatchQueue.main.async {
                if (recordsCount > 0) {
                    weakSelf?.fetchedResultSettings()
                    weakSelf?.labelPage.text = "Page : \(pagenumber)"
                } else {
                    self.activity.stopAnimating()
                    weakSelf?.lblNoUsersExist.isHidden = false
                }
            }
        } errorHandler: { errorString in
            DispatchQueue.main.async {
                weakSelf?.fetchedResultSettings()
                weakSelf?.view.showToast(message: errorString, font: UIFont.systemFont(ofSize: 12))
            }
        }
    }
    
    func fetchedResultSettings() {
        self.lblNoUsersExist.isHidden = true
        self.buttonPrevious.isEnabled = true
        self.buttonNext.isEnabled = true
        self.activity.stopAnimating()
    }
    
    @IBAction func didTapNextPrevious(_ sender: UIButton) {
        var callAPI = true
        if sender == buttonNext {
            if viewModel.lastCount == Constants.perPageRecords {
                currPage = currPage + 1
            } else if (viewModel.lastCount < Constants.perPageRecords) {
                print("keep same counter")
                callAPI = false
            }
        } else if sender == buttonPrevious {
            if (currPage>1) {
                currPage = currPage - 1
                if currPage < 1  {
                    currPage = 1
                }
            } else {
                callAPI = false
            }
        }
        if callAPI {
            showActivity()
            self.fetchRecords(pagenumber: currPage)
        }
    }
    
    func showActivity() {
        activity.isHidden = false
        activity.startAnimating()
    }
}

extension ResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}


