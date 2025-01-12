# MP Debilpack

TYPY SĄ SPRAWDZANE PRZY KOMPILACJI
KONTRAKTY DOPIERO PRZY WYWOŁANIU FUNKCJI

# Lista 1

- eq? sprawdza czy to ten sam obiekt
- equal? sprawdza czy to obiekty o tych samych wartościach


let*
wyrażenie 1: inicjalizuje nazwę, oblicza wartość, przypisuje
itd.

letrec
wyrażenie 1: inicjalizuje nazwę
wyrażenie 2: inicjalizuje nazwę
...
wyrażenie 1: oblicza wartość, przypisuje do nazwy
wyrażenie 2: oblicza wartość, przypisuje do nazwy

Ogólnie zmienne w let widzą tylko powyżej
let* widzi wszystkie powyżej i obok
letrec widzi wszystko, pozwala na wzajemną rekurencję np. is-even is-odd odejmujący do zera

# Lista 2

- Wolne i związane wystąpienia zmiennych (związane - zadeklarowane w scope wyrażenia)

## Selection sort
- (cons (min l) (selection-sort (remove (min l) l)))
    - min zwraca najmniejszy element listy
    - remove usuwa element z listy
        - dla pustej zwraca pustą
        - gdy znajdziemy element cdr
        - wpp zwracamy (cons car (remove item cdr))

## Mergesort
- (merge (merge-sort (half l)) (merge-sort (other-half l)))
    - merge porównuje elementy i scala w odp. kolejności
    - split dzieli listę na dwie równe części:
        - najpierw deklarujemy wewnętrzną funkcję rekurencyjną z dwoma akumulatorami
        - robimy tam 3 checki - czy lista jest pusta, czy ma 1 element, czy ma 2 elementy
        - dla 0 zwracamy 2 akumulatory, dla 1 zwracamy (cons item acc1) acc2
        - dla 2 dodajemy po elemencie (car, cadr) i wywołujemy rek. dla cddr i akumulatorów


# Lista 3

- foldl i foldr - aplikujemy funkcję do listy (foldl od lewej, foldr od prawej) - przekazujemy funkcję, akumulator i listę

; Dobra definicja foldl wraz z kontraktem
(define/contract (foldl f x xs)
    (parametric->/c (a b) (-> (-> a b b) b (listof a) b))
    (if (empty? xs)
        x
        (foldl f (f (car xs) x) (cdr xs))
    )
)

# Lista 4

- Drzewa binarne - definiujemy node i leaf (gdzie node (left value right) a leaf to "pusty" node)

```scheme
(define (fold-tree f acc t)
    (cond 
        [(leaf? t) acc]
        [(node? t) 
            (f
                (node-elem t)
                (fold-tree f acc (node-l t))
                (fold-tree f acc (node-r t))
            )
        ]
    )
)
```

Tak ma wyglądać fold-tree, jak to masz git to wszystkie zadania braindead

# Lista 5

- Kontrakty

## Przykład

Napisz kontrakt dla append-map

```scheme
(define/contract (append-map f xs)
    (parametric->/c (a b) (-> (-> a (listof b)) (listof a) (listof b)))
    (if (null? xs)
        null
        (append 
            (f (car xs))
            (append-map f (cdr xs))
        )
    )
)
```

## Przykład 2

Czy następujące wyrażenia są dobrze typowane, i jeśli tak to jaki jest ich typ?

```scheme
(lambda (x) 
    (lambda (y) 
        (lambda (z) ((x z) (y z)))
    )
)
```

Lambdy ułożone są tak:

- {x} -> ({y} -> {z})

W ciele lambdy z zauważamy że x i y są funkcjami przyjmującymi ten sam typ (nazwijmy go 'a)


- (['a -> __]) -> (['a -> __] -> {z})

teraz zajmujemy się ciałem z

x też musi zwrócić funkcję (bo ((x z) (y z)))

- (['a -> [ __ -> __ ]]) -> (['a -> __] -> ['a -> __])

Podstawiamy typ argumentu dla y

- (['a -> [ 'b -> __ ]]) -> (['a -> __] -> ['a -> 'b])

i uzupełniając ostatni typ otrzymujemy

- (['a -> [ 'b -> 'c ]]) -> (['a -> 'c] -> ['a -> 'b])


# Lista 6

- Dowody indukcyjne
    - Dla wszystkiego co przyjmuje listy:
        - Zachodzi P(empty)
        - Dla każdego elementu x i listy xs jeśli zachodzi P(xs) to zachodzi P((cons x xs))

## Przykładowo:

```scheme

(define-type (Alist 'a)
    (a-null)
    (a-cons [hd : 'a] [tl : (Alist 'a)])
    (a-append [l : (Alist 'a)] [r : (Alist 'a)])
)

```

- Zachodzi P(a-null)
- Dla dowolnego elemetu x typu 'a oraz dowolnej listy xs typu (Alist 'a) jeśli zachodzi P(xs) to zachodzi P((a-cons x xs))
- Dla dowolnych list xs i ys typu (Alist 'a) jeśli zachodzi P(xs) i zachodzi P(ys) to zachodzi P((a-append xs ys))
Wtedy własność jest spełniona dla wszystkich list

<details><summary>Przykładowy dowód</summary>

```scheme

(define (a-rev xs)
    (type-case (Alist 'a) xs
        [(a-null) (a-null)]
        [(a-cons x xs) (a-append (a-rev xs) (a-cons x (a-null)))]
        [(a-append l r) (a-append (a-rev r) (a-rev l))]))
        
(define (to-list xs)
    (type-case (Alist 'a) xs
        [(a-null) empty]
        [(a-cons x xs) (cons x (to-list xs))]
        [(a-append l r) (a-append (a-rev r) (a-rev l))]))
    
(define (reverse xs)
    (type-case (Listof 'a) xs
        [empty empty]
        [(cons x xs) (append (reverse xs) (list x))]))

```

```
Dla powyższej implementacji udowodnimy że zachodzi (to-list (a-rev xs)) === (reverse (to-list xs))

1) P((a-null))

Niech xs == (a-null)

L = (to-list (a-rev xs)) == (to-list (a-null)) == empty
P = (reverse (to-list xs)) == (reverse empty) == empty

L === P

2) P((a-cons x xs))

Weźmy dowolne x typu 'a i xs typu (Alist 'a) i załóżmy że zachodzi P(xs). Pokażemy że zachodzi P(a-cons x xs)

L = (to-list (a-rev (a-cons x xs))) == 
(to-list (a-append (a-rev xs) (a-cons x (a-null)))) == 
(append (to-list (a-rev xs) (to-list (a-cons x (a-null))))) ==
(append (reverse (to-list xs)) (cons x empty))

Lemat 1 - dla dowolnego x i dowolnej list xs zachodzi
(append (reverse xs)(cons x empty)) == (reverse (cons x xs))

P = (reverse (to-list (a-cons x xs))) ==
(reverse (cons x (to-list xs)))

Zauważamy ze (to-list xs) oblicza się do listy plaitowej, zatem możemy skorzytsrać z lematu 1 i otrzymujemy

L == (reverse (cons x (to-list xs))) == P


3) P((a-append xs ys))
Weźmy dowolne xs i ys typu (Alist 'a) i załóżmy że zachodzi P(xs) i zachodzi P(ys). Pokażemy że zachodzi P((a-append xs ys))

L = (to-list (a-rev (a-append xs ys))) ==
(to-list (a-append (a-rev ys) (a-rev xs))) ==
(append (to-list (a-rev ys)) (to-list (a-rev xs))) ==
(append (reverse (to-list ys)) (reverse (to-list xs)))

P = (reverse (to-list (a-append xs ys))) ==
(reverse (append (to-list xs) (to-list ys)))

Lemat 2: Dla dowolnych list xs, ys zachodzi 
(append (reverse xs) (reverse ys)) == (reverse (append ys xs))

Korzystając z lematu 2 otrzymujemy

L == (reverse (append (to-list xs) (to-list ys))) == P

Zatem własność P zachodzi dla wszystkich Alist

```

</details>

<br><br>


# Lista 7

- Wystąpienia pozytywne i negatywne zmiennych

Negatywne wkładamy do pudełka, pozytywne z niego wyciągamy

### ! Ważne - uwaga na błąd!
Lecimy od prawej - jeśli mamy funkcję w funkcji to będzie to "na odwrót"

tzn dla prostego przypadku:

; (parametric->/c [a b] (-> a b a))
;  N N P (wkładamy zmienne typu a i b, wyciągamy a)

Ale tutaj już

; (parametric->/c [a b] (-> (-> a b) (listof a) (listof b)))
; P N N P (wyjdzie nam (listof b), (listof a) wkładamy jako argument
ale pierwsze a jest wystąpieniem pozytywnym (mimo że też my je dostarczamy))

; analogicznie
; (parametric- >/c [a b c] (-> (-> a b c) (-> a b) a c))
; P P N P N N P

; (parametric- >/c [a] (-> (-> (-> a a) a) a))
; N P N P

# Lista 8

- Programowanie imperatywne

Mamy opcję set! która zmienia wartość zmiennej 

Dla list: mutowalne pary, listy, wektory

mcons, mcar, mcdr
(set-mcar! {co} {na co})
(set-mcdr! {co} {na co})

(make-vector {rozmiar} {typ})
(vector-ref {wektor} {indeks}) - acessor
(vector-set! {wektor} {indeks} {wartość}) - setter

## Przykład zadania

Cykliczna lista łączona:

(define-struct node (elem [next #:mutable] [next-next #:mutable]))

musi zachodzić (eq? (node-next (node-next e)) (node-next-next e))

Mamy zaimplementować wstawianie elementu po next

Interesują nas pierwsze 4 elementy (+ ten który wstawiamy). Edytować będziemy wskaźniki w pierwszych dwóch (i we wstawianym)

```
(define (insert-after-next node elem)
    (let [new (make-node elem (node-next node) (node-next-next node))]
        (set-node-next! new (node-next-next node))
        (set-node-next-next! new (node-next-next (node-next node)))
        ... i tak dalej dla elementów node-next i node
    )
)
```

## mreverse bez tworzenia nowych elementów

```scheme
(define (mreverse lst)
    (let ((result (mcons '() '())))
        (let loop ((lst lst))
            (when (not (mnull? lst))
                (let ((temp (mcdr lst)))
                    (set-mcdr lst (mcdr result))
                    (set-mcdr result lst)
                    (set! lst temp)
                    (loop lst)
                )
            )
        )
        (mcdr result)
    )
)
```

# Lista 9, 10,11,12

- Parsery i interpretery, S-Expressions

Tutaj ważne są matchingi - przykładowe wyrażenie:

```scheme
(s-exp-match? `(lambda ANY ANY) expr)
```

Środowiska - przechowujemy wartości zmiennych

```scheme
(define-type Storable (valS [v : 'a]))
(define-type Binding (bind [name : Symbol] [ref : (Boxof Storable)]))
(define-type-alias Env (Listof Binding))
```


# Lista 13

- Strumienie

### Podstawowe definicje
```scheme
(define stream-car car)

(define (stream-cdr s)
    (force (cdr s))
)

(define (map2 f xs ys)
    (stream-cons
        (f 
            (stream-car xs)
            (stream-car ys)
        )
        (map2 f (stream-cdr xs) (stream-cdr ys))
    )
)
```

### Przykłady kodu
```scheme
(define ones (stream-cons 1 ones))

(define (integers-from n)
    (stream-cons n (integers-from (+ n 1)))
)

(define nats (integers-from 0))

(define fibs
    (stream-cons 0 (stream-cons 1 (map2 + fibs (stream-cdr fibs))))
)

(define fact
    (stream-cons 1 (map2 * (stream-cdr nats) fact))
)
```

### Iterator (wypisanie kodu)
```scheme
(define (iterate stream counter limit)
    (when (<= counter limit)
        (displayln (stream-ref stream counter))
        (iterate stream (+ counter 1) limit)
    )
)
```


# Laby

- Eksportujemy deklaracją provide (wewnątrz struct-out, contract-out)
- Improtujemy reqiure (pliki własne w katalogu 'nazwa.rkt')


# !!!
Zapytaj o kontrakty z pliku w folderze tasks
Ogarnij lepiej dowody indukcyjne