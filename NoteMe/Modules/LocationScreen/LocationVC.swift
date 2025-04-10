//
//  LocationVC.swift
//  NoteMe
//
//  Created by Алексей Кононенко on 9.04.25.
//

import UIKit

protocol LocationViewModelProtocol {
    
}

final class LocationVC: UIViewController {
    
    private let viewModel: LocationViewModelProtocol
    
    init(viewModel: LocationViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
