#lang scheme/base
;(require (planet "main.ss" ("schematics" "schemeunit.plt" 3 3)))
(require (planet schematics/schemeunit:3) "../../src/mapgen/mapper.scm")
(require (planet "json.ss" ("dherman" "json.plt" 1 1)))

;test the map data generation

;firstly, check set-vehicle-params
  (test-case
   "check output of set-vehicle-params"
   (let ( (x (set-vehicle-params 100.0 10.0 5.0 12.0 24.0 9.0 50.0 25.0)) )
     (check-pred hash? x)
     (check = (hash-ref x "maxSpeed") 100.0)
     (check = (hash-ref x "accel") 10.0)
     (check = (hash-ref x "brake") 5.0)
     (check = (hash-ref x "turn") 12.0)
     (check = (hash-ref x "hardTurn") 24.0)
     (check = (hash-ref x "rotAccel") 9.0)
     (check = (hash-ref x "frontView") 50.0)
     (check = (hash-ref x "rearView") 25.0)))
   
  

;function is set-map-details


