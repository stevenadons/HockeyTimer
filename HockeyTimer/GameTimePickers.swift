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
    
    private var periodsPicker: DecimalPickerView!
    private var minutesPicker: DecimalPickerView!
    private var xLabel: UILabel!
    private var decimalButton: UIButton!
    
    private var periodsPickerDataSource: PickerDataSource!
    private var minutesPickerDataSource: PickerDataSource!
    
    private (set) var inDecimalMode: Bool = false
    
    var selectedPeriods: Int?
    var selectedMinutes: Int?
    
    
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
        
        periodsPicker = DecimalPickerView(inDecimalMode: false)
        periodsPicker.translatesAutoresizingMaskIntoConstraints = false
        periodsPicker.tag = 0
        let periodsData = [1, 2, 3, 4]
        periodsPickerDataSource = PickerDataSource(data: periodsData)
        periodsPicker.dataSource = periodsPickerDataSource
        periodsPicker.delegate = periodsPickerDataSource
        addSubview(periodsPicker)

        minutesPicker = DecimalPickerView(inDecimalMode: false)
        minutesPicker.translatesAutoresizingMaskIntoConstraints = false
        minutesPicker.tag = 1
        let minutesData = createMinutes()
        minutesPickerDataSource = PickerDataSource(data: minutesData)
        minutesPicker.dataSource = minutesPickerDataSource
        minutesPicker.delegate = minutesPickerDataSource
        addSubview(minutesPicker)
        
        xLabel = createLabel(text: "x")
        addSubview(xLabel)
        
        decimalButton = UIButton()
        decimalButton.translatesAutoresizingMaskIntoConstraints = false
        decimalButton.titleLabel?.numberOfLines = 1
        decimalButton.titleLabel?.font = UIFont(name: FONTNAME.ThemeBold, size: 14)!
        decimalButton.setTitleColor(.secondaryLabel, for: .normal)
        decimalButton.addTarget(self, action: #selector(decimalButtonTapped), for: .touchUpInside)
        decimalButton.setTitle(LS_BUTTON_ADD_HALF_MINUTE, for: .normal)
        addSubview(decimalButton)
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let vertRatio: CGFloat = 0.7
        let xLabelWidth: CGFloat = 15
        let pickerWidth: CGFloat = 120
        
        NSLayoutConstraint.activate([
        
            periodsPicker.widthAnchor.constraint(equalToConstant: pickerWidth),
            periodsPicker.trailingAnchor.constraint(equalTo: xLabel.leadingAnchor),
            periodsPicker.centerYAnchor.constraint(equalTo: centerYAnchor),
            periodsPicker.heightAnchor.constraint(equalTo: heightAnchor, multiplier: vertRatio),
            
            xLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            xLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            xLabel.widthAnchor.constraint(equalToConstant: xLabelWidth),

            minutesPicker.leadingAnchor.constraint(equalTo: xLabel.trailingAnchor),
            minutesPicker.widthAnchor.constraint(equalToConstant: pickerWidth),
            minutesPicker.centerYAnchor.constraint(equalTo: centerYAnchor),
            minutesPicker.heightAnchor.constraint(equalTo: heightAnchor, multiplier: vertRatio),
            
            decimalButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            decimalButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -9),
            
        ])
    }
    
    
    // MARK: - Public Methods
    
    func setPickersTo(_ first: Int, second: Int, animated: Bool) {
        
        if let indexForFirst = periodsPickerDataSource.indexForNumber(first) {
            periodsPicker.selectRow(indexForFirst, inComponent: 0, animated: animated)
        }
        if let indexForSecond = minutesPickerDataSource.indexForNumber(second) {
            minutesPicker.selectRow(indexForSecond, inComponent: 0, animated: animated)
        }
    }
    
    // MARK: - Touch Methods
    
    @objc private func decimalButtonTapped() {
        
        let currentInDecimalMode = minutesPicker.inDecimalMode
        minutesPicker.inDecimalMode = !currentInDecimalMode
        let newTitle = minutesPicker.inDecimalMode ? LS_BUTTON_DELETE_HALF_MINUTE : LS_BUTTON_ADD_HALF_MINUTE
        decimalButton.setTitle(newTitle, for: .normal)
        
        // Set current content as selected to trigger sending out a selection occurred notification
        let currentRow = minutesPicker.selectedRow(inComponent: 0)
        minutesPicker.selectRow(currentRow, inComponent: 0, animated: true)
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
        for int in 0 ... 45 {
            result.append(int)
        }
        return result
    }
}
