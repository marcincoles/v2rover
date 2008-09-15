#lang scheme
(require (planet schematics/schemeunit:3) "../../src/mapgen/mapper.scm")
;(require (planet "json.ss" ("dherman" "json.plt" 1 1)))

;test the map data generation

;firstly, check set-vehicle-params
  (test-case
   "check output of set-vehicle-params"
   (let ( [x (set-vehicle-params 100.0 10.0 5.0 12.0 24.0 9.0 50.0 25.0)] )
     
     (check-pred hash? x)
     (check = (hash-ref x "maxSpeed") 100.0)
     (check = (hash-ref x "accel") 10.0)
     (check = (hash-ref x "brake") 5.0)
     (check = (hash-ref x "turn") 12.0)
     (check = (hash-ref x "hardTurn") 24.0)
     (check = (hash-ref x "rotAccel") 9.0)
     (check = (hash-ref x "frontView") 50.0)
     (check = (hash-ref x "rearView") 25.0)))
   
;now check that it comes out as a correctly formatted JSON message
;when we use data->json to convert the item to it's json representation, we need to check it
  (test-case
   "check JSON string of the hash from set-vehicle-params"
   (let* ( [x (set-vehicle-params 100.0 10.0 5.0 12.0 24.0 9.0 50.0 25.0)] 
          [str "{\"maxSpeed\": 100.0, \"accel\": 10.0, \"brake\": 5.0, \"turn\": 12.0, \"hardTurn\": 24.0, \"rotAccel\": 9.0, \"frontView\": 50.0, \"rearView\": 25.0}"]
          [x-json (data->json x)]
	  [r (pregexp "\\{(\\s*\"\\w+\"\\s*:\\s*-?\\w+(\\.\\d+)?\\s*,?)+\\}")]
	  [fields (regexp-split "," (substring str 1 (- (string-length str) 1)))])
     ;;r - regexp
     (check-pred string? x-json "correct type")
     (check regexp-match r str "check for correct regexp-match on JSON string")
     ;fields each (map across all the fields and check the name/value pairs
     (for-each (lambda (z) (define y (regexp-split ":" z)) 
            ;;the following line checks that the x-json string contains the same name:value pairs as the hash x
            (check-equal? (hash-ref x (first (regexp-match #px"\\w+" (first (regexp-match #px"\"\\w+\"" (first y))))))  (string->number (regexp-replace* #px"\\s*" (second y) "") ))) fields)))
  
;next, check creating craters
  (test-case
   "check output of add-craters"
   (let* ([number-of-craters 5]
          [min-rad 0.5]
          [max-rad 10]
          [quadrant-size 200]
          [x (add-craters number-of-craters min-rad max-rad quadrant-size)])
     
     (check-pred list? x)
     (check-equal? (length x) number-of-craters)
     (map (lambda (h) 
                 (check-pred (lambda (hh) (and (>= (hash-ref hh "x") (- quadrant-size))
                                           (<= (hash-ref hh "x") quadrant-size)
                                      (>= (hash-ref hh "y") (- quadrant-size))
                                      (<= (hash-ref hh "y") quadrant-size)
                                      (>= (hash-ref hh "r") min-rad)
                                      (<= (hash-ref hh "r") max-rad))) h "Crater values out of range")) x)))

  (test-case
   "check output of set-vehicle-run"
   (let ([x (set-vehicle-run 12.4 -29 27.6)])
     (check-pred hash? x "should be a hash")
     (check = (hash-ref x "x") 12.4)
     (check = (hash-ref x "y") -29)
     (check = (hash-ref x "dir") 27.6)))
  
  (test-case
   "check output of set-enemy-run"
   (let ([x (set-enemy-run 124.4 112.1 -12.6 2.2 1.1)])
     (check-pred hash? x "should be a hash")
     (check = (hash-ref x "x") 124.4)
     (check = (hash-ref x "y") 112.1)
     (check = (hash-ref x "dir") -12.6)
     (check = (hash-ref x "speed") 2.2)
     (check = (hash-ref x "view") 1.1)))
   
  (test-case
   "check output of set-enemies-run"
   ;; since set-enemy-run is tested elsewhere, test to ensure the list is right
   (let* ([number-of-martians 3]
          [quadrant-size 200]
          [max-speed 5]
          [max-view 2]
          [x (set-enemies-run number-of-martians quadrant-size max-speed max-view)])
     
     (check-pred list? x)
     (check-equal? (length x) number-of-martians)
     (map (lambda (h) 
            (check-pred hash? h)
            (check-pred (lambda (hh) (and (>= (hash-ref hh "x") (- quadrant-size))
                                          (<= (hash-ref hh "x") quadrant-size)
                                          (>= (hash-ref hh "y") (- quadrant-size))
                                          (<= (hash-ref hh "y") quadrant-size)
                                          (<= (hash-ref hh "speed") max-speed)
                                          (<= (hash-ref hh "view") max-view))) h "Martian values out of range")) x)))
  
 (test-case
   "check output of set-run"
   (let* ([number-of-runs 2]
          [number-of-martians 3]
          [quadrant-size 200]
          [max-speed 5]
          [max-view 2]
          [mr (set-enemies-run number-of-martians quadrant-size max-speed max-view)]
          [vr (set-vehicle-run -11.3 -105.22 -32.1)]
          [run (set-run vr mr)])
     (check-pred hash? run)
     (let* ([vehicle (hash-ref run "vehicle")]
            [martians (hash-ref run "enemies")])
       (check-pred hash? vehicle)
       (check-pred list? martians))))

; (test-case
;  "check output of set-map"
;  (let* ([size 200]
;         [time-limit 30]
;         [vehicle-params (set-vehicle-params 100.0 10.0 5.0 12.0 24.0 9.0 50.0 25.0)]
;         [martian-params (set-martian-params 90.0 9.0 5.0 12.0 24.0 9.0 50.0 25.0)]
;         [craters (add-craters 50 1.5 10 size)]
;         [boulders (add-boulders 100 1.0 5.5 size)]
;         [runs (list (set-run (set-vehicle-run -11.3 -105.22 -32.1) 
;                              (set-enemies-run 5 size 10 2))
;                     (set-run (set-vehicle-run (random 200) (random 200) 12.1) 
;                              (set-enemies-run 10 size 12 3)))]
;         [m make-hash)
;    (check-pred 
                     
 