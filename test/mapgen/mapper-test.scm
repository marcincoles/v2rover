#lang scheme/base
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
;when we use params->json
  (test-case
   "check JSON string of the hash from set-vehicle-params"
   (let* ( [x (set-vehicle-params 100.0 10.0 5.0 12.0 24.0 9.0 50.0 25.0)] 
          [str "{\"maxSpeed\": 100.0, \"accel\": 10.0, \"brake\": 5.0, \"turn\": 12.0, \"hardTurn\": 24.0, \"rotAccel\": 9.0, \"frontView\": 50.0, \"rearview\": 25.0}"]
          [x-json (params->json x)])
     (check-pred string? x-json)
     (check string=? x-json str)))


