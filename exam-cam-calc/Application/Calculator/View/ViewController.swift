//
//  ViewController.swift
//  exam-cam-calc
//
//  Created by Jade Lapuz on 5/11/22.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var resultLabel: UILabel!
    @IBOutlet private weak var equationLabel: UILabel!
    
    private var subscriptions = Set<AnyCancellable>()
    
    var backgroundColor: UIColor!
    var visionHelper = VisionHelper()
    var imagePicker: ImagePicker!
    var viewModel: CalculatorViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backgroundColor
        setupBindings()
    }
    
    private func setupBindings() {
        viewModel.equationPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] equation in
                self?.equationLabel.text = String(format: "Image result: %@", equation)
            }
            .store(in: &subscriptions)
        
        viewModel.resultPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.resultLabel.text = String(format: "The result is: %@", result)
            }
            .store(in: &subscriptions)
    }
    
    @IBAction func beginButtonTapped(_ sender: UIButton) {
        imagePicker.present(from: sender)
    }
}

extension ViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        guard let pickedImage = image, let cgImage = pickedImage.cgImage else {
            return
        }
        
        self.image.image = pickedImage
        visionHelper.createVisionRequest(with: cgImage) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.viewModel.processError(error: error)
            case .success(let result):
                self?.viewModel.calculate(equation: result)
            }
        }
    }
}
