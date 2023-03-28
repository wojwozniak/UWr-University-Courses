#lang plait


(define-type Prop
(var [v : String])
(conj [l : Prop] [r : Prop])
(disj [l : Prop] [r : Prop])
(neg [f : Prop]) )

(define prop1 (var "x"))

(define prop2 (var "y"))

(define prop3 (conj prop1 prop2))

(define prop4 (disj prop3 prop1))

(define prop5 (disj prop1 prop2))

(define ht (make-hash (list (pair "x" #f) (pair "y" #t))))


(define (iter f)
   (cond 
    [(neg? f)   (not (iter (neg-f f)))]
    [(disj? f)  (or (iter (disj-r f)) (iter (disj-l f)))]
    [(conj? f)  (and (iter (conj-r f)) (iter (conj-l f)))]
    [else (some-v (hash-ref ht (var-v f)))]
  )
)



(iter (conj prop5 prop1))

     