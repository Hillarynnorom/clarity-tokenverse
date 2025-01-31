;; StoryGraph Contract - Manages connections between story fragments

;; Data structures
(define-map story-connections
  uint ;; source fragment id
  (list 10 uint)) ;; connected fragment ids

(define-map connection-metadata
  {source: uint, target: uint} ;; connection pair
  {creator: principal, timestamp: uint})

;; Public functions
(define-public (connect-fragments (source-id uint) (target-id uint))
  (let ((current-connections (default-to (list) (map-get? story-connections source-id))))
    (asserts! (< (len current-connections) u10) (err u201))
    (map-set story-connections source-id (append current-connections target-id))
    (map-set connection-metadata {source: source-id, target: target-id}
      {creator: tx-sender, timestamp: block-height})
    (ok true)))

;; Read only functions
(define-read-only (get-connected-fragments (fragment-id uint))
  (map-get? story-connections fragment-id))
