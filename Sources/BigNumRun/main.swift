import BigNum
#if os(Linux)
import Glibc
#else
import Darwin
#endif

print(BigRat.atan(BigRat.PI()))

#if false
print(BigRat.tanh(BigRat(1.0/Double.greatestFiniteMagnitude)))
exit(0)
// print(BigRat.log2(BigRat.exp(1)))
//print(q, BigRat.log(10))
print(BigNum.constants)
print(BigRat.exp(1))
print(BigRat.exp(2))
print(BigRat.exp(-1))

let bi = BigInt(1) << 128 - 1
let bq = BigInt(1).over(bi)
print(bi)
print(bq)

let bqpi = BigRat(Double.pi)
var d = Double.pi
d.formRemainder(dividingBy: 0.125)
print(bqpi % BigRat(0.125))
print(BigRat(d))
import Foundation
let jd = try JSONEncoder().encode(bq)
let js = String(data:jd, encoding:.utf8)!
print(js)
print(BigRat(+1).toFloatingPointString())
print(BigRat(-1).toFloatingPointString())
print((+bqpi).toFloatingPointString())
print((-bqpi).toFloatingPointString())
print((+BigRat.log(2)))
print((+BigRat.log(2)).toFloatingPointString())
print((+BigRat.log(2)).toFloatingPointString())
print(1.over(Int.max).toFloatingPointString())
print(BigRat(1.0/Double(Int.max)).toFloatingPointString())
({
    var d = 0.5
    var x = 1.0
    for i in (0...53) {
        print( "\(i):", BigRat(x).toFloatingPointString(), Double(x))
        d *= 0.5; x -= d
    }
})()
print(Int.max.over(-1).toFloatingPointString())
#endif
