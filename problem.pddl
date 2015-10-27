(define (problem PUSH_BUTTON)
(:domain SIMPLE_FAILURE_TORELANT_DOMAIN)
(:objects CUP - ITEM
TABLESIDE KITCHEN - SPOT)
(:init (on cup tableside))
(:goal (and (on cup kitchen)))
)