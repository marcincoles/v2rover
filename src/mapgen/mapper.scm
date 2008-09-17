#lang scheme
;mapper.scm
;generates maps for test purposes

(require (planet "json.ss" ("dherman" "json.plt" 1 1)))

(provide set-vehicle-params 
	 set-martian-params 
	 data->json 
	 add-craters 
	 add-boulders
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

(define add-obstacles
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
  (lambda (vehicle-run enemies-run)
    (define h (make-hash))
    (hash-set! h "vehicle" vehicle-run)
    (hash-set! h "enemies" enemies-run)
    h))


(define set-vehicle-params set-params)

(define set-martian-params set-params)

(define add-craters add-obstacles)

(define add-boulders add-obstacles)

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
             (let ([p (regexp-split " " line)])
               (hash-set! result (first p) (second p)))
             (loop)])))
      (close-input-port file)
      result)))
    