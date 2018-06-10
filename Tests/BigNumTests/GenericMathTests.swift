import XCTest
@testable import BigNum

import Foundation

final class GenericMathTests: XCTestCase {
    private typealias D = Double
    func runUnary<R:BigFloatingPoint>(forType T:R.Type) {
        var count = 0
        func ok(_ d:D, _ rd:D, _ rq:R, _ name:String="", check:()->Bool = { false })->Bool {
            count += 1
            print("BigRat.\(name)(\(d.debugDescription))", terminator: " ")
            if rd.isNaN     { print("is NaN");      return rq.isNaN  }
            let qrd = T.init(rd)
            let dname = "Double.\(name)()"
            if qrd == rq    { print("== \(dname)"); return true }
            if check()      { print("== inv()");    return true }
            let delta  = Swift.abs(qrd - rq);
            let err    = delta / rq
            let errhex = String(format:"%a", err.asDouble)
            if err <= T.init(D.ulpOfOne) {
                print("=~ \(dname) // err=\(errhex)"); return true
            } else {
                print("!~ \(name)() // err=\(errhex); FAILED!!"); return false
            }
        }
        let lgfm = D.log(D.greatestFiniteMagnitude) // log of the greatest finite double == 709.78271289338397
        var doubles = [1.0] + [D.ulpOfOne, D.greatestFiniteMagnitude]
        doubles += (1...52).map{ 1 + 1/D(1<<$0)}
        doubles += (1...10).map{ D(1 << $0) }
        doubles += doubles.map { 1.0 / $0 }
        doubles += doubles.map{ -$0 }
        doubles =  doubles.sorted().reduce([]){ $0.contains($1) ? $0 : $0 + [$1] }
        doubles =  [D.nan, -0.0, +0.0, -D.infinity, +D.infinity] + doubles
        // print(doubles)
        // doubles = []
        for d in doubles {
            let q = T.init(d); var (rd, rq):(D, R)
            _ = d.isNaN ? XCTAssertEqual(d.isNaN, q.isNaN) : XCTAssertEqual(d, q.asDouble) // very basic test
            (rd,rq)=(D.sqrt(d), T.sqrt(q,precision:64) ); XCTAssert(ok(d,rd,rq, "sqrt" ){d==D(rq)*D(rq)      }, "\(d)")
            (rd,rq)=(D.cbrt(d), T.cbrt(q,precision:64) ); XCTAssert(ok(d,rd,rq, "cbrt" ){d==D(rq)*D(rq)*D(rq)}, "\(d)")
            (rd,rq)=(D.exp(d),  T.exp(q,precision:64)  ); XCTAssert(ok(d,rd,rq, "exp"  ){
                lgfm < d.magnitude || d==D.log  (D(rq)) }, "\(d)")
            (rd,rq)=(D.expm1(d),T.expm1(q)); XCTAssert(ok(d,rd,rq, "exp1m"){
                lgfm < d.magnitude || d==D.log1p(D(rq)) }, "\(d)")
            (rd,rq)=(D.log(d),  T.log(q,precision:64)  ); XCTAssert(ok(d,rd,rq, "log"  ){d==D.exp  (D(rq))}, "\(d)")
            (rd,rq)=(D.log2(d), T.log2(q,precision:64) ); XCTAssert(ok(d,rd,rq, "log2" ){d==D.pow( 2,D(rq))}, "\(d)")
            (rd,rq)=(D.log10(d),T.log10(q,precision:64)); XCTAssert(ok(d,rd,rq, "log10"){d==D.pow(10,D(rq))}, "\(d)")
            (rd,rq)=(D.log1p(d),T.log1p(q,precision:64)); XCTAssert(ok(d,rd,rq, "log1p"){d==D.expm1(D(rq))}, "\(d)")
            (rd,rq)=(D.sin(d),  T.sin(q,precision:64)  ); XCTAssert(ok(d,rd,rq, "sin"  ){d==D.asin (D(rq))}, "\(d)")
            (rd,rq)=(D.cos(d),  T.cos(q,precision:64)  ); XCTAssert(ok(d,rd,rq, "cos"  ){d==D.acos (D(rq))}, "\(d)")
            (rd,rq)=(D.tan(d),  T.tan(q,precision:64)  ); XCTAssert(ok(d,rd,rq, "tan"  ){d==D.atan (D(rq))}, "\(d)")
            (rd,rq)=(D.asin(d), T.asin(q,precision:64) ); XCTAssert(ok(d,rd,rq, "asin" ){d==D.tan  (D(rq))}, "\(d)")
            (rd,rq)=(D.acos(d), T.acos(q,precision:64) ); XCTAssert(ok(d,rd,rq, "acos" ){d==D.cos  (D(rq))}, "\(d)")
            (rd,rq)=(D.atan(d), T.atan(q,precision:64) ); XCTAssert(ok(d,rd,rq, "atan" ){d==D.tan  (D(rq))}, "\(d)")
            (rd,rq)=(D.sinh(d), T.sinh(q,precision:64) ); XCTAssert(ok(d,rd,rq, "sinh" ){
                lgfm < d.magnitude || d==D.asinh(D(rq)) }, "\(d)")
            (rd,rq)=(D.cosh(d), T.cosh(q) ); XCTAssert(ok(d,rd,rq, "cosh" ){
                lgfm < d.magnitude || d==D.acosh(D(rq)) }, "\(d)")
            (rd,rq)=(D.tanh(d), T.tanh(q,precision:64) ); XCTAssert(ok(d,rd,rq, "tanh" ){d==D.atanh(D(rq))}, "\(d)")
            (rd,rq)=(D.asinh(d),T.asinh(q,precision:64)); XCTAssert(ok(d,rd,rq, "asinh"){d==D.sinh (D(rq))}, "\(d)")
            (rd,rq)=(D.acosh(d),T.acosh(q,precision:64)); XCTAssert(ok(d,rd,rq, "acosh"){d==D.cosh (D(rq))}, "\(d)")
            (rd,rq)=(D.atanh(d),T.atanh(q,precision:64)); XCTAssert(ok(d,rd,rq, "atanh"){d==D.tanh (D(rq))}, "\(d)")
        }
        print("testUnary:checked \(count) cases")
    }
    
    func testUnaryBigRat() { runUnary(forType: BigRat.self) }

    func runAtan2<R:BigFloatingPoint>(forType T:R.Type) {
        let doubles = [-1/0.0, -1.0, -0.0, +0.0, +1.0, +1/0.0]
        debugPrint(doubles)
        for y in doubles {
            for x in doubles {
                XCTAssertEqual(D(T.atan2(T.init(y), T.init(x), precision:64)), D.atan2(y, x),
                               "\(x, y, T.atan2(T.init(y), T.init(x)))")
            }
        }
    }
    
    func testAtan2BigRat() { runUnary(forType: BigRat.self) }

    static var allTests = [
        ("testUnaryBigRat", testUnaryBigRat),
        ("testAtan2BigRat", testAtan2BigRat),
    ]
}
