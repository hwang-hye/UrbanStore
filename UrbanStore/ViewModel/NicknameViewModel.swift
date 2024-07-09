//
//  NicknameViewModel.swift
//  UrbanStore
//
//  Created by hwanghye on 7/9/24.
//

import Foundation

class NicknameViewModel {
    
    var inputId: Observable<String?> = Observable("")
    var outputValidationText = Observable("")
    var outputValid = Observable(false)
    
    init() {
        print("ViewModel Init")
        inputId.bind { _ in // value in
            self.validation()
        }
    }
    
    private func validation() {
        guard let id = inputId.value else {
            return
        }
        if id.isEmpty {
            outputValid.value = false
            outputValidationText.value = "2글자 이상 10글자 미만으로 설정해주세요"
            return
        }
        
        if id.count >= 2 && id.count <= 10 {
            if id.range(of: "[@#$%]", options: .regularExpression) != nil {
                outputValid.value = false
                outputValidationText.value = "닉네임에 @, #, $, % 는 사용할 수 없어요"
                return
            }
            
            if id.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
                outputValid.value = false
                outputValidationText.value = "닉네임에 숫자는 포함할 수 없어요"
                return
            }
            
            outputValid.value = true
            outputValidationText.value = "사용할 수 있는 닉네임이에요"
            return
            
        } else {
            outputValid.value = false
            outputValidationText.value = "2글자 이상 10글자 미만으로 설정해주세요"
        }
    }
}
