//
//  GameTimePickers.swift
//  HockeyTimer
//
//  Created by Steven Adons on 08/12/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

import UIKit

class GameTimePickers: UIView {

    
    // MARK: - Properties
    
    private var periodsPicker: UIPickerView!
    private var minutesPicker: UIPickerView!
    private var decimalMinutesPicker: UIPickerView!
    private var xLabel: UILabel!
    private var decimalLabel: UILabel!
    
    private var periodsPickerDataSource: PickerDataSource!
    private var minutesPickerDataSource: PickerDataSource!
    private var decimalMinutesPickerDataSource: PickerDataSource!
    
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        xLabel = createLabel(text: "x")
        addSubview(xLabel)
        
        #warning("should localize")
        decimalLabel = createLabel(text: ",")
        addSubview(decimalLabel)
        
        periodsPicker = UIPickerView()
        periodsPicker.translatesAutoresizingMaskIntoConstraints = false
        periodsPicker.tag = 0
        let periodsData = [1, 2, 3, 4]
        periodsPickerDataSource = PickerDataSource(data: periodsData)
        periodsPicker.dataSource = periodsPickerDataSource
        periodsPicker.delegate = periodsPickerDataSource
        addSubview(periodsPicker)

        minutesPicker = UIPickerView()
        minutesPicker.translatesAutoresizingMaskIntoConstraints = false
        minutesPicker.tag = 1
        let minutesData = createMinutes()
        minutesPickerDataSource = PickerDataSource(data: minutesData)
        minutesPicker.dataSource = minutesPickerDataSource
        minutesPicker.delegate = minutesPickerDataSource
        addSubview(minutesPicker)
        
        decimalMinutesPicker = UIPickerView()
        decimalMinutesPicker.translatesAutoresizingMaskIntoConstraints = false
        decimalMinutesPicker.tag = 2
        let decimalMinutesData = [0, 5]
        decimalMinutesPickerDataSource = PickerDataSource(data: decimalMinutesData)
        decimalMinutesPicker.dataSource = decimalMinutesPickerDataSource
        decimalMinutesPicker.delegate = decimalMinutesPickerDataSource
        addSubview(decimalMinutesPicker)
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let vertRatio: CGFloat = 0.8
        let horInset: CGFloat = bounds.width * 0.05
        let xLabelWidth: CGFloat = 25
        let decimalLabelWidth: CGFloat = 10
        let smallPickerRatio: CGFloat = 0.5
        let veryBigPickerRatio: CGFloat = 1.5
        let pickerWidth: CGFloat = (bounds.width - horInset * 2 - xLabelWidth - decimalLabelWidth) / (1 + smallPickerRatio + veryBigPickerRatio)
        
        NSLayoutConstraint.activate([
        
            periodsPicker.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horInset),
            periodsPicker.widthAnchor.constraint(equalToConstant: pickerWidth),
            periodsPicker.centerYAnchor.constraint(equalTo: centerYAnchor),
            periodsPicker.heightAnchor.constraint(equalTo: heightAnchor, multiplier: vertRatio),
            
            xLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            xLabel.leadingAnchor.constraint(equalTo: periodsPicker.trailingAnchor),
            xLabel.widthAnchor.constraint(equalToConstant: xLabelWidth),

            minutesPicker.leadingAnchor.constraint(equalTo: xLabel.trailingAnchor),
            minutesPicker.widthAnchor.constraint(equalToConstant: pickerWidth * veryBigPickerRatio),
            minutesPicker.centerYAnchor.constraint(equalTo: centerYAnchor),
            minutesPicker.heightAnchor.constraint(equalTo: heightAnchor, multiplier: vertRatio),
            
            decimalLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            decimalLabel.leadingAnchor.constraint(equalTo: minutesPicker.trailingAnchor),
            decimalLabel.widthAnchor.constraint(equalToConstant: decimalLabelWidth),
            
            decimalMinutesPicker.leadingAnchor.constraint(equalTo: decimalLabel.trailingAnchor),
            decimalMinutesPicker.widthAnchor.constraint(equalToConstant: pickerWidth * smallPickerRatio),
            decimalMinutesPicker.centerYAnchor.constraint(equalTo: centerYAnchor),
            decimalMinutesPicker.heightAnchor.constraint(equalTo: heightAnchor, multiplier: vertRatio),
        ])
    }
    
    
    // MARK: - Public Methods
    
    func setPickersTo(_ first: Int, second: Int, third: Int, animated: Bool) {
        
        if let indexForFirst = periodsPickerDataSource.indexForNumber(first) {
            periodsPicker.selectRow(indexForFirst, inComponent: 0, animated: animated)
        }
        if let indexForSecond = minutesPickerDataSource.indexForNumber(second) {
            minutesPicker.selectRow(indexForSecond, inComponent: 0, animated: animated)
        }
        if let indexForThird = periodsPickerDataSource.indexForNumber(third) {
            decimalMinutesPicker.selectRow(indexForThird, inComponent: 0, animated: animated)
        }
    }

    
    
    // MARK: - Private Methods
    
    private func createLabel(text: String) -> UILabel {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont(name: FONTNAME.ThemeBold, size: 20)
        label.textAlignment = .center
        label.textColor = .label

        return label
    }
    
    private func createMinutes() -> [Int] {
        
        var result: [Int] = []
        for int in 0 ... 35 {
            result.append(int)
        }
        return result
    }
}
