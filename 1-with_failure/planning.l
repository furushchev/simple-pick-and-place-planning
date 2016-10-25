;; planning.l
;; Author: Yuki Furuta <furushchev@jsk.imi.i.u-tokyo.ac.jp>

(ros::roseus "simple_metric_plan")
(require :eus-pddl-client "package://pddl_planner/src/eus-pddl-client.l")

;; define domain
(setq *domain* (instance pddl-domain :init :name 'simple_failure_torelant_domain))
(send *domain* :requirements '(:typing))
(send *domain* :types '(item spot))
(send *domain* :predicates
      '((ON ?OBJ - item ?SPOT - spot)
        (ONHAND ?OBJ - item)
        (AT ?SPOT - spot)))
(send *domain* :constants
      '(FLOOR - spot))
(setq *actlist*
      (list
       (instance pddl-action :init
                 :name "move-to"
                 :parameters '((?TO spot))
                 :precondition '((NOT (AT ?TO)))
                 :effect '((forall (?AT - spot)
                            (NOT (AT ?AT)))
                           (AT ?TO)))
       (instance pddl-action :init
                 :name "pick"
                 :parameters '((?OBJ item))
                 :precondition '((EXISTS (?AT - spot)
                                   (AND (ON ?OBJ ?AT)
                                        (AT ?AT))))
                 :effect '((FORALL (?AT - spot)
                             (NOT (ON ?OBJ ?AT)))
                           (ONHAND ?OBJ)))
       (instance pddl-action :init
                 :name "place"
                 :parameters '((?OBJ item))
                 :precondition '((ONHAND ?OBJ))
                 :effect '((NOT (ONHAND ?OBJ))
                           (FORALL (?AT - spot)
                            (when (AT ?AT) (ON ?OBJ ?AT)))))
       (instance pddl-action :init
                 :name "place_f"
                 :parameters '((?OBJ item))
                 :precondition '((ONHAND ?OBJ))
                 :effect '((NOT (ONHAND ?OBJ))))
       (instance pddl-action :init
                 :name "search-floor"
                 :parameters '((?OBJ item))
                 :precondition '((AND
                                  (FORALL (?AT - spot)
                                   (NOT (ON ?OBJ ?AT)))
                                  (NOT (ONHAND ?OBJ))))
                 :effect '((ON ?OBJ FLOOR)))
       ))

(dolist (a *actlist*)
  (send *domain* :add :action a))

;; define problem
(setq *problem* (instance pddl-problem :init :name 'push_button :domain 'simple_failure_torelant_domain))
(send *problem* :objects
      '((CUP . item)
        (TABLESIDE . spot)
        (KITCHEN . spot)))

(send *problem* :initial-condition
      '((ON CUP TABLESIDE)))

(send *problem* :goal-condition
      '((ON CUP KITCHEN)))

;; declare defined-failure nodes
(setq *failed-nodes* (list 'place))

;; solve plan and make transition graph
(require :pddl-result-graph "package://pddl_planner/src/pddl-result-graph.l")
(setq *graph*
      (pddl-plan-to-graph nil :domain *domain* :problem *problem* :failed-nodes *failed-nodes* :debug t))

;; show graph
(when (ros::get-param "~display_graph" t)
  (send *graph* :write-to-pdf "/tmp/graph.pdf" nil "simple_failure_torelant")
  (piped-fork "gnome-open /tmp/graph.pdf"))

;; convert into SMACH
(require :pddl2smach "package://roseus_smach/src/pddl2smach.l")
(require :state-machine-ros "package://roseus_smach/src/state-machine-ros.l")

(setq *sm-inspect* (pddl-graph-to-smach *graph*
                                        :add-self-return-failure-path nil))

(unix::sleep 1)
(send *sm-inspect* :reset-state)

(provide :planning) ;; end of planning.l
