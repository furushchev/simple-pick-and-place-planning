(define (domain SIMPLE_FAILURE_TORELANT_DOMAIN)
(:requirements :typing)
(:types 
ITEM SPOT )
(:predicates
(on ?obj - item ?spot - spot) (onhand ?obj - item) (at ?spot - spot) )
(:action move-to
:parameters (?to - spot)
:precondition (and (not (at ?to)))
:effect (and (forall (?at - spot) (not (at ?at))) (at ?to))
)
(:action pick
:parameters (?obj - item)
:precondition (and (exists (?at - spot) (and (on ?obj ?at) (at ?at))))
:effect (and (forall (?at - spot) (not (on ?obj ?at))) (onhand ?obj))
)
(:action place
:parameters (?obj - item)
:precondition (and (onhand ?obj))
:effect (and (not (onhand ?obj)) (forall (?at - spot) (when (at ?at) (on ?obj ?at))))
)
)
