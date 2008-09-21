#lang scheme
;mapper.scm
;generates maps for test purposes

(require (planet "json.ss" ("dherman" "json.plt" 1 1)))
(require (lib "string.ss"))

(provide set-vehicle-params 
	 set-martian-params 
	 data->json 
	 set-craters 
	 set-boulders
	 set-vehicle-run
	 set-enemy-run
	 set-enemies-run
	 set-run)

(define set-params 
  (lambda (maxSpeed accel brake turn hardTurn rotAccel frontView rearView)
    (define p (make-hash))
    (hash-set! p "maxSpeed" maxSpeed)
    (hash-set! p "accel" accel)
    (hash-set! p "brake" brake)
    (hash-set! p "turn" turn)
    (hash-set! p "hardTurn" hardTurn)
    (hash-set! p "rotAccel" rotAccel)
    (hash-set! p "frontView" frontView)
    (hash-set! p "rearView" rearView)
    p))

(define set-obstacles
;; obstacles include craters and boulders
  (lambda (number-of-obstacles min-rad max-rad quadrant-size)
    (build-list number-of-obstacles 
		(lambda (i)
		  (define h (make-hash))
		  (hash-set! h "x" (- (random (* quadrant-size 2)) quadrant-size))
		  (hash-set! h "y" (- (random (* quadrant-size 2)) quadrant-size))
		  (hash-set! h "r" (+ (* (random) (- max-rad min-rad)) min-rad))
		  h))))

(define set-vehicle-run
;; the starting postion & direction of the rover for a run
  (lambda (x y dir)
    (define h (make-hash))
    (hash-set! h "x" x)
    (hash-set! h "y" y)
    (hash-set! h "dir" dir)
    h))

(define set-enemy-run
;; the starting postion & direction of a martian for a run
  (lambda (x y dir speed view)
    (define h (set-vehicle-run x y dir))
    (hash-set! h "speed" speed)
    (hash-set! h "view" view)
    h))

(define set-enemies-run
  (lambda (number-of-martians quadrant-size max-speed max-view)
    (build-list number-of-martians
		(lambda (i)
		  (set-enemy-run (- (random (* quadrant-size 2)) quadrant-size)
				 (- (random (* quadrant-size 2)) quadrant-size)
				 (* 360 (random))
				 (* max-speed (random))
				 (* max-view (random)))))))

(define set-run
  (lambda (x y dir number-of-martians quadrant-size max-speed max-view)
    (define h (make-hash))
    (hash-set! h "vehicle" (set-vehicle-run x y dir))
    (hash-set! h "enemies" (set-enemies-run number-of-martians quadrant-size max-speed max-view))
    h))
  
;(define set-runs
;  (lambda (x y dir number-of-martians quadrant-size max-speed max-view)
;    (if (

(define set-vehicle-params set-params)

(define set-martian-params set-params)

(define set-craters set-obstacles)

(define set-boulders set-obstacles)

(define set-size
  (lambda (s)
    s))

(define set-time-limit
  (lambda (s)
    s))

(define data->json
  (lambda (p)
    (define o (open-output-string))
    (write p o)
    (get-output-string o)))

(define generator
  (lambda (filename)
    (let ([file (open-input-file filename)]
          [result (make-hash)])
      (let loop ()
        (let ([line (read-line file)])
          (cond
            [(eof-object? line)
             (printf "that's it ~n")]
            [else 
             (printf "> ~a <~n" line)
             
             (let* ([params (regexp-split " " line)]
                    [x (first params)]
                    [param-name (regexp-replace #px"(-)(\\w)(\\w+)$" x (lambda (all one two three) (string-append (string-upcase two) three)))]
                    [function-name (string-append "set-" x)]
                    ;function string replaces the name of the parameter starting the line, with the appropriate function name
                    [function-string (string-append "(" (regexp-replace #px"^(\\w)+(-[\\w\\d]+)*" line function-name) ")")])
               (if (string=? x "run")
                   (hash-set! result "runs" (if (hash-ref result "runs" (lambda () (display "no runs yet") (newline) #f))
                                                (append (hash-ref result "runs") (eval-string function-string))
                                                (list (eval-string function-string))))
                   (hash-set! result param-name (eval-string function-string))))
             (loop)])))
      (close-input-port file)
      result)))
    
;(hash-for-each x (lambda (k v)
;                     (printf "x[~a] is a ~a => json? ~a~n" k (cond
;                                                               [(hash? v) "hash"]
;                                                               [(list? v) "list"]
;                                                               [else "other"]) (json? v))))