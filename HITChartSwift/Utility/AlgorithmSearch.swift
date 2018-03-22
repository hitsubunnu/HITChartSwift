//
//  AlgorithmSearch.swift
//  HITChartSwift
//
//  Created by hitsubunnu on 2018/03/22.
//  Copyright © 2018年 hitsubunnu. All rights reserved.
//

import Foundation

class AlgorithmSearch {
    
    /** @fn nearestNeighbor:array:searchItem:
     @brief base on binary search algorithm, search nearest neighbor index in array
     
     @param T: use protocol BinaryFloatingPoint
     @param array: input array
     @param searchItem: serach item
     
     @remarks See @c https://en.wikipedia.org/wiki/Binary_search_algorithm
     @remarks See @c http://rshankar.com/binary-search-in-swift/
     @remarks See @c https://stackoverflow.com/questions/31904396/swift-binary-search-for-standard-array
     
     @remarks example:
     ```
     let array = [1.0, 2, 3, 4.0, 5.1, 6, 7, 9, 10];
     let index = nearestNeighbor(array,searchItem: 4.5)
     
     debugPrint("Element found on index: \( index )")
     ```
     */
    class func nearestNeighbor<T: BinaryFloatingPoint>(_ array: Array<T>, searchItem: T) -> Int {
        var lowerIndex = 0;
        var upperIndex = array.count - 1
        
        if searchItem <= array[0] {
            return lowerIndex
        } else if searchItem >= array[array.count - 1] {
            return upperIndex
        }
        
        if array.count == 2 {
            return searchItem < (array[0] + array[array.count - 1] )/2 ? 0 : 1
        }
        
        while (true) {
            let currentIndex = (lowerIndex + upperIndex)/2
            if array[currentIndex] == searchItem {
                return currentIndex
            } else if currentIndex > 0, currentIndex < array.count - 1, array[currentIndex - 1] < searchItem, searchItem < array[currentIndex + 1] {
                if searchItem < (array[currentIndex] + array[currentIndex - 1] )/2 {
                    return currentIndex - 1
                } else if searchItem > (array[currentIndex] + array[currentIndex + 1] )/2 {
                    return currentIndex + 1
                } else {
                    return currentIndex
                }
            } else {
                if array[currentIndex] > searchItem {
                    upperIndex = currentIndex - 1
                } else {
                    lowerIndex = currentIndex + 1
                }
            }
        }
    }
}
