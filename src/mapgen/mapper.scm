#lang scheme/base
;mapper.scm
;generates maps for test purposes

(require (planet "json.ss" ("dherman" "json.plt" 1 1)))

(provide set-vehicle-params params->json)

(define set-vehicle-params 
  (lambda (maxSpeed accel brake turn hardTurn rotAccel frontView rearView)
    ;(display "in set-vehicle-params")
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

(define params->json
  (lambda (p)
    (define o (open-output-string))
    (write p o)
    (get-output-string o)))