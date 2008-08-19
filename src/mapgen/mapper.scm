#lang scheme/base
;mapper.scm
;generates maps for test purposes

(provide set-vehicle-params)

(define set-vehicle-params 
  (lambda (maxSpeed accel brake turn hardTurn rotAccel frontView rearView)
    (display "in set-vehicle-params")
    ))