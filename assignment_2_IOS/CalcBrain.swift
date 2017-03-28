//
//  CalcBrain.swift
//  assignment_2_IOS
//
//  Created by Home on 26/02/15.
//  Copyright (c) 2015 nl.han.ica.mad. All rights reserved.
//

import Foundation

class CalcBrain:CustomStringConvertible {

    
    var variableValues = [String: Double]()
    private var knownOps = [String:Op]()
    private var opStack = [Op]()
    var evaluationResult : Double?
    var resultTest = ""
    var historyStackReady = false
    class History {
        var historyOperation: String
        var result: String
        var textWidth: Int
        init(historyOperation: String,result: String, textWidth: Int) {
            self.historyOperation = historyOperation
            self.result = result
            self.textWidth = textWidth
        }
    }
    var historyStack = History(historyOperation: "", result: "", textWidth: 0)
    
    private enum Op: CustomStringConvertible{
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double,Double)->Double)
        case CustomVariable(String)
        case PiVariable(String, Double)
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .CustomVariable(let symbol):
                    return "\(symbol)"
                case .PiVariable(let symbol,let value):
                    return "\(symbol)"
                }
                
            }
        }
    }
    var description: String {
        get{
            var (result, ops) = ("", opStack)
            var curVal = ""
            repeat {
                var currentValue: String?
                (currentValue, ops) = description(ops)
                result = result == "" ? currentValue! : "\(currentValue!), \(result)"
                curVal = currentValue!
            } while ops.count > 0
            if let evRes = evaluationResult{
                handleHistory(result, result: " = \(evRes)")
            }
            return result
        }
    }
    
    init(){
        knownOps["+"] = Op.BinaryOperation("+"){$0 + $1}
        knownOps["−"] = Op.BinaryOperation("−"){$1 - $0}
        knownOps["×"] = Op.BinaryOperation("×"){$0 * $1}
        knownOps["÷"] = Op.BinaryOperation("÷"){$1 / $0}
        knownOps["√"] = Op.UnaryOperation("√"){sqrt($0)}
        knownOps["cos"] = Op.UnaryOperation("cos"){cos($0)}
        knownOps["sin"] = Op.UnaryOperation("sin"){sin($0)}
        knownOps["π"] = Op.PiVariable("π", M_PI)
        
    }
    func pushToOpStack(operand: Double) -> Double?{
            opStack.append(Op.Operand(operand))
            return evaluate()
    }
    func pushToOpStack(symbol: String)-> Double?{
        if symbol == "π"{
            opStack.append(Op.PiVariable("π",3.14))
            return evaluate()
        }
        
        opStack.append(Op.CustomVariable(symbol))
        return evaluate()
 
    }
    func performOperation(symbol: String) -> Double?{
        
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        
        return evaluate()
    }
    private func description(ops: [Op]) -> (result: String?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (String(format: "%g", operand) , remainingOps)
            case .UnaryOperation(let symbol, _):
                let operandEvaluation = description(remainingOps)
                if let operand = operandEvaluation.result {
                    return ("\(symbol)(\(operand))", operandEvaluation.remainingOps)
                }
            case .BinaryOperation(let symbol, _):
                let operationEvaluationFirst = description(remainingOps)
                if var operandFirst = operationEvaluationFirst.result {
                    print("this is what left over:")
                    print(remainingOps.count)
                    print(operationEvaluationFirst.remainingOps.count)
                    if remainingOps.count - operationEvaluationFirst.remainingOps.count > 2 {
                        print("haakjes")
                        operandFirst = "(\(operandFirst))"
                    }
                    let operationEvaluationSecond = description(operationEvaluationFirst.remainingOps)
                    if let operandSecond = operationEvaluationSecond.result {
                        
                        return ("\(operandSecond) \(symbol) \(operandFirst)", operationEvaluationSecond.remainingOps)
                    }
                }
            case .CustomVariable(let symbol):
                return (symbol, remainingOps)
                
            case .PiVariable(let symbol, _):
                return (symbol, remainingOps)
            }
        }
        return ("?", ops)
    }
    private func evaluate(ops: [Op])->(result: Double?, remainingOps: [Op]){
        if  !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand) :
                return(operand,remainingOps)
            case .UnaryOperation(let symbol, let operation) :
                let operationEvaluation = evaluate(remainingOps)
                if let operand = operationEvaluation.result {
                    
                    evaluationResult = operation(operand)
                    print(self)
                    evaluationResult = nil
                    return (operation(operand), operationEvaluation.remainingOps)
                }
            case .BinaryOperation(let symbol, let operation):
                let operationEvaluationFirst = evaluate(remainingOps)
                    if let operandFirst = operationEvaluationFirst.result{
                        let operationEvaluationSecond = evaluate(operationEvaluationFirst.remainingOps)
                        if let operandSecond = operationEvaluationSecond.result{
                            evaluationResult = operation(operandFirst,operandSecond)
                            print(self)
                            evaluationResult = nil
                            return (operation(operandFirst,operandSecond),operationEvaluationSecond.remainingOps)
                        }
                    }
            case .CustomVariable(let symbol):
                return (variableValues[symbol],remainingOps)
            case .PiVariable(_, let value):
                return (value, remainingOps)
            }
        }
        return (nil, ops)
    }
    func evaluate() ->Double?{
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over ")
        return result
    }
    func setVar(symbol: String, value: Double){
        variableValues[symbol] = value
        print(variableValues)
    }
    func handleHistory(historyOperation : String, result: String){
        historyStack.historyOperation = historyOperation
        historyStack.result = result
        historyStackReady = true
        historyStack.textWidth = (historyStack.historyOperation.characters.count + historyStack.result.characters.count)*10
    }
    func reset () {
        opStack.removeAll()
        variableValues.removeAll()
//        knownOps["Π"] = Op.CustomVariable("Π",  M_PI )
    }
}