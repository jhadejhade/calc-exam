//
//  VisionHelper.swift
//  exam-cam-calc
//
//  Created by Jade Lapuz on 5/12/22.
//

import Vision

class VisionHelper {
    
    func createVisionRequest(with cgImage: CGImage, completion: @escaping (Result<String, CalculatorError>) -> Void) {
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                completion(.failure(CalculatorError.cannotBeRead))
                return
            }
            
            let text = observations.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: ", ")
            
            completion(.success(text))
        }
        
        request.recognitionLevel = .accurate
        
        do {
            try handler.perform([request])
        } catch {
            completion(.failure(CalculatorError.cannotBeRead))
        }
    }
}
