//
//  DetailViewController.swift
//  Users-test-task
//
//  Created by Евгений Дац on 13.11.2017.
//  Copyright © 2017 Evgeny Dats. All rights reserved.
//

import UIKit
import Eureka
import MMUploadImage
import CustomLoader
import NotificationBannerSwift

fileprivate let cloudnaryManager = try! AppDelegate.assembly.resolve() as CloudnaryManager
class DetailViewController: FormViewController {
    private let model = try! AppDelegate.assembly.resolve() as UserModel
    
    var isEdit: Bool = false
    var userHeader: UserHeader?
    var selectImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        configForms()
        title = isEdit ? "Редактировать" : "Новый пользователь"
        tableView.backgroundColor = UIColor.lightBlue
        tableView.separatorStyle = .none
        cloudnaryManager.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Configs
    func configForms() {
        let ruleRequiredViaClosure = RuleClosure<String> { rowValue in
            return (rowValue == nil || rowValue!.isEmpty) ? ValidationError(msg: "Обязательное поле!") : nil
        }
        let emailRuleRequiredViaClosure = RuleEmail(msg: "Введите email в формате support@apple.com")
        var footer: String {
            guard self.isEdit else { return "" }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            dateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
            
            guard let dateObj = dateFormatter.date(from: self.model.user.updatedAt ?? "") else { return "" }
            
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            dateFormatter.locale = Locale.current
            return "Обновлено \(dateFormatter.string(from: dateObj))"
        }
        
        form +++
            Section() {
                var header = HeaderFooterView<UserHeader>(.nibFile(name: "UserHeader", bundle: nil))
                header.onSetupView = { [weak self] (view, section) -> () in
                    guard let strongSelf = self else { return }
                    view.backgroundColor = UIColor.lightBlue
                    if let avatarUrl = strongSelf.model.user.avatarUrl, avatarUrl != "" {
                        view.avatarImageView.af_setImage(withURL: URL(string: avatarUrl)!,
                                                         placeholderImage: UIImage(named: "person-placeholder.png"),
                                                         imageTransition: .crossDissolve(0.2),
                                                         runImageTransitionIfCached: false)
                    } else {
                        view.avatarImageView.image = UIImage(named: "person-placeholder.png")
                    }
                    view.avatarImageView.isUserInteractionEnabled = true
                    let tap = UITapGestureRecognizer(target: self, action: #selector(strongSelf.selectImageAction))
                    view.avatarImageView.addGestureRecognizer(tap)
                    strongSelf.userHeader = view
                }
                $0.header = header
            }
            
            +++ TextFloatLabelRow() {
                $0.title = "Имя"
                $0.value = model.user.firstName
                $0.add(rule: ruleRequiredViaClosure)
                $0.validationOptions = .validatesOnChange
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                    }
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
                }
                .onChange({ [weak self] (row) in
                    guard let strongSelf = self else { return }
                    strongSelf.model.user.firstName = row.value
                })
            +++ TextFloatLabelRow() {
                $0.title = "Фамилия"
                $0.value = model.user.lastName
                $0.add(rule: ruleRequiredViaClosure)
                $0.validationOptions = .validatesOnChange
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
                }
                .onChange({ [weak self] (row) in
                    guard let strongSelf = self else { return }
                    strongSelf.model.user.lastName = row.value
                })
            +++ TextFloatLabelRow() {
                $0.title = "Email"
                $0.value = model.user.email
                $0.add(rule: ruleRequiredViaClosure)
                $0.add(rule: emailRuleRequiredViaClosure)
                $0.validationOptions = .validatesOnChangeAfterBlurred
                } .cellUpdate { cell, row in
                    if !row.isValid {
                    }
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
                }
                .onChange({ [weak self] (row) in
                    guard let strongSelf = self else { return }
                    strongSelf.model.user.email = row.value
                })
            +++ Section(footer: footer)
            <<< ButtonRow() {
                $0.title = isEdit ? "Сохранить" : "Добавить"
                }
                .cellSetup({ (cell, row) in
                    cell.tintColor = UIColor.white
                })
                .onCellSelection { [weak self] cell, row in
                    guard let strongSelf = self else { return }
                    row.section?.form?.validate()
                    if let error = row.section?.form?.validate(), error.count != 0 {
                        print(error)
                        let banner = NotificationBanner(title: "Ошибка", subtitle: "Проверьте все поля!", style: .danger)
                        banner.show(queuePosition: .front)
                    } else {
                        strongSelf.isEdit ? strongSelf.model.editUser() : strongSelf.model.addNewUser()
                    }
        }
    }
    
    
    @objc func selectImageAction() {
        _ = LoadingView.system(withStyle: .whiteLarge).show(inView: (userHeader?.avatarImageView)!)
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.videoQuality = .typeLow
        self.present(picker, animated: true) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.userHeader?.avatarImageView.removeLoadingViews(animated: true)
        }
    }
    
    // MARK: - Navigation

    static func storyboardInstance() -> DetailViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController() as? DetailViewController
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }

}

// MARK: - UITableView DataSource & Delegate
extension DetailViewController {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        if indexPath.section == 4 {
            cell.backgroundColor = UIColor.buttonGray
        }
    }
}

// MARK: - UIImagePicker Delegate
extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if  let img = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectImage = img
            cloudnaryManager.uploadImage(image: img)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - CloudnaryManager Delegate
extension DetailViewController: CloudnaryManagerDelegate {
    func didUpdateProgress(progress: Progress) {
        userHeader?.avatarImageView.uploadImage(image: selectImage!, progress: Float(progress.fractionCompleted))
    }
    
    func didUploadImage(url: String) {
        userHeader?.avatarImageView.uploadCompleted()
        model.user.avatarUrl = url
    }
}
