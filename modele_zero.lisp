(clear-all)

(defvar *model-action* ) ; La variable que le model devra remplir (liste de valise)
;; Classe voiture
(defclass voiture()
   (poids
   vitesse
   positionX
   positionY
   )
)


(defun show-learning (n &optional (graph t))
   (let (points)
   (dotimes (i n);; ici pour des blocs de 100
      (push (run-blocks 1 100) points)
   )
   ) 

   ;;(setf points (rev points))
   ;;(when graph
   ;;   (draw-graph points)
   ;;)
)

;;(defun rev(l)
;;   (cond
;;      ((null l) '())
;;      (T (append (rev (cdr l)) (list (car l))))
;;   )
;;) 


(defun run-blocks (blocks block-size)     
   (dotimes (i blocks)
      (setf retour (place_elements block-size))
   )
   retour
)

;; Fonction pour placer les voitures sur les voies
(defun place_elements (n-times &optional (draw-highway nil))
   
   (let (scores (need-to-remove (add-key-monitor)))
      (setf nbWin 0)
      (dotimes (i n-times)
         (setf tour 1)
         (setf not-win t) ; t = true, nil = false
         (setf res nil)
         (setf state nil)

         (format t "Avant voiture ~C~C" #\return #\linefeed )
         (setf *voitures* (create-voitures)); Creation de notre voiture et de la voiture accident
         ;; TODO : creation d'autres usagers = (setf *usagers* (create-usagers)); Creation des voitures des autres usagers si complexification

         
         ;(let (window (open-exp-window "UNE FENETRE")))

         (while not-win ; appeler le modèle tant qu'il n'a pas win ou pas crash
            (format t "    On est dans le boucle ~d fois ~C~C" tour #\return #\linefeed )
         
            ;; un genre de reset pour le modele je crois
            ;; 1er élément de la liste je crois, donc notre modele
            (setf (slot-value (car *voitures*) 'positionX) 0) 
            (setf (slot-value (car *voitures*) 'positionY) 0) 
            ;; 2nd élément de la liste je cris, donc la voiture accident
            (setf (slot-value (cadr *voitures*) 'positionX) 0)
            (setf (slot-value (cadr *voitures*) 'positionY) 10)

            (let ((choix-model (show-model-highway *voitures* res state))); Montre notre voiture et l'accident au modèle et enregistre la key pressée par le model
               (format t "L'action choisie par le modele est ~s ~C~C" choix-model #\return #\linefeed )

               ;; 1 = frein faible, 2 = frein fort, 3 = turnR, 4 = turnL
               (format t "CPT POST LET CHOIX MODEL ~C~C" #\return #\linefeed )
               (when (string-equal "1" choix-model) (progn
                  (setf tour (+ tour 1)) ;; incrémente le nombre de tour
                  (setf (slot-value (car *voitures*) 'vitesse) (- (slot-value (car *voitures*) 'vitesse) 1)) ;; "moyen ? faible ?")  int ou string ?
                  (setf state "Un state à choisir"))
               ) ; TODO

               (when (string-equal "2" choix-model) (progn
                  (setf tour (+ tour 1)) ;; incrémente le nombre de tour
                  (setf (slot-value (car *voitures*) 'vitesse) (- (slot-value (car *voitures*) 'vitesse) 2)) ;; "moyen ? faible ?")  int ou string ?
                  (setf state "Un state à choisir"))
               ) ; TODO

               (when (string-equal "3" choix-model) (progn
                  (setf tour (+ tour 1)) ;; incrémente le nombre de tour?
                  (setf (slot-value (car *voitures*) 'positionX) (+ (slot-value (car *voitures*) 'positionX) 1))
                  (setf state "Un state à choisir"))
               ) ; TODO

               (when (string-equal "4" choix-model) (progn
                  (setf tour (+ tour 1)) ;; incrémente le nombre de tour
                  (setf (slot-value (car *voitures*) 'positionX) (- (slot-value (car *voitures*) 'positionX) 1))
                  (setf state "Un state à choisir"))
               ) ; TODO

               (format t "CPT 3 ~C~C" #\return #\linefeed )
               ;; check si la vitesse ne passe pas en dessous de un
               (if (< (slot-value (car *voitures*) 'vitesse)  1)
                  (setf (slot-value (car *voitures*) 'vitesse) 1)
               )  
               ;; TODO : inverse
                  
               (format t "CPT 4 ~C~C" #\return #\linefeed )
               (setf res "on verra") ;; changer les valeurs dans les if 

               ;; Les deux voitures sont sur la même case
               (if (= (slot-value (car *voitures*) 'positionX)  (slot-value (cadr *voitures*) 'positionX))  
                  (if (= (slot-value (car *voitures*) 'positionY)  (slot-value (cadr *voitures*) 'positionY))  
                     (setf res "crash") 

                     ;; TODO : code a priori qu'on doit faire
                     ;(setf state " - un state a definir - ")
                     ;(setf not-win nil)
                     ;(show-model-result res state)

                     ;; pourquoi ce unless 0 ? eut être à enlever
                     (progn (setf not-win nil)
                        (unless (string-equal choix-model "0")(progn 
                           (setf state "final")
                           (show-model-result res state))
                        )
                     )
                  )
               )

               ;; La voiture a dépasse l'accident, on gagne
               (if (> (slot-value (car *voitures*) 'positionX)  (slot-value (cadr *voitures*) 'positionX))    
                  (setf res "win") ;; Les deux voitures sont sur la même case

                  ;; TODO : code a priori qu'on doit faire
                  ;(setf state " - un state a definir - ")
                  ;(setf not-win nil)
                  ;(show-model-result res state)

                  ;; pourquoi ce unless 0 ? eut être à enlever
                  (progn (setf not-win nil)
                     (unless (string-equal choix-model "0")(progn 
                        (setf state "final")
                        (show-model-result res state))
                     )
                  )
               )

               ;;(loop for usager in *usagers* ; on traite toutes les voitures autour
               ;;   ; TODO : faire des if crash sur chaque voiture
               ;;)
      

               (when draw-highway
                  (format t "TODO : print l'autoroute")
                  ;;(print-model (car *voitures*))
                  ;;(print-accident (cadr *voitures*))
                  ;;(print-route)
               )

               (if (= res "win")
                  (setf nbWin (+ nbWin 1))
               )
            )
            (format t "Fin let ~C~C" #\return #\linefeed )
         )
      )
      (format t "On a win ~d fois sur ~d essais" nbWin n-times)
   )
   
   (when need-to-remove
      (remove-key-monitor)
   )
)


(defun create-voitures ()
   ;; Création de l'instance des voitures
   (defparameter *model* (make-instance 'voiture))
   (defparameter *accident* (make-instance 'voiture))

   (setf (slot-value *model* 'poids) 1) ; poids pas aléatoire pour l'instant 
   (setf (slot-value *model* 'vitesse) 5)
   (setf (slot-value *model* 'positionX) 0) ; voie du milieu
   (setf (slot-value *model* 'positionY) 0) ; tout en bas de la route
   
   (setf (slot-value *accident* 'poids) 1) ; poids pas aléatoire pour l'instant 
   (setf (slot-value *accident* 'vitesse) 5)
   (setf (slot-value *accident* 'positionX) 0) ; voie du milieu
   (setf (slot-value *accident* 'positionY) 10) ; tout en haut de la route
   
   (defvar voitures-list (list *model* *accident*)) ; ajout des voitures dans une liste

   voitures-list
); return la liste avec [0] notre model et [1] l'accident

(defun create-usagers() ;; TODO :pour plus tard
   (defparameter *usager1* (make-instance 'voiture))
   (defparameter *usager2* (make-instance 'voiture))
   (defparameter *usager3* (make-instance 'voiture))

   ; boucle qui génère les voitures autours (innutile au début)
   (loop for voiture in voitures-autour-list 
      do (progn
            (setf (slot-value voiture 'poids) 1) ; poids pas aléatoire pour l'instant 
            (setf (slot-value voiture 'vitesse) moyen)
            (setf (slot-value voiture 'positionX) (act-r-random 2)) ; voie du milieu
            (setf (slot-value voiture 'positionY) (+ 3 (act-r-random 5))) ; quelque part sur l'axe y
            ;; Dimension selon la catégorie
            (case (slot-value voiture 'positionX)
               (1 (progn (setf (slot-value voiture 'positionX)-1)))
               (3 (progn (setf (slot-value voiture 'positionX) 1)))
            )
            )
   )
   (defvar voitures-autour-list (list *usager1* *usager2*  *usager3*))
   voitures-autour-list
)

(defun show-model-highway (voitures &optional res state)
   (format t "Goal buffer = ~s ~C~C" (buffer-read 'goal) #\return #\linefeed )
   (if (buffer-read 'goal) ;; s'il y a un chunk dans le buffers goal 
      (mod-focus-fct `(state ,"non accidente "
                        result      ,"TODO"
                        m_weight    ,(slot-value (car voitures) 'poids) 
                        m_positionX ,(slot-value (car voitures) 'positionX) 
                        m_positionY ,(slot-value (car voitures) 'positionY) 
                        m_vitesse   ,(slot-value (car voitures) 'vitesse) 
                        a_positionX ,(slot-value (cadr voitures) 'positionX) 
                        a_positionY ,(slot-value (cadr voitures) 'positionY) 
                        a_vitesse   ,(slot-value (cadr voitures) 'vitesse) 
                     ) 
      )
      (goal-focus-fct (car (define-chunks-fct ; crée un nouveau chunk et le met dans le goal
                             `((isa check-state 
                                m_weight    ,(slot-value (car voitures) 'poids) 
                                 m_positionX ,(slot-value (car voitures) 'positionX) 
                                 m_positionY ,(slot-value (car voitures) 'positionY) 
                                 m_vitesse   ,(slot-value (car voitures) 'vitesse) 
                                 a_positionX ,(slot-value (cadr voitures) 'positionX) 
                                 a_positionY ,(slot-value (cadr voitures) 'positionY) 
                                 a_vitesse   ,(slot-value (cadr voitures) 'vitesse) 
                                 result      ,nil
                                 state       start
                              ))
                           )
                        )
      )
   )
   (format t "ACTR Action ~C~C" #\return #\linefeed )
   (run-full-time 10)
   *model-action*
)


(defun show-model-result (res state)
   (if (buffer-read 'goal) ; s'il y a un chunk dans le buffers goal
      (mod-focus-fct `(result ,res
                        state ,state)
      )
      (goal-focus-fct (car (define-chunks-fct ; crée un nouveau chunk et le met dans le goal
                             `(isa check-state
                                 result ,res
                                 state ,state
                                 id, 0)
                           )
                        )
      )
   )
   (run-full-time 10)
)

(defvar *key-monitor-installed* nil)

(defun add-key-monitor ()
   (unless *key-monitor-installed*
      (add-act-r-command "1hit-bj-key-press" 'respond-to-keypress 
                        "highway task key output monitor")
      (monitor-act-r-command "output-key" "1hit-bj-key-press")
      (setf *key-monitor-installed* t)
   )
)

(defun respond-to-keypress (model key)
   (if model
      (setf *model-action* key)
      (clear-exp-window)
   )
   key
)

(defun remove-key-monitor ()
  (remove-act-r-command-monitor "output-key" "1hit-bj-key-press")
  (remove-act-r-command "1hit-bj-key-press")
  (setf *key-monitor-installed* nil)
)

;;(defun draw-graph (points)
;;  (let ((w (open-exp-window "Data" :width 550 :height 460 :visible t)))
;;      (allow-event-manager w)
;;      (add-line-to-exp-window '(50 0) '(50 420) :color 'white :window "Data")
;;
;;      (dotimes (i 11)
;;         (add-text-to-exp-window :x 5 :y (+ 5 (* i 40)) :width 35 :text (format nil "~3,1f" (* (- 1 (* i .1)) 3)) :window "Data")
;;         (add-line-to-exp-window (list 45 (+ 10 (* i 40))) (list 550 (+ 10 (* i 40))) :color 'white :window "Data")
;;      )
;;    
;;      (let ((x 50))
;;         (mapcar (lambda (a b) (add-line-to-exp-window  (list x (floor (- 410 (* a 400))))
;;                                                         (list (incf x 25) (floor (- 410 (* b 400))))
;;                                                         :color 'blue :window "Data")
;;                  )
;;            (butlast points) (cdr points)
;;         )
;;      )
;;      (allow-event-manager w)
;;   )
;;)


;; marche pas (defmethod rpm-window-key-event-handler ((win rpm-window) key)
;; marche pas   (if (eq win (current-device))
;; marche pas       (setf *model-action* (string key))
;; marche pas     (unless *human-action*
;; marche pas       (setf *human-action* (string key))
;; marche pas     )
;; marche pas    )
;; marche pas )



;(defmethod rpm-window-key-event-handler ((win rpm-window) key)
;  (setf *model-action* (string key)))



(define-model conductor
    
   ;;(sgp :v nil :esc t :lf 0.4 :bll 0.5 :ans 0.5 :rt 0 :ncnar nil)
   (sgp :esc t :lf .05)
   (install-device (open-exp-window "" :visible nil))

   ;; ------------------------------ Add Chunk-types here ------------------------------

   (chunk-type check-state state result m_weight m_positionX m_positionY m_vitesse a_positionX a_positionY a_vitesse action)
   ; TODO : nom de chunktype a changer car copier coller
   (chunk-type learned-info result m_weight m_positionX m_positionY m_vitesse a_positionX a_positionY a_vitesse t_left t_right b_soft b_hard)
   (chunk-type car id weight)
   (chunk-type position id positionX positionY)
   (chunk-type speed id vitesse)

   (chunk-type turn xRelativePosition)
   (chunk-type brake power)




   ;(declare-buffer-usage goal check-state :all )

   ;; ------------------------------ Add Chunks here ------------------------------

   (define-chunks 
      ;; les differents states du goal
      (save_model_weight isa chunk) 
      (save_model_pos   isa chunk)
      (save_model_speed isa chunk)
      (save_acc_pos     isa chunk)
      (save_acc_speed   isa chunk)
      (end_set          isa chunk)

      (remembering      isa chunk) 
      (begin-model      isa chunk)
      (choice           isa chunk) 
      (applyAction      isa chunk) 
      (finish           isa chunk) 
   )

   (add-dm
      ;;Les voitures sont générées par le code LISP

      (brakeSoft isa brake power 1)
      (brakeHard isa brake power 2)

      (turnR isa turn xRelativePosition 1) 
      (turnL isa turn xRelativePosition -1)

   ;; changement de vitesse

      ;(v1 ISA changeSpeed old "rapide" new "moyen")
      ;(v2 ISA changeSpeed old "moyen" new "lent")
   )

   
   ;; ------------------------------ Add productions here ------------------------------
        

   ;; -------------------- Première procédure  --------------------
   ;; Se lance au tout début afin d'initialiser les chunks
   ;; -------------------------------------------------------------



   (p start
      =goal>
         isa            check-state
         state          start
         m_weight       =a
         m_positionX    =b
         m_positionY    =c
         m_vitesse      =d
         a_positionX    =x
         a_positionY    =y
         a_vitesse      =z
      ==>
      =goal>
         isa            check-state
         state          save_model_weight
         m_weight       =a
         m_positionX    =b
         m_positionY    =c
         m_vitesse      =d
         a_positionX    =x
         a_positionY    =y
         a_vitesse      =z
   )
   
   ;; --------------- Start et enregistrement des donnees dans des chunks  ---------------
   ;; il faut faire plusieurs procedures car on a plusieurs chunks car apparemment 
   ;; cela essemble plus a un humain que de stocker ca en plusieurs fois
   ;; ------------------------------------------------------------------------------------

   (p set_model_0
      =goal>
         isa            check-state
         state          save_model_weight
         m_weight       =a
      ==>
      +imaginal>
         isa            car
         id             0
         weight         =a
      -imaginal> 
      =goal>
         state          save_model_pos
   )

   (p set_model_1
      =goal>
         isa            check-state
         state          save_model_pos
         m_positionX    =b
         m_positionY    =c
      ?imaginal>
         state          free
      ==>
      +imaginal> 
         isa            position
         id             0
         positionX      =b
         positionY      =c
      -imaginal> 
      =goal>
         state save_model_speed
   )

   (p set_model_2
      =goal>
         isa            check-state
         state          save_model_speed
         m_vitesse      =d
      ?imaginal>
         state          free
      ==>
      +imaginal> 
         isa            speed
         id             0
         vitesse        =d
      -imaginal> 
      =goal>
         state          save_acc_pos
   )

   (p set_accdt_1
      =goal>
         isa            check-state
         state          save_acc_pos
         a_positionX    =x
         a_positionY    =y
      ?imaginal>
         state          free
      ==>
      +imaginal> 
         isa            position
         id             1
         positionX      =x
         positionY      =y
      -imaginal> 
      =goal>
         state          save_acc_speed
   )

   (p set_accdt_2
      =goal>
         isa            check-state
         state          save_acc_speed
         m_vitesse      =z
      ?imaginal>
         state          free
      ==>
      +imaginal> 
         isa            speed
         id             1
         vitesse        =z
      -imaginal> 
      =goal>
         state          end_set
   )

   (p end_set_model_accdt
      =goal>
         isa            check-state
         state          end_set
         m_weight       =a
         m_positionX    =b
         m_positionY    =c
         m_vitesse      =d
         a_positionX    =x
         a_positionY    =y
         a_vitesse      =z
      ?imaginal>
         state          free
      ==>
      -imaginal> ;; Pour sauvegarder l'imaginal de set_accdt_2
      +retrieval> 
         isa            learned-info
         m_weight       =a
         m_positionX    =b
         m_positionY    =c
         m_vitesse      =d
         a_positionX    =x
         a_positionY    =y
         a_vitesse      =z
      =goal>
         state          remembering
   )


   ;; ----------------- Enregistrement des donnees  -----------------
   ;; On essaie de se souvenir si la situation s'est déjà présenté
   ;; Sinon, on tente de freiner, touner ou freiner fort
   ;; ---------------------------------------------------------------



   (p remember-organization
      =goal>
         isa            check-state
         state          remembering
      =retrieval>
         isa            learned-info
         result         =res
         t_left         =tl
         t_right        =tr
         b_soft         =bs
         b_hard         =bh
;; innutile je pense
         ;m_weight       =a
         ;m_positionX    =b
         ;m_positionY    =c
         ;m_vitesse      =d
         ;a_positionX    =x
         ;a_positionY    =y
         ;a_vitesse      =z
      ==>
      =goal>
         isa            learned-info
         state          applyAction
         result         =res
         t_left         =tl
         t_right        =tr
         b_soft         =bs
         b_hard         =bh
;; innutile je pense
         ;m_weight       =a
         ;m_positionX    =b
         ;m_positionY    =c
         ;m_vitesse      =d
         ;a_positionX    =x
         ;a_positionY    =y
         ;a_vitesse      =z
   )

   (p win-b-soft
      =goal>
         isa            learned-info
         state          applyAction
        -b_soft         lose
      ==>
      =goal>
         isa            brake
         power          1
   )

   (p win-b-hard
      =goal>
         isa            learned-info
         state          applyAction
        -b_hard         lose
      ==>
      =goal>
         isa            brake
         power          2
   )

   (p win-t-right
      =goal>
         isa            learned-info
         state          applyAction
        -t_right        lose
      ==>
      =goal>
         isa            turnR
         xRelativePosition 1
   )

   (p win-t-left
      =goal>
         isa            learned-info
         state          applyAction
        -t_left         lose
      ==>
      =goal>
         isa            turnL
         xRelativePosition -1
   )

   ;; est-ce qu'il faut faire les 4 mêmes pour lose ? 

   ;(p dont-Lose
   ;   =goal>
   ;      isa            check-state
   ;      state          applyAction
   ;      result         lose
   ;      action         =act
   ;   ==>
   ;   =goal>
   ;      state          choice
   ;     -result         =act ;; est ce que ça marche 
   ;)

   (p doesnt-remember-organization
      =goal>
         isa            check-state
         state          remembering
      ?retrieval>
         buffer         failure
      ==>
      =goal>
         state          begin-model
   )

   (p begin
      =goal>
         isa            check-state
         state          begin-model
      ==>
      ; Quand on sait pas quoi faire on freine doucement
      =goal>
         ISA            brake
         state          activate
         power          1

   )

   ;;;;;;;;;;;; Brakes ;;;;;;;;;;;;
   
   (p brakeSoft
      =goal>
         isa            brake
         state          activate
         power          1
     ?manual>
         state          free
   ==>
      =goal>
         ;isa            check-state
         state          nil
         ;action         1
      +manual>
         cmd            press-key
         key            "1"
   )
   
   (p brakeHard
      =goal>
         ISA            brake
         state          activate
         power          2
     ?manual>
         state          free
   ==>
      =goal>
         isa            check-state
         state          finish
         action         "2"
      +manual>
         cmd            press-key
         key            "2"
   )

   ;;;;;;;;;;;; Turns ;;;;;;;;;;;; 
   
   (p turnR
      =goal>
         ISA                  turn
         state                activate
         xRelativePosition    1
     ?manual>
         state          free
   ==>
      =goal>
         isa            check-state
         state          finish
         action         "3"
       +manual>
         cmd            press-key
         key            "3"
   )

   (p turnL
      =goal>
         ISA                  turn
         state                activate
         xRelativePosition    -1
     ?manual>
         state          free
   ==>
      =goal>
         isa            check-state
         state          finish
         action         "4"
       +manual>
         cmd            press-key
         key            "4"
   )
   
   ;;;;;;;;;;;;;;;; Take info ;;;;;;;;;;;;
   ;;
   ;;(p lookLeft
   ;;   =goal>
   ;;    ISA                 a
   ;;    a                   a
   ;;  =retrieval>
   ;;    ISA                 a
   ;;    a                   a
   ;;    a                   a
   ;;==>
   ;;  =goal>
   ;;   ; ???
   ;;  =retrieval>
   ;;    ISA speed
   ;;    a         a
   ;;    a         a
   ;;)
   ;;
   ;(goal-focus check-state)

)

