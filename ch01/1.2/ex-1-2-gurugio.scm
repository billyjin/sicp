
;====== ex 1.9 ===============

;; If inc calls +, it will be recursive procedure of +,
;; and it will be infinite loop.
;; Thefore I make non-recursive version of inc.
(define (recur-inc x) (+ x 1))
(define (no-recur-inc x)
  (cond ((= x 0) 1)
        ((= x 1) 2)
        ((= x 2) 3)
        ((= x 3) 4)
        ((= x 4) 5)
        ((= x 5) 6)
        ((= x 6) 7)
        ((= x 7) 8)
        ((= x 8) 9)
        ((= x 9) 10)))
(define (dec x) (- x 1))

(define (+ a b)
  (if (= a 0)
      b
      (recur-inc (+ (dec a) b))))
;; (+ 4 5) ->
;; (inc (+ (dec 4) 5)) ->
;; (inc (+ 3 5)) ->
;; (inc (inc (+ 2 5))) ->
;; (inc (inc (inc (+ 1 5)))) ->
;; (inc (inc (inc (inc (+ 0 5))))) ->
;; (inc (inc (inc (inc 5)))) ->
;; (inc (inc (inc (+ 5 1)))) ->
;; (inc (inc (inc (inc (+ 4 1))))) ->
;; (...................(inc (+ 3 1))) ->
;; (........................(inc (+ 2 1))) ->
;; (........................(inc (inc (+ 1 1)))) ->
;; (..................................(inc (+ 0 1))) ->
;; (.......................................(... !!!!
;; (inc 1) ==> (+ 1 1) ==> (inc (+ 0 1)) ==> (inc 1) ==> infinite loop!!!

(define (+ a b)
  (if (= a 0)
      b
      (no-recur-inc (+ (dec a) b)))))

;; (+ 2 3)
;; (inc (+ 1 3))
;; (inc (inc (+ 0 3)))
;; (inc (inc 3))
;; (inc 4)
;; 5
;; Using no-recur-inc, it does not infinite loop!!

;; This is the deferered operation & linearly increasing operation.
;; This is linear recursive process!


(define (+ a b)
  (if (= a 0)
      b
      (+ (dec a) (inc b))))

;; using recur-inc
;; (+ 4 5) ->
;; (+ (dec 4) (inc 5)) ->
;; (+ (- 4 1) (+ 5 1)) ->
;; (+ 3 (+ 4 (inc 1))) ->
;; (+ 3 (+ 4 (+ 1 1))) ->
;; (+ 3 (+ 4 (+ 0 (inc 1)))) ->
;; (..............(+ 1 1)) ->
;; (..............(+ (inc 1))) -> !!!
;; (+ 1 1) -> (+ 0 (inc 1)) -> (+ 0 (+ 1 1)) -> infinitly increasing
;;
;; using no-recur-inc
;; (+ 4 3)
;; (+ 3 (inc 3))
;; (+ 3 4)
;; (+ 2 (inc 4))
;; (+ 1 (inc 5)
;; (+ 0 (inc 6))
;; 7
;; It calls inc procedure at 4 times.
;; The first argument is the state variable and
;; calling inc is at the number of the first argument.
;; This is linear iterative process.



;====== ex 1.10 ============
(define (A x y)
  (cond ((= y 0) 0)
        ((= x 0) (* 2 y))
        ((= y 1) 2)
        (else (A (- x 1) (A x (- y 1))))))

;; guile> 1024
;; guile> 65536
;; guile> 65536
(A 1 10)
(A 2 4)
(A 3 3)



;; (A 1 10) = (A 0 (A 1 9)) = (A 0 (A 0 (A 1 8)))=(A 0 (A 0 (A...(A 1 1))))
;; = (A 0 (...(A 0 2)))
;; = (A 0 (...4))
;; = (A 0 (A 0 (A ... (A 0 2)))) ; 2 * 2^9 = 2^10
;; therefore, (A 1 n) is 2^n

;; (A 2 4) = (A 1 (A 2 3)) = (A 1 (A 1 (A 2 2))) = (A 1 (A 1 (A 1 (A 2 1)))) = (A 1 (A 1 (A 1 2)))
;; ==> (A 1 2) = 2^2
;; ==> (A 1 (A 1 2)) = 2 ^ (2^2)
;; ==> (A 1 (A 1 (A 1 2))) = 2 ^ (2 ^ (2^2)) = 2^16 = 65536 => 2^2^2^2
;; therefore, (A 2 n) is 2^2^...^2 (n-times)
;; (A 2 3) -> 2^2^2=2^4=16

(define (f n) (A 0 n)) ;; 2n            
(define (g n) (A 1 n)) ;; 2^n
(define (h n) (A 2 n)) ;; a(n) = 2^a(n-1), (n=1, a(1)=2)
(define (k n) (* 5 n n)) ;; 5n^2



;=========== ex 1.11 ============

; recursive

(define (ex1_11_recur n)
  (if (< n 3) n
      (+ (ex1_11 (- n 1)) 
         (* 2 (ex1_11 (- n 2)))
         (* 3 (ex1_11 (- n 3))))))

(ex1_11_recur 1)
(ex1_11_recur 2)
(ex1_11_recur 3)
(ex1_11_recur 4)
(ex1_11_recur 5)
(ex1_11_recur 6)

; iterative

; count = 3
; n >= 3
; f1=2, f2=1, f3=0
; 
(define (ex1_11_iter n)
  (ex1_11_iter_body 3 n 2 1 0)) ;; initial value of count is 3

(define (ex1_11_iter_body count n f_n-1 f_n-2 f_n-3)
  (cond ((< n 3) n) ; n<3, result = n
        ((= count n) (+ f_n-1 (* 2 f_n-2) (* 3 f_n-3))) ; f(n) = f(n-1)+2*f(n-2)+3*f(n-3)
        (else (ex1_11_iter_body (+ count 1) ; increase count
                           n           ; n 
                           (+ f_n-1 (* 2 f_n-2) (* 3 f_n-3)) ; f(n) -> f(n-1)
                           f_n-1                       ; f(n-1) -> f(n-2)
                           f_n-2))))                   ; f(n-2) -> f(n-3)

(ex1_11_iter 1)
(ex1_11_iter 2)
(ex1_11_iter 3)
(ex1_11_iter 4)
(ex1_11_iter 5)
(ex1_11_iter 6)


;============= 1.12 ====================
;;     1         ; level 1
;;    1 1        ; level 2
;;   1 2 1       ; ...
;;  1 3 3 1
;; 1 4 6 4 1
;; ...
;; 1 2 3 4 5     ; order

;;RESULT: value of (level=l, order=o) = value of ((level=l-1, order=o-1) + (level=l-1, order=o))


(define (get-num level order)
  (cond ((< level order) -1)
        ((= order 1) 1)
        ((= order level) 1)
        (else (+ (get-num (- level 1) (- order 1))
                 (get-num (- level 1) order)))))

(get-num 1 1)
(get-num 2 1)
(get-num 2 2)
(get-num 3 1)
(get-num 3 2)
(get-num 3 3)
(get-num 4 1)
(get-num 4 2)
(get-num 4 3)
(get-num 4 4)
(get-num 4 5) ;; error!


(define (print-pascal-triangle-line level)
  (define (print-pascal-triangle-line-body order level)
    (if (<= order level) (begin (display (get-num level order))
                                (display " ")
                                (print-pascal-triangle-line-body (+ order 1) level))
        ))
  (print-pascal-triangle-line-body 1 level))

(define (print-pascal-triangle level)
  (if (> level 0) (print-pascal-triangle (- level 1))) ;; no else-statement
  ;; if level is 0, it starts to print lines from 0-level to specified level.
  (print-pascal-triangle-line level) 
  (newline))
      
(print-pascal-triangle 0)
(print-pascal-triangle 1)
(print-pascal-triangle 2)
(print-pascal-triangle 3)
(print-pascal-triangle 4)
(print-pascal-triangle 5)
(print-pascal-triangle 6)




;;================ ex1.13 =====================

(define (fib n)
  (fib-iter 1 0 n))

(define (fib-iter a b count)
  (if (= count 0) b
      (fib-iter (+ a b) a (- count 1))))

(define c1 (/ (+ 1 (sqrt 5)) 2))
(define c2 (/ (- 1 (sqrt 5)) 2)) 

;; fib(n) is round number of c1
(define (prove1 n)
  (= (fib n) (round (/ (expt c1 n) (sqrt 5)))))

(prove1 5)
(prove1 6)


;; If no round of value, it cannot check equality at prove2-procedure. WHY?
(define (fib-approx n)
  (round (/ (- (expt c1 n) (expt c2 n)) (sqrt 5))))

;; fib(n) = fib(n-1) + fib(n-2)
;; therefore, fib-approx(n) = fib-approx(n-1) + fib-approx(n-2)
(define (prove2 n)
  (display (fib-approx n)) (display "=?") (display (+ (fib-approx (- n 1)) (fib-approx (- n 2))))
  (if (zero? n) '#t
      (if (= (fib-approx n) (+ (fib-approx (- n 1)) (fib-approx (- n 2))))
          (begin (display "fib(") (display n) (display ") is proved") (newline)
                 (prove2 (- n 1)))
          '#f)))

(prove2 10)
(prove2 60)
(prove2 75)
(prove2 76) ;; -> return #f, WHY?


;;============== ex1.15 ==================

(define p-count 0)

(define (cube x) (* x x x))
(define (p x) (begin (set! p-count (+ p-count 1))
                     (- (* 3 x) (* 4 (cube x)))))

(define (sine angle)
  (if (not (> (abs angle) 0.1))
      angle
      (p (sine (/ angle 3.0)))))


(define (sine-wrapper angle)
  (set! p-count 0)
  (sine angle)
  (display "p is called ")
  (display p-count)
  (display "-times")
  (newline))


;; (sine 12.15)
;; -> (p (sine 4.05))
;; -> (p (p (sine 1.35)))
;; -> (p (p (p (sine 0.45))))
;; -> (p (p (p (p (sine 0.15)))))
;; -> (p (p (p (p (p (sine 0.05))))))
;; -> (p (p (p (p (p 0.05)))))
;; p is called at 5-times

;; (sine-wrapper 12.15)
;; (sine-wrapper (* 12.15 10))
;; (sine-wrapper (* 12.15 30))
;; (sine-wrapper (* 12.15 60))
;; (sine-wrapper (* 12.15 90))
;; (sine-wrapper (* 12.15 120))
;; (sine-wrapper (* 12.15 150))
;; (sine-wrapper (* 12.15 180))
;; (sine-wrapper (* 12.15 210))
;; guile> p is called 5-times
;; guile> p is called 7-times
;; guile> p is called 8-times
;; guile> p is called 9-times
;; guile> p is called 9-times
;; guile> p is called 9-times
;; guile> p is called 9-times
;; guile> p is called 10-times
;; guile> p is called 10-times
;; growth in space and number of steps : O(log3 of a)????



;; ================= ex 1.16 =====================

(define (square a) (* a a))

(define (fast-expt-recur b n)
  (cond ((= n 0) 1)
        ((even? n) (square (fast-expt-recur b (/ n 2))))
        (else (* b (fast-expt-recur b (- n 1))))))

(define (fast-expt-iter b n)
  (fast-expt-iter-body b n 1))


;; 2^11 = 2*2^10  -> b=2, count=10, product=2
;; 2^10 = 2^2^5   -> b=2^2, count=5, product=2
;; When even, change b. When odd, change product
;; When count=1, final b and final product are multiplied.
(define (fast-expt-iter-body b count product)
  (cond ((= count 0) product)
        ((even? count) (fast-expt-iter-body (square b) (/ count 2) product))
        (else (fast-expt-iter-body b (- count 1) (* product b)))))

(define (test n)
  (if (= n 1) (display "end")
      (begin (display n)
             (display "->")
             (display (fast-expt-iter 2 n))
             (newline)
             (test (- n 1)))))
(test 11)

(fast-expt-iter 2 7)



;; ============== ex 1.17 ===================

(define (mul a b)
  (if (= b 1)
      a
      (+ a (mul a (- b 1)))))

(mul 3 4)
(mul 4 4)

(define (double x) (* x 2))
(define (halve x) (/ x 2))

(define (fast-mul a b)
  (cond ((= b 1) a)
        ((even? b) (double (fast-mul a (halve b))))
        (else (+ a (fast-mul a (- b 1))))))

(fast-mul 3 4)
(fast-mul 4 8)
(fast-mul 5 16)

(fast-mul 3 5)
(fast-mul 4 6)
(fast-mul 3 7)
(fast-mul 3 8)
(fast-mul 3 9)
(fast-mul 3 10)
(fast-mul 3 11)
(fast-mul 3 12)


;;================== ex 1.18 ====================


(define (double x) (* x 2))
(define (halve x) (/ x 2))

(define (fast-mul-recur a b)
  (cond ((= b 1) a)
        ((even? b) (double (fast-mul-recur a (halve b))))
        (else (+ a (fast-mul-recur a (- b 1))))))

(define (fast-mul-iter a b)
  (fast-mul-iter-body a b 0))

(define (fast-mul-iter-body a b product)
  (cond ((= b 1) (+ a product))
        ((even? b) (fast-mul-iter-body (double a) (halve b) product))
        (else (fast-mul-iter-body a (- b 1) (+ product a)))))

(define fast-mul fast-mul-iter)

(fast-mul 3 4)
(fast-mul 4 8)
(fast-mul 5 16)

(fast-mul 3 5)
(fast-mul 4 6)
(fast-mul 3 7)
(fast-mul 3 8)
(fast-mul 3 9)
(fast-mul 3 10)
(fast-mul 3 11)
(fast-mul 3 12)

;; ================= ex 1.19 =================



;; a1 = b0*q + a0*q + a0*p
;; b1 = b0*p + a0*q

;; a2 = b1*q + a1*q + a1*p
;; b2 = b1*p + a1*q

;; substitue a1 and b1 in the second equation with the first equation,
;; so that a2 and b2 will be expressed with a0 and b0.
;; a1 = b0*(q^2 + 2*p*q) + a0*(q^2 + 2*p*q) + a0*(q^2 + p^2)
;; b1 = b0*(q^2 + p^2) + a0*(q^2 + 2*p*q)

;; Therefore, p' = p^2 + q^2, q' = q^2 + 2*p*q.


(define (fib n)
  (fib-iter 1 0 0 1 n))
(define (fib-iter a b p q count)
  (cond ((= count 0) b)
        ((even? count)
         (fib-iter a
                   b
                   (+ (* p p) (* q q))      ; compute p'
                   (+ (* q q) (* 2 p q))      ; compute q'
                   (/ count 2)))
        (else (fib-iter (+ (* b q) (* a q) (* a p))
                        (+ (* b p) (* a q))
                        p
                        q
                        (- count 1)))))

(fib 1)
(fib 2)
(fib 3)
(fib 4)
(fib 5)
(fib 6)
(fib 7)
(fib 8)
(fib 9)
;; guile> 1
;; guile> 1
;; guile> 2
;; guile> 3
;; guile> 5
;; guile> 8
;; guile> 13
;; guile> 21
;; guile> 34



;; ================= ex 1.20 =================


(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))

;; R = remainder

;; normal-order evaluation
;; (gcd 206 40)
;; (gcd 40 (R 206 40))
;; (gcd (R 206 40) (R 40 (R 206 40))
;; (gcd (R 40 (R 206 40)) (R (R 206 40) (R 40 (R 206 40))))
;; (gcd (R (R 206 40) (R 40 (R 206 40)))
;;      (R (R 40 (R 206 40)) (R (R 206 40) (R 40 (R 206 40)))))
;; R -> 21-times

;; applicative-order evaluation
;; (gcd 206 40)
;; (gcd 40 (R 206 40)) = (gcd 40 6)
;; (gcd 6 (R 40 6)) = (gcd 6 4)
;; (gcd 4 (R 6 4)) = (gcd 4 2)
;; (gcd 2 (R 4 2)) = (gcd 2 0) = 2
;; R -> 4-times

;; ================= ex 1.21 =================
(define (smallest-divisor n)
  (find-divisor n 2))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n ) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))

(define (divides? a b)
  (= (remainder b a) 0))

(define (square n)
  (* n n))

(define (prime? n)
  (= n (smallest-divisor n)))

(smallest-divisor 199)
(smallest-divisor 1999)
(smallest-divisor 19999)


;; ================= ex 1.22 =================

;;(define (runtime) (tms:clock (times)))
(define (runtime) (cdr (gettimeofday)))

(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (start-prime-test n start-time)
  (if (prime? n)
      (report-prime (- (runtime) start-time))))

(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time)
  (newline))

;========================================================
(define (smallest-divisor n)
  (find-divisor n 2))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n ) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))

(define (divides? a b)
  (= (remainder b a) 0))

(define (square n)
  (* n n))

(define (prime? n)
  (= n (smallest-divisor n)))
;===========================================================


(define (find-prime from count)
  (if (> count 0)
      (if (prime? from)
          (begin (display from) (newline)
                 (find-prime (+ from 1) (- count 1)))
          (find-prime (+ from 1) count))))

(find-prime 1000 3)
(find-prime 10000 3)
(find-prime 100000 3)
(find-prime 1000000 3)
;; guile> 1009
;; 1013
;; 1019
;; guile> 10007
;; 10009
;; 10037
;; guile> 100003
;; 100019
;; 100043
;; guile> 1000003
;; 1000033
;; 1000037
;; guile> 

(timed-prime-test 1009)
(timed-prime-test 10007)
(timed-prime-test 100003)
(timed-prime-test 1000003)
;; guile> 
;; 1009 *** 121
;; guile> 
;; 10007 *** 304
;; guile> 
;; 100003 *** 1221
;; guile> 
;; 1000003 *** 9666
;; guile> 

;; (sqrt 10) = 3.16..
;; 304 := 121*3
;; 1221 := 304 *3
;; 9666 := 1221 *3

;; The consumed-time is increased by (sqrt 10)-times

;; ================= ex 1.23 =================

(define (smallest-divisor n)
  (find-divisor n 2))

;; (define (find-divisor n test-divisor)
;;   (cond ((> (square test-divisor) n ) n)
;;         ((divides? test-divisor n) test-divisor)
;;         (else (find-divisor n (+ test-divisor 1)))))
(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n ) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (next test-divisor)))))


(define (divides? a b)
  (= (remainder b a) 0))

(define (square n)
  (* n n))

(define (prime? n)
  (= n (smallest-divisor n)))


(define (next divisor)
  (if (= divisor 2) 3
      (+ divisor 2)))


(define (runtime) (cdr (gettimeofday)))

(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (start-prime-test n start-time)
  (if (prime? n)
      (report-prime (- (runtime) start-time))))

(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time)
  (newline))


;; result of old smallest-divisor
;; (timed-prime-test 1009)
;; (timed-prime-test 10007)
;; (timed-prime-test 100003)
;; (timed-prime-test 1000003)
;; guile> 
;; 1009 *** 121
;; guile> 
;; 10007 *** 304
;; guile> 
;; 100003 *** 1221
;; guile> 
;; 1000003 *** 9666

;; result of new smallest-divisor -> 1.5-times faster than old result!
(timed-prime-test 1009)
(timed-prime-test 1013)
(timed-prime-test 1019)
(timed-prime-test 10007)
(timed-prime-test 10009)
(timed-prime-test 10037)
(timed-prime-test 100003)
(timed-prime-test 100019)
(timed-prime-test 100043)
(timed-prime-test 1000003)
(timed-prime-test 1000033)
(timed-prime-test 1000037)
;; 1009 *** 93
;; 1013 *** 105
;; 1019 *** 75
;; 10007 *** 241
;; 10009 *** 221
;; 10037 *** 222
;; 100003 *** 914
;; 100019 *** 809
;; 100043 *** 793
;; 1000003 *** 10653
;; 1000033 *** 2012
;; 1000037 *** 2196

;; ================= ex 1.24 =================

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (square (expmod base (/ exp 2) m))
                    m))
        (else
         (remainder (* base (expmod base (- exp 1) m))
                    m))))

(define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (+ 1 (random (- n 1)))))

(define (fast-prime? n times)
  (cond ((= times 0) #t)
        ((fermat-test n) (fast-prime? n (- times 1)))
        (else #f)))


(fast-prime? 1009 10)
(fast-prime? 1008 10)


(define (runtime) (cdr (gettimeofday)))

(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (start-prime-test n start-time)
  (if (fast-prime? n 10)
      (report-prime (- (runtime) start-time))))

(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time)
  (newline))


;; result of ex1.23
;; 1009 *** 93
;; 1013 *** 105
;; 1019 *** 75
;; 10007 *** 241
;; 10009 *** 221
;; 10037 *** 222
;; 100003 *** 914
;; 100019 *** 809
;; 100043 *** 793
;; 1000003 *** 10653
;; 1000033 *** 2012
;; 1000037 *** 2196


;; result of ex1.24
;; time-consuming is increasing by O(logN).
;; But consumed-time of small value is bigger than old test procedure.
(timed-prime-test 1009)
(timed-prime-test 1013)
(timed-prime-test 1019)
(timed-prime-test 10007)
(timed-prime-test 10009)
(timed-prime-test 10037)
(timed-prime-test 100003)
(timed-prime-test 100019)
(timed-prime-test 100043)
(timed-prime-test 1000003)
(timed-prime-test 1000033)
(timed-prime-test 1000037)
;; 1009 *** 563
;; 1013 *** 562
;; 1019 *** 566
;; 10007 *** 667
;; 10009 *** 730
;; 10037 *** 937
;; 100003 *** 847
;; 100019 *** 8917
;; 100043 *** 747
;; 1000003 *** 833
;; 1000033 *** 834
;; 1000037 *** 871

;; ================= ex 1.25 =================

(define (expmod base exp m)
  (display base)
  (newline)
  (display exp)
  (newline)
  (remainder (expt base exp) m))


(define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (+ 1 (random (- n 1)))))

(define (fast-prime? n times)
  (cond ((= times 0) #t)
        ((fermat-test n) (fast-prime? n (- times 1)))
        (else #f)))


(fast-prime? 1009 10)
(fast-prime? 1008 10)


(define (runtime) (cdr (gettimeofday)))

(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (start-prime-test n start-time)
  (if (fast-prime? n 10)
      (report-prime (- (runtime) start-time))))

(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time)
  (newline))



(timed-prime-test 1009)
(timed-prime-test 1013)
(timed-prime-test 1019)
(timed-prime-test 10007)
(timed-prime-test 10009)
(timed-prime-test 10037)
(timed-prime-test 100003)
(timed-prime-test 100019)
(timed-prime-test 100043)
(timed-prime-test 1000003)
(timed-prime-test 1000033)
(timed-prime-test 1000037)


;; For (expt base exp), base and exp is very big value.
;; Therefore the time to calculate (expt base exp) becomes big.
;; result
;; 1009 *** 865
;; guile> 
;; 1013 *** 676
;; guile> 
;; 1019 *** 711
;; guile> 
;; 10007 *** 19754
;; guile> 
;; 10009 *** 15045
;; guile> 
;; 10037 *** 17016
;; guile> 
;; 100003 *** 231337
;; guile> 
;; 100019 *** 224720
;; guile> 
;; 100043 *** 230562
;; guile> 
;; 1000003 *** 213352


;; ================= ex 1.26 =================

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (* (expmod base (/ exp 2) m)
                       (expmod base (/ exp 2) m))
                    m))
        (else
         (remainder (* base (expmod base (- exp 1) m))
                    m))))

;; (expmod base (/ exp 2) m) is called two times.
;; Therefore the number of process is not decreased.
;; Finally the number of process is O(n).


;; ================= ex 1.27 =================
;; FAIL!

;; ================= ex 1.28 =================
;; FAIL!
