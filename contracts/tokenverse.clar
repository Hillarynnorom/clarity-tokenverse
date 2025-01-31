;; TokenVerse NFT Contract
(define-non-fungible-token story-fragment uint)

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))
(define-constant err-token-not-found (err u102))

;; Data vars
(define-data-var last-token-id uint u0)
(define-map fragment-content uint {text: (string-utf8 1000), author: principal, timestamp: uint})

;; Public functions
(define-public (mint-fragment (text (string-utf8 1000)))
  (let ((token-id (+ (var-get last-token-id) u1)))
    (try! (nft-mint? story-fragment token-id tx-sender))
    (map-set fragment-content token-id
      {text: text,
       author: tx-sender,
       timestamp: block-height})
    (var-set last-token-id token-id)
    (ok token-id)))

(define-public (transfer-fragment (token-id uint) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender (nft-get-owner? story-fragment token-id))
      err-not-token-owner)
    (try! (nft-transfer? story-fragment token-id tx-sender recipient))
    (ok true)))

;; Read only functions
(define-read-only (get-fragment-content (token-id uint))
  (map-get? fragment-content token-id))
