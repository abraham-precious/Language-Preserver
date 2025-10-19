;; Language Preserver - NFT Contract for Rare/Indigenous Words
;; A simple Clarity contract for minting rare words as NFTs with community ownership

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-already-exists (err u102))
(define-constant err-not-authorized (err u103))
(define-constant err-invalid-input (err u104))

;; Data Variables
(define-data-var next-token-id uint u1)
(define-data-var contract-uri (optional (string-ascii 256)) none)

;; Data Maps
(define-map token-owners uint principal)
(define-map token-uris uint (string-ascii 256))
(define-map word-registry (string-ascii 128) uint)
(define-map token-metadata uint {
    word: (string-ascii 128),
    language: (string-ascii 64),
    meaning: (string-ascii 256),
    cultural-significance: (string-ascii 512),
    contributor: principal,
    preservation-date: uint
})

;; Community ownership tracking
(define-map community-members principal bool)
(define-map token-community-votes uint {yes: uint, no: uint})

;; Public Functions

;; Mint a new word NFT
(define-public (mint-word (word (string-ascii 128)) 
                         (language (string-ascii 64))
                         (meaning (string-ascii 256))
                         (cultural-significance (string-ascii 512)))
    (let (
        (token-id (var-get next-token-id))
        (existing-token (map-get? word-registry word))
    )
    (asserts! (is-none existing-token) err-already-exists)
    (asserts! (> (len word) u0) err-invalid-input)
    (asserts! (> (len language) u0) err-invalid-input)
    (asserts! (> (len meaning) u0) err-invalid-input)
    (asserts! (>= (len cultural-significance) u0) err-invalid-input)

    (map-set token-owners token-id tx-sender)
    (map-set word-registry word token-id)
    (map-set token-metadata token-id {
        word: word,
        language: language,
        meaning: meaning,
        cultural-significance: cultural-significance,
        contributor: tx-sender,
        preservation-date: block-height
    })

    (var-set next-token-id (+ token-id u1))
    (ok token-id)))

;; Transfer ownership of a word NFT
(define-public (transfer (token-id uint) (sender principal) (recipient principal))
    (let ((owner (unwrap! (map-get? token-owners token-id) err-not-found)))
        (asserts! (or (is-eq tx-sender sender) (is-eq tx-sender owner)) err-not-authorized)
        (asserts! (is-eq owner sender) err-not-authorized)
        (asserts! (not (is-eq sender recipient)) err-invalid-input)
        (map-set token-owners token-id recipient)
        (ok true)))

;; Join community as a member
(define-public (join-community)
    (begin
        (map-set community-members tx-sender true)
        (ok true)))

;; Set token URI for metadata
(define-public (set-token-uri (token-id uint) (uri (string-ascii 256)))
    (let ((owner (unwrap! (map-get? token-owners token-id) err-not-found)))
        (asserts! (is-eq tx-sender owner) err-not-authorized)
        (asserts! (> (len uri) u0) err-invalid-input)
        (map-set token-uris token-id uri)
        (ok true)))

;; Read-only Functions

;; Get owner of a token
(define-read-only (get-owner (token-id uint))
    (map-get? token-owners token-id))

;; Get token metadata
(define-read-only (get-word-data (token-id uint))
    (map-get? token-metadata token-id))

;; Look up word by name
(define-read-only (lookup-word (word (string-ascii 128)))
    (map-get? word-registry word))

;; Get token URI
(define-read-only (get-token-uri (token-id uint))
    (map-get? token-uris token-id))

;; Check if address is community member
(define-read-only (is-community-member (member principal))
    (default-to false (map-get? community-members member)))

;; Get next available token ID
(define-read-only (get-next-token-id)
    (var-get next-token-id))

;; Get total supply
(define-read-only (get-total-supply)
    (- (var-get next-token-id) u1))

