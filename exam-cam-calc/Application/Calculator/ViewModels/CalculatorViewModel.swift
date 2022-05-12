//
//  CalculatorViewModel.swift
//  exam-cam-calc
//
//  Created by Jade Lapuz on 5/11/22.
//

import Combine
import Vision

enum CalculatorError: Error {
    case invalidInput
    case cannotBeRead
    
    var description: String {
        switch self {
        case .invalidInput:
            return "Invalid Input"
        case .cannotBeRead:
            return "Cannot be read. Please re-take the photo and make sure it is clear."
        }
    }
}

class CalculatorViewModel: CalculatorViewModelProtocol {
    
    @Published var equation: String = ""
    @Published var result: String = ""
    
    var equationPublisher: Published<String>.Publisher {
        return $equation
    }
    
    var resultPublisher: Published<String>.Publisher {
        return $result
    }
   
    func calculate(equation: String) {
        self.equation = equation
        let mathExpression = NSExpression(format: equation)
        // I used swifts built in predicate reader for getting the result. Please let me know if you want this changed.
        if let expressionResult = mathExpression.expressionValue(with: nil, context: nil) as? Double {
            self.result = expressionResult.description
        } else {
            processError(error: CalculatorError.invalidInput)
        }
        
    }
    
    func processError(error: CalculatorError) {
        equation = error.description
        result = "0"
    }
}
