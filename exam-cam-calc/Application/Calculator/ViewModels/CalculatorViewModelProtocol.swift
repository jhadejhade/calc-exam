//
//  CalculatorViewModelProtocol.swift
//  exam-cam-calc
//
//  Created by Jade Lapuz on 5/11/22.
//

import Combine
import UIKit

protocol CalculatorViewModelProtocol {
    var equationPublisher: Published<String>.Publisher { get }
    var resultPublisher: Published<String>.Publisher { get }
    func calculate(equation: String)
    func processError(error: CalculatorError)
}
