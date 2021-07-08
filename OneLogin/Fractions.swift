//
//  Fractions.swift
//  OneLogin
//
//  Created by Miguel Aquino on 06/07/21.
//

import Foundation

enum OptionType: String {
    case fractions = "f"
    case help = "h"
    case quit = "q"
    case unknown
    
    init(value: String) {
        switch value {
        case "f": self = .fractions
        case "h": self = .help
        case "q": self = .quit
        default: self = .unknown
        }
    }
}

struct Expression {
    var operand1: String
    var legalOperator: String
    var operand2: String
}

struct Operand {
    var wholeNumber: Int
    var numerator: Int
    var denominator: Int
}

class Fractions {
    
    static let shared = Fractions()
    
    let consoleIO = ConsoleIO()
    
    func getOption(_ option: String) -> (option:OptionType, value: String) {
        return (OptionType(value: option), option)
    }
    
    func getInput() {
        
        consoleIO.writeMessage("Welcome to this command line tool to resolve operations with fractions.")
        
        var shouldQuit = false
        while !shouldQuit {
            
            consoleIO.writeMessage("\nType 'f' to start writing your operation with fractions or 'h' for help. Type 'q' to quit.")
            let (option, value) = getOption(consoleIO.getKeyboardInput())
            
            switch option {
            case .fractions:
                consoleIO.writeMessage("Type the operation to resolve (e.g. 1/2 * 3_3/4, 2_3/8 + 9/8):")
                let operation = consoleIO.getKeyboardInput()
                
                consoleIO.writeMessage(resolve(operation: operation))
            case .help:
                consoleIO.writeMessage("HELP: Legal operators shall be *, /, +, - (multiply, divide, add, subtract)\n" +
                      "Operands and operators shall be separated by one or more spaces\n" +
                      "Mixed numbers will be represented by whole_numerator/denominator. e.g. 3_1/4\n" +
                      "Improper fractions and whole numbers are also allowed as operands\n")
            case .quit:
                shouldQuit = true
            case .unknown:
                consoleIO.writeMessage("Unknown option \(value)", to: .error)
            }
        }
    }
    
    func resolve(operation: String) -> String {
        return splitOperation(operation: operation)
    }
    
    func splitOperation(operation: String) -> String {
        
        let operationWithNoExtraSpaces = operation.removeExtraSpaces
        
        let fullOperation = operationWithNoExtraSpaces.components(separatedBy: " ")
        
        if fullOperation.count >= 3 {
            let expression  = Expression(operand1: fullOperation [0],
                                         legalOperator: fullOperation [1],
                                         operand2: fullOperation [2])
            
            return handleOperator(expression: expression)
        
        } else {
            return "Failed to get operands and operators"
        }
    }
    
    func handleOperator(expression: Expression) -> String{
        switch expression.legalOperator {
        case "+":
            return add(expression: expression)
        case "-":
            return subtract(expression: expression)
        case "/":
            return divide(expression: expression)
        case "*":
             return multiply(expression: expression)
        default:
            return "Illegal operator \(expression.legalOperator)"
        }
    }
    
    /// Function used to separate the whole number, numerator and denominator from the operand received as a`String` .
    /// - Parameter operand: Contains the whole number, numerator and denominator in a `String`.
    /// - Returns: `Operand` which contains a whole number, numerator and a denominator.
    func getWholeNumberAndFraction(operand: String) -> Operand {
        
        var wholeNumber = Int()
        var numerator = Int()
        var denominator = Int()
        
        if operand.contains("_") {
            wholeNumber = Int(operand.components(separatedBy: "_")[0]) ?? 0
            
            if operand.contains("/") {
                var fraction = operand.components(separatedBy: "_")
                fraction = fraction[1].components(separatedBy: "/")
                
                numerator = Int(fraction[0]) ?? 0
                denominator = Int(fraction[1]) ?? 1
            }
        
        } else if operand.contains("/") {
            numerator = Int(operand.components(separatedBy: "/")[0]) ?? 0
            denominator = Int(operand.components(separatedBy: "/")[1]) ?? 1
            
        } else {
            wholeNumber = 0
            numerator = Int(operand) ?? 0
            denominator = 1
        }
        
        return Operand(wholeNumber: wholeNumber, numerator: numerator, denominator: denominator)
    }
    
    
    /// Function that receives 2 parameters, the denominator from the first and second operand.
    /// - Parameters:
    ///   - denominator1: first denominator
    ///   - denominator2: second denominator
    /// - Returns: 3 paramaters,
    /// the first parameter is the common denominator
    /// the second parameter is the multiplier for the first numerator
    /// the third parameter is the multiplier for the second numerator
    func getCommonDenominator(denominator1: Int, denominator2: Int) -> (Int, Int, Int) {
        if (denominator1 == 0 && denominator2 != 0) {
            return (denominator2, denominator2, 1)
        
        } else if (denominator2 == 0 && denominator1 != 0) {
            return (denominator1, 1, denominator1)
        }
        
        if  (denominator1 == 0 && denominator2 == 0) {
            return (0,0,0)
        }
        if (denominator1 % denominator2 == 0) {
            return (denominator1, 1, denominator1 / denominator2)
            
        } else if (denominator2 % denominator1 == 0) {
            return (denominator2, denominator2 / denominator1, 1)
        
        } else {
            return (denominator1 * denominator2, denominator2, denominator1)
        }
    }
    
    /// Function used to get the whole number and residual of a fraction
    /// - Parameters:
    ///   - numerator: The numerator of the fraction
    ///   - denominator: The denominator of the fraction
    /// - Returns: 2 parameters
    /// the first parameter is the `whole number`
    /// the second parameter is the `remainder`
    func checkFractionForWholeNumber(numerator: Int, denominator: Int) -> (Int, Int){
        var wholeNumber = Int()
        var remainder = Int()
        
        if numerator > denominator {
            wholeNumber  = numerator / denominator
            remainder = numerator % denominator
            
            return (wholeNumber, remainder)
        }
        
        return (0, numerator)
    }
    
    
    func add(expression: Expression) -> String {
        let operand1 = getWholeNumberAndFraction(operand: expression.operand1)
        let operand2 = getWholeNumberAndFraction(operand: expression.operand2)
        
        var wholeNumbers = operand1.wholeNumber + operand2.wholeNumber
        
        let result = getCommonDenominator(denominator1: operand1.denominator, denominator2: operand2.denominator)
        
        if result.0 == 0 {
            return "Cannot have denominators equal to 0"
        }
        
        let commonDenominator = result.0
        let numerator1 = result.1 * operand1.numerator
        let numerator2 = result.2 * operand2.numerator
        
        var finalNumerator = numerator1 + numerator2
        
        
        let fractionResult = checkFractionForWholeNumber(numerator: finalNumerator, denominator: commonDenominator)
        
        wholeNumbers = wholeNumbers + fractionResult.0
        finalNumerator = fractionResult.1
        
        return checkSimplification(wholeNumber: wholeNumbers,
                                   finalNumerator: finalNumerator,
                                   finalDenominator: commonDenominator)
    }
    
    func subtract(expression: Expression) -> String {
        let operand1 = getWholeNumberAndFraction(operand: expression.operand1)
        let operand2 = getWholeNumberAndFraction(operand: expression.operand2)
        
        var wholeNumbers = operand1.wholeNumber - operand2.wholeNumber
        
        let result = getCommonDenominator(denominator1: operand1.denominator, denominator2: operand2.denominator)
        
        if result.0 == 0 {
            return "Cannot have denominators equal to 0"
        }
        
        let commonDenominator = result.0
        let numerator1 = result.1 * operand1.numerator
        let numerator2 = result.2 * operand2.numerator
        
        var finalNumerator = numerator1 - numerator2
        
        let fractionResult = checkFractionForWholeNumber(numerator: finalNumerator, denominator: commonDenominator)
        
        wholeNumbers = wholeNumbers + fractionResult.0
        
        finalNumerator = fractionResult.1
        
        return checkSimplification(wholeNumber: wholeNumbers,
                                   finalNumerator: finalNumerator,
                                   finalDenominator: commonDenominator)
    }
    
    func multiply(expression: Expression) -> String {
        let operand1 = getWholeNumberAndFraction(operand: expression.operand1)
        let operand2 = getWholeNumberAndFraction(operand: expression.operand2)
        
        if (operand1.denominator == 0 || operand2.denominator == 0) {
            consoleIO.writeMessage("Cannot have denominators equal to 0", to: .error)
            return "Cannot have denominators equal to 0"
        }
        
        var firstNumerator = Int()
        var secondNumerator = Int()
        
        if operand1.wholeNumber != 0 {
            firstNumerator = operand1.denominator * operand1.wholeNumber + operand1.numerator
        
        } else {
            firstNumerator = operand1.numerator
        }
        
        if operand2.wholeNumber != 0 {
            secondNumerator = operand2.denominator * operand2.wholeNumber + operand2.numerator
        } else {
            secondNumerator = operand2.numerator
        }
        
        let firstDenominator = operand1.denominator
        let secondDenominator = operand2.denominator
        
        var finalNumerator = firstNumerator * secondNumerator
        let finalDenominator = firstDenominator * secondDenominator
        
        let fractionResult = checkFractionForWholeNumber(numerator: finalNumerator, denominator: finalDenominator)
        let wholeNumber = fractionResult.0
        
        finalNumerator = fractionResult.1
        
        return checkSimplification(wholeNumber: wholeNumber,
                                   finalNumerator: finalNumerator,
                                   finalDenominator: finalDenominator)
    }
    
    func divide (expression: Expression) -> String {
        let operand1 = getWholeNumberAndFraction(operand: expression.operand1)
        let operand2 = getWholeNumberAndFraction(operand: expression.operand2)
        
        if (operand1.denominator == 0 || operand2.denominator == 0) {
            return "Cannot have denominators equal to 0"
        }
        
        var firstNumerator = Int()
        var secondNumerator = Int()
        
        if operand1.wholeNumber != 0 {
            firstNumerator = operand1.denominator * operand1.wholeNumber + operand1.numerator
        
        } else {
            firstNumerator = operand1.numerator
        }
        
        if operand2.wholeNumber != 0 {
            secondNumerator = operand2.denominator * operand2.wholeNumber + operand2.numerator
        } else {
            secondNumerator = operand2.numerator
        }
        
        let firstDenominator = operand1.denominator
        let secondDenominator = operand2.denominator
        
        var finalNumerator = firstNumerator * secondDenominator
        let finalDenominator = firstDenominator * secondNumerator
        
        let fractionResult = checkFractionForWholeNumber(numerator: finalNumerator, denominator: finalDenominator)
        let wholeNumber = fractionResult.0
        
        finalNumerator = fractionResult.1
        
        return checkSimplification(wholeNumber: wholeNumber,
                                   finalNumerator: finalNumerator,
                                   finalDenominator: finalDenominator)
    }
    
    func checkSimplification(wholeNumber: Int, finalNumerator: Int, finalDenominator: Int ) -> String {
        if finalNumerator != 0 && wholeNumber != 0 {
            return "= \(wholeNumber)_\(finalNumerator)/\(finalDenominator)"
        }
        else if wholeNumber == 0 {
            return "= \(finalNumerator)/\(finalDenominator)"
        }
        else {
            return "= \(wholeNumber)"
        }
    }
}


extension String {

    var removeExtraSpaces: String {
        return replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression, range: nil)
    }
}
