#lang scheme
;compiling: yes
;complete : yes
;studentid: 2014400111

;(card-color one-card) -> string?
;one-card : pair of card suit and rank
;
;Finds the color of the card
;
;Examles
;(card-color '(H . A))
;=> red
;(card-color '(S . 5))
;=> black
(define (card-color one-card)
  (if (or (equal? (car one-card) 'H) (equal? (car one-card) 'D))
      'red
      'black))

;(card-rank one-card) -> integer?
;one-card : pair of card suit and rank
;
;Finds the rank of the card
;
;Examles
;(card-rank '(H . A))
;=> 11
;(card-rank '(S . 5))
;=> 5
(define (card-rank one-card)
  (cond
    ((equal? (cdr one-card) 'A) '11)
    ((equal? (cdr one-card) 'K) '10)
    ((equal? (cdr one-card) 'Q) '10)
    ((equal? (cdr one-card) 'J) '10)
    (else (cdr one-card))))

;(all-same-color list-of-cards) -> boolean?
;list-of-cards : list of cards  
;
;Finds whether the cards in the list have the same color or not
;
;Examles
;(all-same-color '((H . A)(H . 2)(D . 4)))
;=> #t
;(all-same-color '((S . 5)(D . 2)))
;=> #f
(define (all-same-color list-of-cards)
  (if (or (null? list-of-cards) (null? (cdr list-of-cards)))
     #t
     (let ([x (card-color (car list-of-cards))])       
      (if (not(equal? x (card-color (cadr list-of-cards))))
          #f
          (all-same-color (cdr list-of-cards))))))

;(fdraw list-of-cards held-cards) -> list?
;list-of-cards : list of cards that will be drawn
;held-cards : list of cards that is currently held
;
;Draws the next card from the list-of-cards and adds it to the held-cards
;
;Examples
;(fdraw '((H . 3) (H . 2)) '())
;=> '((H . 3))
;(fdraw '((H . 3) (H . 2)) '((H . Q)))
;=>'((H . Q) (H . 3))
(define (fdraw list-of-cards held-cards)
  (let ([x (car list-of-cards)])   
  (if (null? held-cards)
      (list x)
      (append held-cards (list x)))))

;MODIFY LATER
(define (fdiscard list-of-cards list-of-moves goal held-cards)
  (cdr held-cards))

(define (find-discarded list-of-cards list-of-moves goal held-cards)
  (car held-cards))

;(check-gameover1 list-of-moves) -> boolean?
;list-of-moves : list of the moves that will be performed
;
;Checks whether if the game is over according to condition no.1
;
;Examples
;(check-gameover1 '(draw))
;=> #f
;(check-gameover1 '())
;=> #t
(define (check-gameover1 list-of-moves)
  (if (null? list-of-moves)      
        #t
      #f))

;(check-gameover2-3 move list-of-cards held-cards) -> boolean?
;move : string of move
;list-of-cards : list of the cards
;held-cards : list of the held cards
;
;Checks whether the game is over according to the conditions no.2 and 3
;
;Example
;(check-gameover2-3 'draw '() '((H . 3)))
;=> #t
;(check-gameover2-3 'discard '((H . 3)) '())
;=> #t
(define (check-gameover2-3 move list-of-cards held-cards)
  (if (or (and (equal? move 'draw) (null? list-of-cards)) (and (equal? move 'discard) (null? held-cards)))      
        #t
      #f))

;(check-gameover4 held-cards goal) -> boolean?
;held-cards : list of cards that are currently held
;goal : integer goal of the game
;
;Checks whether the game is over according to the condition no.4
;
;Example
;(check-gameover4 '((H . A) (H . 5)) 11)
;=> #t
;(check-gameover4 '((H . 4)) 26)
;=> #f
(define (check-gameover4 held-cards goal)
  (let ([player-point (calc-playerpoint held-cards)])
    (if (< goal player-point)      
          #t
        #f)))

;(check-gameover list-of-cards list-of-moves goal held-cards) -> boolean?
;list-of-cards : list of the cards
;list-of-moves : list of the moves
;goal : integer goal of the game
;held-cards : list of the cards that are currently held
;
;Checks whether the game is over by any of the conditions
;Unification of check-game methods above
;
;No example will be given since examples are already given above
(define (check-gameover list-of-cards list-of-moves goal held-cards)
  (if (or (check-gameover1 list-of-moves) (check-gameover2-3 (car list-of-moves) list-of-cards held-cards) (check-gameover4 held-cards goal))
      #t
      #f))

;(calc-playerpoint held-cards) -> integer?
;held-cards : list of the cards that are currently held
;
;Calculates the playerpoint
;
;Examples
;(calc-playerpoint '((H . 4) (S . A)))
;=> 15
(define (calc-playerpoint held-cards)
  (if (null? held-cards)
      0
      (+ (card-rank (car  held-cards)) (calc-playerpoint (cdr held-cards)))))

;(fprescore goal held-cards) -> integer?
;goal : integer goal of the game
;held-cards : list of the cards that are currently held
;
;Calculates the prescore
;
;Example
;(fprescore 21 '((H . A) (S . 2)))
;=> 8
;(fprescore 21 '((H . A) (H . Q) (S . 4)))
;=> 20
(define (fprescore held-cards goal)
  (let ([player-point (calc-playerpoint held-cards)])
    (if (< 0 (- player-point goal))
        (* 5 (- player-point goal))
        (- goal player-point))))

;(calc-score goal held-cards) -> integer?
;goal : integer goal of the game
;held-cards : list of the cards that are currently held
;
;Calculates the score
;
;Example
;(calc-score 16 '((H . 5)))
;=> 5
(define (calc-score held-cards goal)
  (let ([prescore (fprescore held-cards goal)])
    (if (all-same-color held-cards)
        (floor (/ prescore 2))
        prescore)))

;(find-steps list-of-cards list-of-moves goal) -> list?
;list-of-cards : list of the cards
;list-of-moves : list of the moves
;goal : integer goal of the game
;Initiates the process of finding steps by calling find-steps2 function
;
;Example
;(find-steps '((H . 3) (H . 2) (H . A) (D . J) (D . Q) (C . J)) '(draw draw draw discard) 16)
;=> '((draw (H . 3)) (draw (H . 2)) (draw (H . A)) (discard (H . 3)))
(define (find-steps list-of-cards list-of-moves goal )
  (find-steps2 list-of-cards list-of-moves goal '() '()))

;(find-steps list-of-cards list-of-moves goal held-cards olist) -> list?
;list-of-cards : list of the cards
;list-of-moves : list of the moves
;goal : integer goal of the game
;held-cards : list of cards that are currently held
;olist : final output list that contains the list of the steps
;
;Finds the list of the steps
;
;Example
;(find-steps '((H . 3) (H . 2) (H . A) (D . J) (D . Q) (C . J)) '(draw draw draw discard) 16 '() '())
;=> '((draw (H . 3)) (draw (H . 2)) (draw (H . A)) (discard (H . 3)))
(define (find-steps2 list-of-cards list-of-moves goal held-cards olist)
  (if (check-gameover list-of-cards list-of-moves goal held-cards)
      olist
      (cond
        ((and (equal? (car list-of-moves) 'draw) (null? olist))                        
                (find-steps2 (cdr list-of-cards) (cdr list-of-moves) goal  (fdraw list-of-cards held-cards) (list (list 'draw (car list-of-cards)))))
        ((and (equal? (car list-of-moves) 'draw) (not (null? olist)))                            
               (find-steps2 (cdr list-of-cards) (cdr list-of-moves) goal  (fdraw list-of-cards held-cards) (append olist (list (list 'draw (car list-of-cards))))))
        ((and (equal? (car list-of-moves ) 'discard))                          
               (find-steps2
                (cdr list-of-cards)
                (cdr list-of-moves)
                goal
                (fdraw list-of-cards (fdiscard list-of-cards list-of-moves goal held-cards))
                (append olist (list (list 'discard (find-discarded list-of-cards list-of-moves goal held-cards)))))))))

;(remove-from-list alist element) -> list?
;alist : list
;element : element that we want to remove from the list
;
;Removes all apereances of the element from the list
;
;Example
;(remove-from-list '(1 2 3 4) 2)
;=> '(1 3 4)
(define (remove-from-list alist element)  
  (if (null? alist)
      '()
      (if (equal? (car alist) element)
          (cdr alist) 
          (cons (car alist) (remove-from-list (cdr alist) element)))))
  
;(find-held-cards list-of-steps) -> list?
;list-of-steps : list of the steps
;
;Initiates the proces to find the final held cards by calling find-held-cards2 method
;Finds the held cards after the steps are taken
;
;Example
;( find-held-cards '((draw (H . 3)) (draw (H . 2)) (draw (H . A)) (discard (H . 3))))
;'((H . 2) (H . A))
(define (find-held-cards list-of-steps)
  (find-held-cards2 list-of-steps '()))

;(find-held-cards list-of-steps olist) -> list?
;list-of-steps : list of the steps
;olist : final held cards after the steps in the list-of-steps are taken
;
;Finds the held cards after the steps are taken
;
;Example
;( find-held-cards '((draw (H . 3)) (draw (H . 2)) (draw (H . A)) (discard (H . 3))) '())
;'((H . 2) (H . A))
(define (find-held-cards2 list-of-steps olist)  
  (if (null? list-of-steps)
      olist
      (cond
        ((and (equal? (car (car list-of-steps)) 'draw) (null? olist))
         (find-held-cards2 (cdr list-of-steps)  (cdr (car list-of-steps))))
        ((and (equal? (car (car list-of-steps)) 'draw) (not (null? olist)))
         (find-held-cards2 (cdr list-of-steps) (append olist  (cdr (car list-of-steps)))))
        ((and (equal? (car (car list-of-steps )) 'discard))
         (find-held-cards2 (cdr  list-of-steps) (remove-from-list olist (car (cdr (car list-of-steps)))))))))

;(play list-of-cards list-of-moves goal) -> integer?
;list-of-cards : list of the cards
;list-of-moves : list of the moves
;goal : goal of the game
;
;Initiates the process of play by calling play2 function
;Finds the final score of the game
;
;Example
;(play '((H . 3) (H . 2) (H . A) (D . J) (D . Q) (C . J)) '(draw draw draw discard) 16)
;=> 1
(define (play list-of-cards list-of-moves goal )
  (play2 list-of-cards list-of-moves goal '()))

;(play list-of-cards list-of-moves goal held-cards) -> integer?
;list-of-cards : list of the cards
;list-of-moves : list of the moves
;goal : goal of the game
;held-cards : list of the cards that are currently held
;
;Finds the final score of the game
;
;Example
;(play '((H . 3) (H . 2) (H . A) (D . J) (D . Q) (C . J)) '(draw draw draw discard) 16 '())
;=> 1
(define (play2 list-of-cards list-of-moves goal held-cards)
  (if (check-gameover list-of-cards list-of-moves goal held-cards)
      (calc-score held-cards goal)
      (let ([x (car list-of-moves)])
        (cond
          ((equal? x 'draw)
           (play2 (cdr list-of-cards) (cdr list-of-moves) goal (fdraw list-of-cards held-cards)))
          ((equal? x 'discard)
           (play2 list-of-cards (cdr list-of-moves) goal (fdiscard list-of-cards (cdr list-of-moves) goal held-cards)))))))
        

