//
//  CurrencyChart.swift
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 3/28/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

@objc class CurrencyChart: UIViewController{

    @IBOutlet var spinner: UIActivityIndicatorView!
    
    @objc var currency: String!
    
    override func viewDidLoad() {
        loadData()
//        createChart2(superview: self.view)
    }
    
    func chartFrameTest(_ containerBounds: CGRect) -> CGRect {
        return CGRect(x: 0, y: 70, width: containerBounds.size.width, height: containerBounds.size.height - 70)
    }
    
    func loadData(){
        //napravi url da bude od this.currency
//        let url = URL(string: "http://192.168.0.14:8080/crypto_war_exploded/currency/BTC/history?tocurrencyid=USD")
//        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
//            do{
//                let json = try JSON(data: data!)
//                print(json[0]["type"])
//                DispatchQueue.main.async {
//                    self.spinner.stopAnimating()
//                    self.createChart2(json: json)
//                }
//
//
//            }catch let error as NSError {
//                print(error.localizedDescription)
//                print(data!)
//            }
//        }
//        task.resume()
        
        if let path = Bundle.main.path(forResource: "CurrencyHistagram", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let json = try JSON(data: data)
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    self.createChart2(json: json)
                }
            } catch {
                // handle error
            }
        }
        
    }
    
    fileprivate var iPhoneChartSettings: ChartSettings {
        var chartSettings = ChartSettings()
        chartSettings.leading = 10
        chartSettings.top = 10
        chartSettings.trailing = 10
        chartSettings.bottom = 10
        chartSettings.labelsToAxisSpacingX = 5
        chartSettings.labelsToAxisSpacingY = 5
        chartSettings.axisTitleLabelsToLabelsSpacing = 4
        chartSettings.axisStrokeWidth = 0.2
        chartSettings.spacingBetweenAxesX = 8
        chartSettings.spacingBetweenAxesY = 8
        chartSettings.labelsSpacing = 0
        return chartSettings
    }
    
    fileprivate var chart: Chart? // arc
    
    func createChart2(json: JSON) {
        var labelSettings = ChartLabelSettings()

        var readFormatter = DateFormatter()
        readFormatter.dateFormat = "dd.MM.yyyy"
        
        var displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MMM dd"
        
        let date = {(str: String) -> Date in
            return readFormatter.date(from: str)!
        }
        
        let calendar = Calendar.current
        
        let dateWithComponents = {(day: Int, month: Int, year: Int) -> Date in
            var components = DateComponents()
            components.day = day
            components.month = month
            components.year = year
            return calendar.date(from: components)!
        }
        
        func filler(_ date: Date) -> ChartAxisValueDate {
            let filler = ChartAxisValueDate(date: date, formatter: displayFormatter)
            filler.hidden = true
            return filler
        }
        
        var chartPoints = Array<ChartPointCandleStick>()
        for i in 0...json.count {
            chartPoints.append(ChartPointCandleStick(date: Date(timeIntervalSince1970: json[i]["timestamp"].doubleValue), formatter: displayFormatter, high: json[i]["high"].doubleValue, low: json[i]["low"].doubleValue, open: json[i]["open"].doubleValue, close: json[i]["close"].doubleValue))
        }
        
//        for i in 0...10 {
//            chartPoints.append(ChartPointCandleStick(date: Date(timeIntervalSince1970: json[i]["timestamp"].doubleValue), formatter: displayFormatter, high: json[i]["high"].doubleValue, low: json[i]["low"].doubleValue, open: json[i]["open"].doubleValue, close: json[i]["close"].doubleValue))
//        }
        
//        chartPoints = [
//            ChartPointCandleStick(date: date("01.10.2015"), formatter: displayFormatter, high: 40, low: 37, open: 39.5, close: 39),
//            ChartPointCandleStick(date: date("02.10.2015"), formatter: displayFormatter, high: 39.8, low: 38, open: 39.5, close: 38.4),
//            ChartPointCandleStick(date: date("03.10.2015"), formatter: displayFormatter, high: 43, low: 39, open: 41.5, close: 42.5),
//            ChartPointCandleStick(date: date("04.10.2015"), formatter: displayFormatter, high: 48, low: 42, open: 44.6, close: 44.5),
//            ChartPointCandleStick(date: date("05.10.2015"), formatter: displayFormatter, high: 45, low: 41.6, open: 43, close: 44),
//            ChartPointCandleStick(date: date("06.10.2015"), formatter: displayFormatter, high: 46, low: 42.6, open: 44, close: 46),
//            ChartPointCandleStick(date: date("07.10.2015"), formatter: displayFormatter, high: 47.5, low: 41, open: 42, close: 45.5),
//            ChartPointCandleStick(date: date("08.10.2015"), formatter: displayFormatter, high: 50, low: 46, open: 46, close: 49),
//            ChartPointCandleStick(date: date("09.10.2015"), formatter: displayFormatter, high: 45, low: 41, open: 44, close: 43.5),
//            ChartPointCandleStick(date: date("11.10.2015"), formatter: displayFormatter, high: 47, low: 35, open: 45, close: 39),
//            ChartPointCandleStick(date: date("12.10.2015"), formatter: displayFormatter, high: 160, low: 20, open: 44, close: 40),
//            ChartPointCandleStick(date: date("13.10.2015"), formatter: displayFormatter, high: 43, low: 36, open: 41, close: 38),
//            ChartPointCandleStick(date: date("14.10.2015"), formatter: displayFormatter, high: 42, low: 31, open: 38, close: 39),
//            ChartPointCandleStick(date: date("15.10.2015"), formatter: displayFormatter, high: 39, low: 34, open: 37, close: 36),
//            ChartPointCandleStick(date: date("16.10.2015"), formatter: displayFormatter, high: 35, low: 32, open: 34, close: 33.5),
//            ChartPointCandleStick(date: date("17.10.2015"), formatter: displayFormatter, high: 32, low: 29, open: 31.5, close: 31),
//            ChartPointCandleStick(date: date("18.10.2015"), formatter: displayFormatter, high: 31, low: 29.5, open: 29.5, close: 30),
//            ChartPointCandleStick(date: date("19.10.2015"), formatter: displayFormatter, high: 29, low: 25, open: 25.5, close: 25),
//            ChartPointCandleStick(date: date("20.10.2015"), formatter: displayFormatter, high: 28, low: 24, open: 26.7, close: 27.5),
//            ChartPointCandleStick(date: date("21.10.2015"), formatter: displayFormatter, high: 28.5, low: 25.3, open: 26, close: 27),
//            ChartPointCandleStick(date: date("22.10.2015"), formatter: displayFormatter, high: 30, low: 28, open: 28, close: 30),
//            ChartPointCandleStick(date: date("25.10.2015"), formatter: displayFormatter, high: 31, low: 29, open: 31, close: 31),
//            ChartPointCandleStick(date: date("26.10.2015"), formatter: displayFormatter, high: 31.5, low: 29.2, open: 29.6, close: 29.6),
//            ChartPointCandleStick(date: date("27.10.2015"), formatter: displayFormatter, high: 30, low: 27, open: 29, close: 28.5),
//            ChartPointCandleStick(date: date("28.10.2015"), formatter: displayFormatter, high: 32, low: 30, open: 31, close: 30.6),
//            ChartPointCandleStick(date: date("29.10.2015"), formatter: displayFormatter, high: 35, low: 31, open: 31, close: 33)
//        ]
        
        func generateDateAxisValues(_ month: Int, year: Int) -> [ChartAxisValueDate] {
            let date = dateWithComponents(1, month, year)
            let calendar = Calendar.current
            let monthDays = calendar.range(of: .day, in: .month, for: date)!
            
            let arr = CountableRange<Int>(monthDays)
            
            return arr.map {day in
                let date = dateWithComponents(day, month, year)
                let axisValue = ChartAxisValueDate(date: date, formatter: displayFormatter, labelSettings: labelSettings)
                axisValue.hidden = !(day % 20 == 0)
                return axisValue
            }
        }
        
//        var xValues = generateDateAxisValues(10, year: 2015)

        var xValues = Array<ChartAxisValueDate>()
        for i in 2018...2018 {
            for j in 1...1 {
                xValues.append(contentsOf: generateDateAxisValues(j, year: i))
            }
        }
//        xValues.append(contentsOf: (generateDateAxisValues(10, year: 2015)))
//        xValues.append(contentsOf: (generateDateAxisValues(11, year: 2015)))
//        xValues.append(contentsOf: (generateDateAxisValues(12, year: 2015)))

//        let min = 20
//        let max = 500
//        let height = UIScreen.main.bounds.height
        
        
        let yValues = stride(from: 0, through: 20000, by: 5000).map {ChartAxisValueDouble(Double($0), labelSettings: labelSettings)}
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings.defaultVertical()))
        
        let defaultChartFrame = chartFrameTest(view.bounds)
        let infoViewHeight: CGFloat = 50
        let chartFrame = CGRect(x: defaultChartFrame.origin.x, y: defaultChartFrame.origin.y + infoViewHeight, width: defaultChartFrame.width, height: defaultChartFrame.height - infoViewHeight)
        
        let coordsSpace = ChartCoordsSpaceRightBottomSingleAxis(chartSettings: iPhoneChartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        
        let viewGenerator : (ChartPointLayerModel<ChartPointCandleStick>, ChartPointsViewsLayer<ChartPointCandleStick, ChartCandleStickView>, Chart) -> ChartCandleStickView? = {(chartPointModel: ChartPointLayerModel<ChartPointCandleStick>, layer: ChartPointsViewsLayer<ChartPointCandleStick, ChartCandleStickView>, chart: Chart) -> ChartCandleStickView? in
            let (chartPoint, screenLoc) = (chartPointModel.chartPoint, chartPointModel.screenLoc)

            let x = screenLoc.x

            let highScreenY = screenLoc.y
            let lowScreenY = layer.modelLocToScreenLoc(x: Double(x), y: Double(chartPoint.low)).y
            let openScreenY = layer.modelLocToScreenLoc(x: Double(x), y: Double(chartPoint.open)).y
            let closeScreenY = layer.modelLocToScreenLoc(x: Double(x), y: Double(chartPoint.close)).y

            let (rectTop, rectBottom, fillColor) = closeScreenY < openScreenY ? (closeScreenY, openScreenY, UIColor.white) : (openScreenY, closeScreenY, UIColor.black)
            let v = ChartCandleStickView(lineX: screenLoc.x, width: 5, top: highScreenY, bottom: lowScreenY, innerRectTop: rectTop, innerRectBottom: rectBottom, fillColor: fillColor, strokeWidth: 0.5)
            v.isUserInteractionEnabled = false
            return v
        }
        
        let candleStickLayer = ChartPointsCandleStickViewsLayer<ChartPointCandleStick, ChartCandleStickView>(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, innerFrame: innerFrame, chartPoints: chartPoints, viewGenerator: viewGenerator)
        
        
        let infoView = InfoWithIntroView(frame: CGRect(x: 10, y: 70, width: view.frame.size.width, height: infoViewHeight))
        view.addSubview(infoView)
        
        let trackerLayer = ChartPointsTrackerLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, chartPoints: chartPoints, locChangedFunc: {[candleStickLayer, weak infoView] screenLoc in
            candleStickLayer.highlightChartpointView(screenLoc: screenLoc)
            if let chartPoint = candleStickLayer.chartPointsForScreenLocX(screenLoc.x).first {
                infoView?.showChartPoint(chartPoint)
            } else {
                infoView?.clear()
            }
            }, lineColor: UIColor.red, lineWidth: 0.6)
        
        
        let settings = ChartGuideLinesLayerSettings(linesColor: UIColor.black, linesWidth: 0.1)
        let guidelinesLayer = ChartGuideLinesLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: settings)
        
        let dividersSettings =  ChartDividersLayerSettings(linesColor: UIColor.black, linesWidth: 0.1, start: 3, end: 0)
        let dividersLayer = ChartDividersLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: dividersSettings)
        
        let chart = Chart(
            frame: chartFrame,
            innerFrame: innerFrame,
            settings: iPhoneChartSettings,
            layers: [
                xAxisLayer,
                yAxisLayer,
                guidelinesLayer,
                dividersLayer,
                candleStickLayer,
                trackerLayer
            ]
        )
        
        view.addSubview(chart.view)
        self.chart = chart
    }
}

private class InfoView: UIView {
    
    let statusView: UIView
    
    let dateLabel: UILabel
    let lowTextLabel: UILabel
    let highTextLabel: UILabel
    let openTextLabel: UILabel
    let closeTextLabel: UILabel
    
    let lowLabel: UILabel
    let highLabel: UILabel
    let openLabel: UILabel
    let closeLabel: UILabel
    
    override init(frame: CGRect) {
        
        let itemHeight: CGFloat = 40
        let y = (frame.height - itemHeight) / CGFloat(2)
        
        statusView = UIView(frame: CGRect(x: 0, y: y, width: itemHeight, height: itemHeight))
        statusView.layer.borderColor = UIColor.black.cgColor
        statusView.layer.borderWidth = 1
        statusView.layer.cornerRadius = 8
        
        let font = UIFont.systemFont(ofSize: 13);
        
        dateLabel = UILabel()
        dateLabel.font = font
        
        lowTextLabel = UILabel()
        lowTextLabel.text = "Low:"
        lowTextLabel.font = font
        lowLabel = UILabel()
        lowLabel.font = font
        
        highTextLabel = UILabel()
        highTextLabel.text = "High:"
        highTextLabel.font = font
        highLabel = UILabel()
        highLabel.font = font
        
        openTextLabel = UILabel()
        openTextLabel.text = "Open:"
        openTextLabel.font = font
        openLabel = UILabel()
        openLabel.font = font
        
        closeTextLabel = UILabel()
        closeTextLabel.text = "Close:"
        closeTextLabel.font = font
        closeLabel = UILabel()
        closeLabel.font = font
        
        super.init(frame: frame)
        
        addSubview(statusView)
        addSubview(dateLabel)
        addSubview(lowTextLabel)
        addSubview(lowLabel)
        addSubview(highTextLabel)
        addSubview(highLabel)
        addSubview(openTextLabel)
        addSubview(openLabel)
        addSubview(closeTextLabel)
        addSubview(closeLabel)
    }
    
    fileprivate override func didMoveToSuperview() {
        
        let views = [statusView, dateLabel, highTextLabel, highLabel, lowTextLabel, lowLabel, openTextLabel, openLabel, closeTextLabel, closeLabel]
        for v in views {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let namedViews = views.enumerated().map{index, view in
            ("v\(index)", view)
        }
        
        var viewsDict = Dictionary<String, UIView>()
        for namedView in namedViews {
            viewsDict[namedView.0] = namedView.1
        }
        
        let circleDiameter: CGFloat = 15
        let labelsSpace: CGFloat = 5
        
        let hConstraintStr = namedViews[1..<namedViews.count].reduce("H:|[v0(\(circleDiameter))]") {str, tuple in
            "\(str)-(\(labelsSpace))-[\(tuple.0)]"
        }
        
        let vConstraits = namedViews.flatMap {NSLayoutConstraint.constraints(withVisualFormat: "V:|-(18)-[\($0.0)(\(circleDiameter))]", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDict)}
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: hConstraintStr, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDict)
            + vConstraits)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showChartPoint(_ chartPoint: ChartPointCandleStick) {
        let color = chartPoint.open > chartPoint.close ? UIColor.black : UIColor.white
        statusView.backgroundColor = color
        dateLabel.text = chartPoint.x.labels.first?.text ?? ""
        lowLabel.text = "\(chartPoint.low)"
        highLabel.text = "\(chartPoint.high)"
        openLabel.text = "\(chartPoint.open)"
        closeLabel.text = "\(chartPoint.close)"
    }
    
    func clear() {
        statusView.backgroundColor = UIColor.clear
    }
}

private class InfoWithIntroView: UIView {
    
    var introView: UIView!
    var infoView: InfoView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    fileprivate override func didMoveToSuperview() {
        let label = UILabel(frame: CGRect(x: 0, y: bounds.origin.y, width: bounds.width, height: bounds.height))
        label.text = "Drag the line to see chartpoint data"
        label.font = UIFont.systemFont(ofSize: 13);
        label.backgroundColor = UIColor.white
        introView = label
        
        infoView = InfoView(frame: bounds)
        
        addSubview(infoView)
        addSubview(introView)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func animateIntroAlpha(_ alpha: CGFloat) {
        UIView.animate(withDuration: 0.1, animations: {
            self.introView.alpha = alpha
        })
    }
    
    func showChartPoint(_ chartPoint: ChartPointCandleStick) {
        animateIntroAlpha(0)
        infoView.showChartPoint(chartPoint)
    }
    
    func clear() {
        animateIntroAlpha(1)
        infoView.clear()
    }
}
