(let ((a NIL))
	(defun vm-peek-char ()
		(if a
			a
			(setf a (read-char))
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
			(read-char)
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
			(cons NIL NIL))
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
	)
)

(defun vm-eval ()
	(let ((token (vm-read-token)))
		(cond
			((eq token #\() (vm-eval))
			(1 NIL))
	)
)

(print (vm-eval))

