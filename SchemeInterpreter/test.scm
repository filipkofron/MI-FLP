(define
	fac (lambda (a)
	(
		(if (eq a 0)
			1
			(* (fac (- a 1)) a)
		)
	)
)

