(define test (lambda (a) a))

(test 600)

(define
	fac (lambda (a)
	(
		if (eq? a 0)
			1
			(* a (fac (- a 1))
			)
	)
))

(fac 10)

(define
	fib (lambda (a)
	(
		if (< a 3)
			1
			(+ (fib (- a 2)) (fib (- a 1)))
	)
))

(print "Hello, world")

