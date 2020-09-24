//
//  ViewController.swift
//  Algorithm
//
//  Created by oncezou on 2018/12/5.
//  Copyright © 2018年 oncezw. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let array = [2,55,23,76,11,21,6,34,99,35,73]
        
        let array_c = [6,19,27,39,42,43,53,88]
        let array_m = [2,4,7,9,12,33,55,108]
        
        print("quickSort == \(array.quickSort())")
        print("switchSort == \(array.switchSort())")
        print("bubbleSort == \(array.bubbleSort())")
        print("selectSort == \(array.selectSort())")
        print("insertionSort == \(array.insertionSort())")
        
        print("findSumEqualGivenNumber == \(findSumEqualGivenNumber(array, 45))")
        print("mergeOrderedArray1 == \(combineArraysToOrdered(array, array_m))")
        print("mergeOrderedArray2 == \(mergeOrderedArrays(array_c, array_m))")
        
        /*              10
         *      9               5
         *  7       3       12      1
         */
        let tree7 = TreeNode(7)
        let tree3 = TreeNode(3)
        let tree12 = TreeNode(12)
        let tree1 = TreeNode(1)
        
        let tree9 = TreeNode(9,tree7,tree3)
        let tree5 = TreeNode(5,tree12,tree1)
        
        let tree10 = TreeNode(10,tree9,tree5)
        
        print(tree10.search(5) ?? false)
        print("isValidBST == \(tree10.isValidBST())")
        print("maxDepth == \(TreeNode.maxDepth(tree10))")
        
        print("recursionPreorderTraversal")
        TreeNode.recursionPreorderTraversal(tree10)
        print("recursionMidorderTraversal")
        TreeNode.recursionMidorderTraversal(tree10)
        print("recursionPostorderTraversal")
        TreeNode.recursionPostorderTraversal(tree10)
        
        print("preorderTraversal == \(TreeNode.preorderTraversal(root: tree10))")
        print("midorderTraversal == \(TreeNode.midorderTraversal(root: tree10))")
        
        print("levelOrder == \(TreeNode.levelOrder(root: tree10))")
        let inverseTreeNode = TreeNode.inverse(tree10)
        print("inverse == \(String(describing: inverseTreeNode?.left?.right?.val))")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

