import UIKit
var ns: NSString = "whatever"
var cs: CString? = ns.UTF8String
println(cs)
var cs1: CString = cs!
