(defun read-char-safe ()
    (let ((c (read-char *standard-input* NIL 'eof)))
        (if (eq c 'eof)
            (exit)
            c
        )
    )
)

(let ((a NIL))
	(defun vm-peek-char ()
		(if a
			a
                        (setf a (read-char-safe))
		)
	)
	(defun vm-read-char ()
		(if a
			(let ((ret a))
				(progn
					(setf a NIL)
					ret
				)
			)
                        (read-char-safe)
		)
	)				
)

(defun char-to-str (ch)
	(coerce (cons ch NIL) 'string))

(defun vm-append-char-string (ch str)
	(concatenate 'string (char-to-str ch) str)
)

(defun vm-read-num ()
	(if (digit-char-p (vm-peek-char))
		(vm-append-char-string (vm-read-char) (vm-read-num))
		NIL)
)

(defun vm-read-token ()
	(cond
                ((eq (vm-peek-char) #\linefeed)
                    (progn
                        (vm-read-char)
                        (cons NIL NIL)
                    )
                )
		((digit-char-p (vm-peek-char))
			(cons (vm-read-num) NIL))
		((eq (vm-peek-char) #\+)
			(cons (char-to-str (vm-read-char)) NIL))
		((eq (vm-peek-char) #\*)
			(cons (char-to-str (vm-read-char)) NIL))
		((eq (vm-peek-char) #\()
			(cons (char-to-str (vm-read-char)) NIL))
		((eq (vm-peek-char) #\))
			(cons (char-to-str (vm-read-char)) NIL))
                (1
                    (progn
                        (vm-read-char)
                        NIL
                    )
                )
	)
)

(defun vm-eval-lvalue-rest (lval level)
    (let ((token (vm-read-token)))
        (cond
            ((eq token NIL)
                (error-read-until-newline)
            )
            ((eq (car token) NIL)
                (if (equal level 0)
                    lval
                    (error-now))
            )
            ((string-equal (car token) ")")
                (if (equal level 0)
                    (error-read-until-newline)
                    lval
                )
            )
            ((string-equal (car token) "+")
                (let ((res (vm-eval level)))
                    (if (symbolp res)
                        res
                        (+ lval res)
                    )
                )
            )
            ((string-equal (car token) "*")
                (let ((res (vm-eval-single-token level)))
                    (if (symbolp res)
                        res
                        (vm-eval-lvalue-rest (* lval res) level)
                    )
                )
            )
            (T (error-read-until-newline))
        )
    )
)

(defun vm-eval-single-token (level)
    (let ((token (vm-read-token)))
            (cond
                    ((eq token NIL)
                        (error-read-until-newline)
                    )
                    ((eq (car token) NIL)
                        (error-now)
                    )
                    ((or (string-equal (car token) "+") (string-equal (car token)  "*") (string-equal (car token) ")"))
                        (error-read-until-newline)
                    )
                    ((string-equal (car token) "(") (vm-eval (+ level 1)))
                    (T (parse-integer (car token)))
            )
    )
)

(defun error-now ()
    'ERROR
)

(defun error-read-until-newline ()
    (let ((token (vm-read-token)))
        (if (eq token NIL)
            (error-read-until-newline)
            (if (eq (car token) NIL)
                'ERROR
                (error-read-until-newline)
            )
        )
    )
)

(defun vm-eval (level)
        (let ((token (vm-read-token)))
                (cond
                        ((eq token NIL)
                            (error-read-until-newline)
                        )
                        ((eq (car token) NIL)
                            (error-now)
                        )
                        ((or (string-equal (car token) "+") (string-equal (car token)  "*") (string-equal (car token) ")"))
                            (error-read-until-newline)
                        )
                        ((string-equal (car token) "(")
                            (let ((res (vm-eval (+ level 1))))
                                (if (symbolp res)
                                    res
                                    (vm-eval-lvalue-rest
                                        res
                                        level
                                    )
                                )
                            )
                        )
                        (T (vm-eval-lvalue-rest (parse-integer (car token)) level))
                )
        )
)

(defvar n (parse-integer (vm-read-num)))
(vm-read-char)

(defun vm-run-for (a)
    (when (> a 0)
        (vm-run-for (- a 1))
        (print (vm-eval 0))
    )
)

(vm-run-for n)
