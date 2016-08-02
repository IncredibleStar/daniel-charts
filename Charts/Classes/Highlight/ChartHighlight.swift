//
//  ChartHighlight.swift
//  Charts
//
//  Created by Daniel Cohen Gindi on 23/2/15.

//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation

public class ChartHighlight: NSObject
{
    /// the x-value of the highlighted value
    private var _x = Double.NaN
    
    /// the y-value of the highlighted value
    private var _y = Double.NaN
    
    /// the x-pixel of the highlight
    private var _xPx = CGFloat.NaN
    
    /// the y-pixel of the highlight
    private var _yPx = CGFloat.NaN
    
    /// the index of the data object - in case it refers to more than one
    public var dataIndex = Int(-1)
    
    /// the index of the dataset the highlighted value is in
    private var _dataSetIndex = Int(0)
    
    /// index which value of a stacked bar entry is highlighted
    /// 
    /// **default**: -1
    private var _stackIndex = Int(-1)
    
    /// the range of the bar that is selected (only for stacked-barchart)
    private var _range: ChartRange?
    
    /// the axis the highlighted value belongs to
    private var _axis: ChartYAxis.AxisDependency = ChartYAxis.AxisDependency.Left
    
    /// the x-position (pixels) on which this highlight object was last drawn
    public var drawX: CGFloat = 0.0
    
    /// the y-position (pixels) on which this highlight object was last drawn
    public var drawY: CGFloat = 0.0
    
    public override init()
    {
        super.init()
    }
    
    /// - parameter x: the x-value of the highlighted value
    /// - parameter y: the y-value of the highlighted value
    /// - parameter xPx: the x-pixel of the highlighted value
    /// - parameter yPx: the y-pixel of the highlighted value
    /// - parameter dataIndex: the index of the Data the highlighted value belongs to
    /// - parameter dataSetIndex: the index of the DataSet the highlighted value belongs to
    /// - parameter stackIndex: references which value of a stacked-bar entry has been selected
    /// - parameter range: the range the selected stack-value is in
    /// - parameter axis: the axis the highlighted value belongs to
    public init(
        x: Double, y: Double,
        xPx: CGFloat, yPx: CGFloat,
        dataIndex: Int,
        dataSetIndex: Int,
        stackIndex: Int,
        range: ChartRange?,
        axis: ChartYAxis.AxisDependency)
    {
        super.init()
        
        _x = x
        _y = y
        _xPx = xPx
        _yPx = yPx
        self.dataIndex = dataIndex
        _dataSetIndex = dataSetIndex
        _stackIndex = stackIndex
        _range = range
        _axis = axis
    }
    
    /// - parameter x: the x-value of the highlighted value
    /// - parameter y: the y-value of the highlighted value
    /// - parameter xPx: the x-pixel of the highlighted value
    /// - parameter yPx: the y-pixel of the highlighted value
    /// - parameter dataSetIndex: the index of the DataSet the highlighted value belongs to
    /// - parameter stackIndex: references which value of a stacked-bar entry has been selected
    /// - parameter range: the range the selected stack-value is in
    /// - parameter axis: the axis the highlighted value belongs to
    public convenience init(
        x: Double, y: Double,
        xPx: CGFloat, yPx: CGFloat,
        dataSetIndex: Int,
        stackIndex: Int, range: ChartRange?,
        axis: ChartYAxis.AxisDependency)
    {
        self.init(x: x, y: y, xPx: xPx, yPx: yPx,
                  dataIndex: 0,
                  dataSetIndex: dataSetIndex,
                  stackIndex: stackIndex,
                  range: range,
                  axis: axis)
    }
    
    /// - parameter x: the x-value of the highlighted value
    /// - parameter y: the y-value of the highlighted value
    /// - parameter xPx: the x-pixel of the highlighted value
    /// - parameter yPx: the y-pixel of the highlighted value
    /// - parameter dataIndex: the index of the Data the highlighted value belongs to
    /// - parameter dataSetIndex: the index of the DataSet the highlighted value belongs to
    /// - parameter stackIndex: references which value of a stacked-bar entry has been selected
    /// - parameter axis: the axis the highlighted value belongs to
    public init(
        x: Double, y: Double,
        xPx: CGFloat, yPx: CGFloat,
        dataSetIndex: Int,
        axis: ChartYAxis.AxisDependency)
    {
        super.init()
        
        _x = x
        _y = y
        _xPx = xPx
        _yPx = yPx
        _dataSetIndex = dataSetIndex
        _axis = axis
    }
    
    /// - parameter x: the x-value of the highlighted value
    /// - parameter dataSetIndex: the index of the DataSet the highlighted value belongs to
    public init(x: Double, dataSetIndex: Int)
    {
        _x = x
        _dataSetIndex = dataSetIndex
    }
    
    public var x: Double { return _x }
    public var y: Double { return _y }
    public var xPx: CGFloat { return _xPx }
    public var yPx: CGFloat { return _yPx }
    public var dataSetIndex: Int { return _dataSetIndex }
    public var stackIndex: Int { return _stackIndex }
    public var axis: ChartYAxis.AxisDependency { return _axis }
    
    public var isStacked: Bool { return _stackIndex >= 0 }
    
    /// - returns: the range of values the selected value of a stacked bar is in. (this is only relevant for stacked-barchart)
    public var range: ChartRange? { return _range }
    
    /// Sets the x- and y-position (pixels) where this highlight was last drawn.
    public func setDraw(x x: CGFloat, y: CGFloat)
    {
        self.drawX = x
        self.drawY = y
    }
    
    /// Sets the x- and y-position (pixels) where this highlight was last drawn.
    public func setDraw(pt pt: CGPoint)
    {
        self.drawX = pt.x
        self.drawY = pt.y
    }

    // MARK: NSObject
    
    public override var description: String
    {
        return "Highlight, x: \(_x), y: \(_y), dataIndex (combined charts): \(dataIndex), dataSetIndex: \(_dataSetIndex), stackIndex (only stacked barentry): \(_stackIndex)"
    }
    
    public override func isEqual(object: AnyObject?) -> Bool
    {
        if (object === nil)
        {
            return false
        }
        
        if (!object!.isKindOfClass(self.dynamicType))
        {
            return false
        }
        
        if (object!.x != _x)
        {
            return false
        }
        
        if (object!.y != _y)
        {
            return false
        }
        
        if (object!.dataIndex != dataIndex)
        {
            return false
        }
        
        if (object!.dataSetIndex != _dataSetIndex)
        {
            return false
        }
        
        if (object!.stackIndex != _stackIndex)
        {
            return false
        }
        
        return true
    }
}

func ==(lhs: ChartHighlight, rhs: ChartHighlight) -> Bool
{
    if (lhs === rhs)
    {
        return true
    }
    
    if (!lhs.isKindOfClass(rhs.dynamicType))
    {
        return false
    }
    
    if (lhs._x != rhs._x)
    {
        return false
    }
    
    if (lhs._y != rhs._y)
    {
        return false
    }
    
    if (lhs.dataIndex != rhs.dataIndex)
    {
        return false
    }
    
    if (lhs._dataSetIndex != rhs._dataSetIndex)
    {
        return false
    }
    
    if (lhs._stackIndex != rhs._stackIndex)
    {
        return false
    }
    
    return true
}